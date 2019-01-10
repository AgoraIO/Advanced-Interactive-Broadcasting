//
//  LiveRoomViewController.swift
//  AgoraPushStreaming
//
//  Created by ZhangJi on 2018/9/28.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit

protocol LiveRoomVCDelegate: NSObjectProtocol {
    func liveVCNeedClose(_ liveVC: LiveRoomViewController)
}

class LiveRoomViewController: UIViewController {
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var remoteContainerView: UIView!
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet var sessionButtons: [UIButton]!
    @IBOutlet weak var audioMuteButton: UIButton!
    @IBOutlet weak var rtmpPushButton: UIButton!
    
    var roomName: String!
    var clientRole = AgoraClientRole.audience {
        didSet {
            updateButtonsVisiablity()
        }
    }
    var videoProfile: CGSize!
    weak var delegate: LiveRoomVCDelegate?
    
    //MARK: - engine & session view
    var rtcEngine: AgoraRtcEngineKit!
    fileprivate var isBroadcaster: Bool {
        return clientRole == .broadcaster
    }
    fileprivate var isMuted = false {
        didSet {
            rtcEngine?.muteLocalAudioStream(isMuted)
            audioMuteButton?.setImage(UIImage(named: isMuted ? "btn_mute_cancel" : "btn_mute"), for: .normal)
        }
    }
    
    fileprivate var videoSessions = [VideoSession]() {
        didSet {
            guard remoteContainerView != nil else {
                return
            }
            updateInterface(withAnimation: true)
        }
    }
    fileprivate var fullSession: VideoSession? {
        didSet {
            if fullSession != oldValue && remoteContainerView != nil {
                updateInterface(withAnimation: true)
            }
        }
    }
    
    fileprivate let viewLayouter = VideoViewLayouter()
    
    fileprivate var chatMessageVC: ChatMessageViewController?
    
    fileprivate var rtmpPublishing = false{
        didSet{
            rtmpPushButton.setImage(rtmpPublishing ? #imageLiteral(resourceName: "btn_rtmp_blue"):#imageLiteral(resourceName: "btn_rtmp"), for: .normal)
        }
    }
    
    fileprivate var isPublishing = false
    fileprivate var publishList = PublishList()
    
    fileprivate var transcoding = AgoraLiveTranscoding()
    fileprivate var isCustomTranscodingSetting = false
    fileprivate var isOnlyUseChannel0 = true
    fileprivate var transcodingLayout:TranscodingLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomNameLabel.text = roomName
        updateButtonsVisiablity()
        
        loadAgoraKit()
    }
    
    //MARK: - user action
    @IBAction func doSwitchCameraPressed(_ sender: UIButton) {
        rtcEngine?.switchCamera()
    }
    
    @IBAction func doMutePressed(_ sender: UIButton) {
        isMuted = !isMuted
    }
    
    @IBAction func doBroadcastPressed(_ sender: UIButton) {
        if isBroadcaster {
            clientRole = .audience
            if fullSession?.uid == 0 {
                fullSession = nil
            }
        } else {
            clientRole = .broadcaster
        }
        
        rtcEngine.setClientRole(clientRole)
        updateInterface(withAnimation :true)
    }
    
    @IBAction func doDoubleTapped(_ sender: UITapGestureRecognizer) {
        if fullSession == nil {
            if let tappedSession = viewLayouter.responseSession(of: sender, inSessions: videoSessions, inContainerView: remoteContainerView) {
                fullSession = tappedSession
            }
        } else {
            fullSession = nil
        }
    }
    
    @IBAction func doLeavePressed(_ sender: UIButton) {
        leaveChannel()
    }
}

extension LiveRoomViewController: UIPopoverPresentationControllerDelegate{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier,!segueId.isEmpty else {
            return
        }
        switch segueId {
        case "channelPopTranscoding":
            let vc = segue.destination as! TranscodingTableViewController
            vc.transcoding = transcoding
            vc.isCustomTranscodingSettings = isCustomTranscodingSetting
            vc.isOnlyChannel0 = isOnlyUseChannel0
            vc.transcodingLayout = transcodingLayout
            vc.delegate = self
            vc.popoverPresentationController?.delegate = self
            
//        case "channelPopSubscribeTable":
//            let subscribeVC = segue.destination as! SubscribeTableViewController
//            subscribeVC.subscribeList = subscribeList
//            subscribeVC.isPublishing = true
//            subscribeVC.delegate = self
//            subscribeVC.popoverPresentationController?.delegate = self
//            subscribeTableVC = subscribeVC
//
        case "channelPopSingleStream":
            let pushRtmpVC = segue.destination as! PublishViewController
            pushRtmpVC.publishList = publishList
            pushRtmpVC.delegate = self
            pushRtmpVC.popoverPresentationController?.delegate = self

        case "channelEmbedChat":
            chatMessageVC = segue.destination as? ChatMessageViewController
//
//        case "channelPopVideoAction":
//            let videoActionVC = segue.destination as! VideoActionTableViewController
//            videoActionVC.isPublishing = isPublishing
//            videoActionVC.delegate = self
//            videoActionVC.popoverPresentationController?.delegate = self
        default:
            break
        }
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

private extension LiveRoomViewController {
    func updateButtonsVisiablity() {
        guard let sessionButtons = sessionButtons else {
            return
        }
        
        broadcastButton?.setImage(UIImage(named: isBroadcaster ? "btn_join_cancel" : "btn_join"), for: .normal)
        
        for button in sessionButtons {
            button.isHidden = !isBroadcaster
        }
    }
    
