//
//  LiveRoomViewController.swift
//  AgoraInjectStreaming
//
//  Created by ZhangJi on 2018/7/19.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit


let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

let RecordUrl = "http://123.155.153.85:3233/v1/recording/start"
let StopUrl = "http://123.155.153.85:3233/v1/recording/stop"

class LiveRoomViewController: UIViewController {
    
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var audioMuteButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var rtmpButton: UIButton!
    @IBOutlet weak var injectConfigButton: UIButton!
    @IBOutlet weak var remoteContainerView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    var roomName: String!
    var myUid: UInt!
    var clientRole = AgoraClientRole.audience {
        didSet {
            updateButtonsVisiablity()
        }
    }
    
    var videoProfile: AgoraVideoProfile!
    
    fileprivate var isBroadcaster: Bool {
        return clientRole == .broadcaster
    }
    
    var rtcEngine: AgoraRtcEngineKit!
    
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
    
    fileprivate var injectStreamConfig = AgoraLiveInjectStreamConfig()
    
    fileprivate var injectRtmpUrl: String?
    
    fileprivate lazy var poster: ServerHelper = {
        let poster = ServerHelper()
        poster.delegate = self
        return poster
    }()
    
    @IBAction func doDoubleTapped(_ sender: UITapGestureRecognizer) {
        if fullSession == nil {
            if let tappedSession = viewLayouter.responseSession(of: sender, inSessions: videoSessions, inContainerView: remoteContainerView) {
                fullSession = tappedSession
            }
        } else {
            fullSession = nil
        }
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
    
    @IBAction func doSwitchCameraPressed(_ sender: UIButton) {
        rtcEngine.switchCamera()
    }
    
    @IBAction func doMutePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        rtcEngine.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func doRtmpPressed(_ sender: UIButton) {
        if sender.isSelected {
            rtcEngine.removeInjectStreamUrl(injectRtmpUrl!)
            self.injectRtmpUrl = nil
        } else {
            let popView = PopView.newPopViewWith(buttonTitle: "Add Stream", placeholder: "Input Rtmp URL ...")
            popView?.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight)
            popView?.delegate = self
            self.view.addSubview(popView!)
            UIView.animate(withDuration: 0.2) {
                popView?.frame = self.view.frame
            }
        }
    }
    
    @IBAction func doRecordPressed(_ sender: UIButton) {
        let paramDic = ["appid" : KeyCenter.AppId,
                        "channel": self.roomName,
                        "uid": myUid] as [String : Any]
        if sender.isSelected {
            self.poster.postAction(to: StopUrl, with: paramDic)
        } else {
            self.poster.postAction(to: RecordUrl, with: paramDic)
        }
    }
    
    @IBAction func doLeavePressed(_ sender: UIButton) {
        leaveChannel()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomNameLabel.text = roomName
        updateButtonsVisiablity()
        
        loadAgoraKit()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, !segueId.isEmpty else {
            return
        }
        switch segueId {
        case "channelPopInjectConfig":
            let injectConfigVC = segue.destination as! InjectStreamConfigTableViewController
            injectConfigVC.injectStreamConfig = injectStreamConfig
            injectConfigVC.delegate = self
            injectConfigVC.popoverPresentationController?.delegate = self
        default:
            break
        }
    }
}

private extension LiveRoomViewController {
    func updateButtonsVisiablity() {
        guard let broadcastButton = self.broadcastButton, let switchButton = self.switchButton,  let audioMuteButton = self.audioMuteButton else {
            return
        }
        broadcastButton.isSelected = self.isBroadcaster
        switchButton.isHidden = !self.isBroadcaster
        audioMuteButton.isHidden = !self.isBroadcaster
    }
    
    func updateInterface(withAnimation animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.3) {
                self.updateInterface()
                self.view.layoutIfNeeded()
            }
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
                rtcEngine.setRemoteVideoStream(session.uid, type: (session == fullSession ? .high : .low))
            }
        } else {
            for session in sessions {
                rtcEngine.setRemoteVideoStream(session.uid, type: .high)
            }
        }
    }
    
    func addLocalSession() {
        let localSession = VideoSession.localSession()
        videoSessions.append(localSession)
        rtcEngine.setupLocalVideo(localSession.canvas)
    }
    
    func fetchSession(ofUid uid: UInt) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        return nil
    }
    
    func videoSession(ofUid uid: UInt) -> VideoSession {
        if let fetchedSession = fetchSession(ofUid: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }
    
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
    
    func alert(string: String) {
        guard !string.isEmpty else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Agora Media SDK
private extension LiveRoomViewController {
    func loadAgoraKit() {
        rtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        rtcEngine.setChannelProfile(.liveBroadcasting)
        rtcEngine.enableDualStreamMode(true)
        rtcEngine.enableVideo()
        rtcEngine.setVideoProfile(videoProfile, swapWidthAndHeight: false)
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
    }
}

extension LiveRoomViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        myUid = uid
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let userSession = videoSession(ofUid: uid)
        rtcEngine.setupRemoteVideo(userSession.canvas)
        
        // check if is the RTMP stream
        if uid == 666 {
            if injectRtmpUrl == nil {
                rtmpButton.isHidden = true
                injectConfigButton.isHidden = true
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        if let _ = videoSessions.first {
            updateInterface(withAnimation: false)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() {
            if session.uid == uid {
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
        
        // check if is the RTMP stream
        if uid == 666 {
            if injectRtmpUrl == nil {
                rtmpButton.isHidden = false
                injectConfigButton.isHidden = false
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, streamInjectedStatusOfUrl url: String, uid: UInt, status: AgoraInjectStreamStatus) {
        switch status {
        case .startSuccess:
            self.rtmpButton.isSelected = true
        case .stopSuccess:
            self.rtmpButton.isSelected = false
        default:
            self.alert(string: "streamInjectedStatusOfUrl: \(status.rawValue)")
        }
    }
}

extension LiveRoomViewController: InjectStreamConfigTableVCDelegate {
    func injectStreamConfigTableVCDidUpdate(_ injectStreamConfigTableVC: InjectStreamConfigTableViewController) {
        injectStreamConfig = injectStreamConfigTableVC.injectStreamConfig
    }
}

//MARK: - popover
extension LiveRoomViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension LiveRoomViewController: PopViewDelegate {
    func popViewButtonDidPressed(_ popView: PopView) {
        guard let url = popView.inputTextField.text else {
            return
        }
        self.injectRtmpUrl = url
        rtcEngine.addInjectStreamUrl(url, config: self.injectStreamConfig)
        
        popView.removeFromSuperview()
    }
}

extension LiveRoomViewController: ServerHelperDelagate {
    func serverHelper(_ serverHelper: ServerHelper, url: String, data: Data, error: Error?) {
        do {
            let jsonData: NSDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
            DispatchQueue.main.async {
                switch url {
                case StopUrl:
                    self.recordButton.isSelected = false
                case RecordUrl:
                    self.recordButton.isSelected = true
                default:
                    return
                }
            }
        } catch  {
            AlertUtil.showAlert(message: "Connect server error!")
            return
        }
    }
}