    func leaveChannel() {
        setIdleTimerActive(true)
        
        rtcEngine.setupLocalVideo(nil)
        rtcEngine.leaveChannel(nil)
        if isBroadcaster {
            rtcEngine.stopPreview()
        }
        
        for session in videoSessions {
            session.hostingView.removeFromSuperview()
        }
        videoSessions.removeAll()
        
        delegate?.liveVCNeedClose(self)
    }
    
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
    
//    func alert(string: String) {
//        guard !string.isEmpty else {
//            return
//        }
//        
//        let alert = UIAlertController(title: nil, message: string, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
}

private extension LiveRoomViewController {
    func updateInterface(withAnimation animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.updateInterface()
                self?.view.layoutIfNeeded()
            })
        } else {
            updateInterface()
        }
    }
    
    func updateInterface() {
        var displaySessions = videoSessions
        if !isBroadcaster && !displaySessions.isEmpty {
            displaySessions.removeFirst()
        }
        viewLayouter.layout(sessions: displaySessions, fullSession: fullSession, inContainer: remoteContainerView)
        setStreamType(forSessions: displaySessions, fullSession: fullSession)
    }
    
    func setStreamType(forSessions sessions: [VideoSession], fullSession: VideoSession?) {
        if let fullSession = fullSession {
            for session in sessions {
                rtcEngine.setRemoteVideoStream(UInt(session.uid), type: (session == fullSession ? .high : .low))
            }
        } else {
            for session in sessions {
                rtcEngine.setRemoteVideoStream(UInt(session.uid), type: .high)
            }
        }
    }
    
    func addLocalSession() {
        let localSession = VideoSession.localSession()
        videoSessions.append(localSession)
        rtcEngine.setupLocalVideo(localSession.canvas)
    }
    
    func fetchSession(ofUid uid: Int64) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        
        return nil
    }
    
    func videoSession(ofUid uid: Int64) -> VideoSession {
        if let fetchedSession = fetchSession(ofUid: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }
}

//MARK: - Agora Media SDK
private extension LiveRoomViewController {
    func loadAgoraKit() {
        rtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        rtcEngine.setChannelProfile(.liveBroadcasting)
        rtcEngine.enableDualStreamMode(true)
        rtcEngine.enableVideo()
        rtcEngine.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: videoProfile,
                                                                              frameRate: .fps15,
                                                                              bitrate: AgoraVideoBitrateStandard,
                                                                              orientationMode: .adaptative))
        rtcEngine.setClientRole(clientRole)
        
        if isBroadcaster {
            rtcEngine.startPreview()
        }
        
        addLocalSession()
        
        let code = rtcEngine.joinChannel(byToken: nil, channelId: roomName, info: nil, uid: 0, joinSuccess: nil)
        if code == 0 {
            setIdleTimerActive(false)
            rtcEngine.setEnableSpeakerphone(true)
        } else {
            DispatchQueue.main.async(execute: {
                self.alert(string: "Join channel failed: \(code)")
            })
        }
    }
}

extension LiveRoomViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let userSession = videoSession(ofUid: Int64(uid))
        rtcEngine.setupRemoteVideo(userSession.canvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        if let _ = videoSessions.first {
            updateInterface(withAnimation: false)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() {
            if session.uid == Int64(uid) {
                indexToDelete = index
            }
        }
        
        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()
            
            if deletedSession == fullSession {
                fullSession = nil
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, streamPublishedWithUrl url: String, errorCode: AgoraErrorCode) {
        let success = errorCode == .noError
        if success {
            info(string: "published With: \(url)")
        } else {
            info(string: "publish Failed With: \(url), errorCode: \(errorCode.rawValue)")
        }
        publishList.setResult(for: url, isSuccess: success)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, streamUnpublishedWithUrl url: String) {
        info(string: "unpublished With: \(url)")
    }
}

//MARK: - infos
extension LiveRoomViewController{
    func alert(string:String) {
        guard !string.isEmpty else{
            return
        }
        chatMessageVC?.append(info: string)
    }
    func warning(string:String){
        guard !string.isEmpty else {
            return
        }
        chatMessageVC?.append(warning: string)
    }
    func info(string:String){
        guard !string.isEmpty else{
            return
        }
        chatMessageVC?.append(info: string)
    }
    
}

//MARK:- TransCodingDelegate 实时设置推流参数
extension LiveRoomViewController: TranscodingTableVCDelegate{
    func transcodingTableVCDidUpdate(_ transcodingTableVC: TranscodingTableViewController) {
        transcoding = transcodingTableVC.transcoding
        transcodingLayout = transcodingTableVC.transcodingLayout
        isCustomTranscodingSetting = transcodingTableVC.isCustomTranscodingSettings
        isOnlyUseChannel0 = transcodingTableVC.isOnlyChannel0
        if isCustomTranscodingSetting{
            transcoding.transcodingUsers = transcodingLayout?.users(ofSessions: videoSessions, fullSession: fullSession, canvasSize: transcoding.size, isOnlyChannel0: isOnlyUseChannel0)
            rtcEngine.setLiveTranscoding(transcoding)
        }else{
            rtcEngine.setLiveTranscoding(nil)
        }
    }
}

//MARK:- PublisherDelegate
extension LiveRoomViewController: PublishVCDelegate{
    func publishVC(_ publishVC: PublishViewController, didAddPublishInfo info: PublishInfo) {
        info.start()
        if info.isTranscoding {
            rtcEngine.setLiveTranscoding(transcoding)
            self.isCustomTranscodingSetting = true
        }
        rtcEngine.addPublishStreamUrl(info.url, transcodingEnabled: info.isTranscoding)
        rtmpPublishing = publishList.infos.count > 0
    }
    
    func publishVC(_ publishVC: PublishViewController, didRemovePublishInfo info: PublishInfo) {
        rtcEngine.removePublishStreamUrl(info.url)
        info.stop()
        rtmpPublishing = publishList.infos.count > 0
        
    }
}
