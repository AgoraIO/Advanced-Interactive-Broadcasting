//
//  ChannelViewController.swift
//  AgoraPushStreaming
//
//  Created by 湛孝超 on 2018/2/26.
//  Copyright © 2018年 湛孝超. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var RtmpPublishBtn: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    var channelConfig:AgoraLiveChannelConfig!
    @IBOutlet weak var containerView: UIView!
    var localRenderMode = AgoraVideoRenderMode.hidden
    var videoProfile = AgoraVideoProfile.portrait360P
    var audioProfile = AgoraAudioProfile.default
    var audioScenario = AgoraAudioScenario.default
    var dualStreamType = DualStreamType.auto
    var channel:String!
    var customParameters:CustomParameters!
    var viewLayouter = VideoViewLayouter()
    fileprivate var isPublishing = false
    fileprivate var publishList = PublishList()
    //MARK: engine
    fileprivate let liveKit = AgoraLiveKit.sharedLiveKit(withAppId: <#Appid#>)
    
    fileprivate var publisher:AgoraLivePublisher!
    fileprivate var subscriber:AgoraLiveSubscriber!
    fileprivate var mediatype = AgoraMediaType.audioAndVideo
    
    fileprivate var transcoding = AgoraLiveTranscoding()
    fileprivate var isCustomTranscodingSetting = false
    fileprivate var isOnlyUseChannel0 = true
    fileprivate var transcodingLayout:TranscodingLayout?
    fileprivate var chatMessageVC:ChatMessageViewController?
    fileprivate var subscribeTableVC:SubscribeTableViewController?
    fileprivate var subscribeList = SubscribeList(){
        didSet{
            subscribeTableVC?.subscribeList = subscribeList
        }
    }
    fileprivate var doubleClickFullSession:(session:VideoSession?,isForce:Bool) = (session:nil,isForce:false){
        didSet{
            updateInterface(withAnimation: true, targetSize: containerView.frame.size)
        }
    }
    fileprivate var videoSessions =  [VideoSession](){
        didSet{
            updateInterface(withAnimation: true, targetSize: containerView.frame.size)
        }
    }
    fileprivate var rtmpPublishing = false{
        didSet{
            RtmpPublishBtn.setImage(rtmpPublishing ? #imageLiteral(resourceName: "btn_rtmp_blue"):#imageLiteral(resourceName: "btn_rtmp"), for: .normal)
        }
    }
    fileprivate var localUid:UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelNameLabel.text = channel
        
        //SDK init
        let engineKit = liveKit.getRtcEngineKit()
        switch dualStreamType {
        case .enable:
            engineKit.enableDualStreamMode(true)
        case .disable:
            engineKit.enableDualStreamMode(false)
        default:
            break
        }
        setCustomParameters(customParameters: customParameters, agoraKit: engineKit)
        
        publisher = AgoraLivePublisher(liveKit: liveKit)
        publisher.setVideoResolution(videoProfile.resolution()!, andFrameRate: videoProfile.fps(), bitrate: videoProfile.bitRate()!)
        publisher.setDelegate(self)
        subscriber = AgoraLiveSubscriber(liveKit: liveKit)
        subscriber.setDelegate(self)
        
        let rtcEngine = liveKit.getRtcEngineKit()
        rtcEngine.setAudioProfile(audioProfile, scenario: audioScenario)
        
        if let size = videoProfile.resolution(){
            transcoding.size = size
        }
        if  let bitrate = videoProfile.bitRate() {
            transcoding.videoBitrate = bitrate
        }
        transcoding.videoFramerate = videoProfile.fps()
        transcoding.audioBitrate = audioProfile.biterate()
        transcoding.audioChannels = audioProfile.channels()
        viewLayouter.containerView = containerView
        creatLocalSession()
        joinChannel()
        //防止锁屏
        UIApplication.shared.isIdleTimerDisabled = true
    }
    func joinChannel() {
        liveKit.delegate = self
        liveKit.joinChannel(byToken: nil, channelId: channel, config: channelConfig, uid: 0)
        startPreview()
    }
    
    
    func creatLocalSession() {
        let localSession = VideoSession.localSession(renderMode: localRenderMode)
        videoSessions.append(localSession)
        if let mediaInfo = MediaInfo(videoProfile:videoProfile) {
            localSession.mediaInfo = mediaInfo
        }
        
    }
    func createSession(of uid:UInt,renderMode:AgoraVideoRenderMode)->VideoSession{
        if let fetchedSession = fetchSession(of: uid){
            fetchedSession.renderMode = renderMode
            return fetchedSession
        }else{
            let newSession = VideoSession(uid: uid)
            newSession.renderMode = renderMode
            videoSessions.append(newSession)
            return newSession
        }
    }
    func fetchSession(of uid:UInt) -> VideoSession? {
        var fetchUid = uid
        if uid == 0 && localUid != 0  {
            fetchUid = localUid
        }
        for session in videoSessions {
            if session.uid == fetchUid{
                return session
            }
        }
        return nil
    }
    func removeSession(of uid: UInt) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() {
            if session.uid == uid {
                indexToDelete = index
            }
        }
        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()
            if doubleClickFullSession.session == deletedSession {
                self.doubleClickFullSession = (session: nil, isForce: false)
            }
        }
    }
    func startPreview() {
        liveKit.startPreview((videoSessions.first?.hostingView)!, renderMode: localRenderMode)
        updateInterface(withAnimation: false, targetSize: containerView.frame.size)
    }
    
    @IBAction func btn_close(_ sender: Any) {
        
        liveKit.leaveChannel()
        navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
//MARK:初始化SDK的方法
private extension ChannelViewController{
  
    func setCustomParameters(customParameters:CustomParameters , agoraKit:AgoraRtcEngineKit){
        for customparameter in customParameters.list
        {
            let json = customparameter.jsonString()
            agoraKit.setParameters(json)
        }
    }
    
}
//MARK: -segue
extension ChannelViewController:UIPopoverPresentationControllerDelegate{
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
            
        case "channelPopSubscribeTable":
            let subscribeVC = segue.destination as! SubscribeTableViewController
            subscribeVC.subscribeList = subscribeList
            subscribeVC.isPublishing = true
            subscribeVC.delegate = self
            subscribeVC.popoverPresentationController?.delegate = self
            subscribeTableVC = subscribeVC
            
        case "channelPopSingleStream":
            let pushRtmpVC = segue.destination as! PublishViewController
            pushRtmpVC.publishList = publishList
            pushRtmpVC.delegate = self
            pushRtmpVC.popoverPresentationController?.delegate = self
            
        case "channelEmbedChat":
            chatMessageVC = segue.destination as? ChatMessageViewController
            
        case "channelPopVideoAction":
            let videoActionVC = segue.destination as! VideoActionTableViewController
            videoActionVC.isPublishing = isPublishing
            videoActionVC.delegate = self
            videoActionVC.popoverPresentationController?.delegate = self
        default:
            break
        }
  
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
//MARK: - infos
extension ChannelViewController{
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
//MARK:- live kit Delegate
extension ChannelViewController:AgoraLiveDelegate{
    func liveKit(_ kit: AgoraLiveKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        info(string: "did Join Channel \(channel) with:\(uid) elapsed:\(elapsed)")
    }
    func liveKit(_ kit: AgoraLiveKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        info(string: "did Join Channel \(channel) with:\(uid) elapsed:\(elapsed)")
        
    }
    func liveKit(_ kit: AgoraLiveKit, didOccurWarning warningCode: AgoraWarningCode) {
        warning(string: "did Occur Warning:\(warningCode.rawValue)")
    }
    func liveKit(_ kit: AgoraLiveKit, didOccurError errorCode: AgoraErrorCode) {
        alert(string: "did OccurError :\(errorCode.rawValue)")
    }
    func liveKitConnectionDidInterrupted(_ kit: AgoraLiveKit) {
        alert(string: "connection Did Interrupted")
    }
    func liveKitConnectionDidLost(_ kit: AgoraLiveKit) {
        alert(string: "connnection Did Lost")
    }
}
//MARK:Layouts
extension ChannelViewController{
    func updateInterface(withAnimation animation:Bool, targetSize:CGSize) {
        if animation {
            UIView.animate(withDuration: 0.15, delay: 0, options: .beginFromCurrentState, animations: {[weak self] () -> Void in
                self?.updateInterface(targetSize: targetSize)
                self?.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    func updateInterface(targetSize:CGSize) {
        let displaySessions = videoSessions
        viewLayouter.sessions = displaySessions
        viewLayouter.fullSession = doubleClickFullSession.session
        viewLayouter.isForceFullView = doubleClickFullSession.isForce
        viewLayouter.targetSize = targetSize
        _ = viewLayouter.layoutVideoViews()
        if isCustomTranscodingSetting {
            transcoding.transcodingUsers = transcodingLayout?.users(ofSessions: displaySessions, fullSession: doubleClickFullSession.session, canvasSize: transcoding.size, isOnlyChannel0: isOnlyUseChannel0)
            publisher.setLiveTranscoding(transcoding)
        }
    }
}
//MARK:-AgoraLivePublisherDelegate
extension ChannelViewController:AgoraLivePublisherDelegate{
    func publisher(_ publisher: AgoraLivePublisher, streamPublishedWithUrl url: String, error: AgoraErrorCode) {
        let success = error == .noError
        if success {
            info(string: "published With: \(url)")
        } else {
            info(string: "publish Failed With: \(url), errorCode: \(error.rawValue)")
        }
        publishList.setResult(for: url, isSuccess: success)
    }
    
    func publisher(_ publisher: AgoraLivePublisher, streamUnpublishedWithUrl url: String) {
        info(string: "unpublished With: \(url)")
        
    }
    
    func publisherTranscodingUpdated(_ publisher: AgoraLivePublisher) {
        info(string: "publisher Transcoding Updated")
    }
    
    func publisher(_ publisher: AgoraLivePublisher, publishingRequestReceivedFromUid uid: UInt) {
        let message = "\(uid) request publishing"
        info(string: message)
    }
    
    func publisher(_ publisher: AgoraLivePublisher, streamInjectedStatusOfUrl url: String, uid: UInt, status: AgoraInjectStreamStatus) {
        info(string: "Inject stream: \(url), uid: \(uid), status: \(status.description())(\(status.rawValue)")
    }

}
//MARK:-AgoraLiveSubscribeDelegate
extension ChannelViewController:AgoraLiveSubscriberDelegate{
    func subscriber(_ subscriber: AgoraLiveSubscriber, publishedByHostUid uid: UInt, streamType type: AgoraMediaType) {
        info(string: "published By \(uid), type: \(type.description())")
        let session = createSession(of: uid, renderMode: localRenderMode)
        subscriber.subscribe(toHostUid: uid, mediaType: type, view: session.hostingView, renderMode: localRenderMode, videoType:AgoraVideoStreamType.high )
        subscribeList.add(uid)
    }
    
    func subscriber(_ subscriber: AgoraLiveSubscriber, unpublishedByHostUid uid: UInt) {
        info(string: "unpublished By \(uid)")
        removeSession(of: uid)
        subscribeList.remove(uid)
    }
    
    func subscriber(_ subscriber: AgoraLiveSubscriber, streamTypeChangedTo type: AgoraMediaType, byHostUid uid: UInt) {
        info(string: "streamTypeChangedTo \(type.description()), uid: \(uid)")
    }
    
    func subscriber(_ subscriber: AgoraLiveSubscriber, firstRemoteVideoDecodedOfHostUid uid: UInt, size: CGSize, elapsed: Int) {
        info(string: "first Remote Video Decoded Of \(uid), size: \(size)")
    }
    
    func subscriber(_ subscriber: AgoraLiveSubscriber, videoSizeChangedOfHostUid uid: UInt, size: CGSize, rotation: Int) {
        info(string: "video Size Changed Of \(uid), size: \(size)")
    }
    
}


//MARK:- PublisherDelegate
extension ChannelViewController:PublishVCDelegate{
    func publishVC(_ publishVC: PublishViewController, didAddPublishInfo info: PublishInfo) {
        info.start()
        publisher.addStreamUrl(info.url, transcodingEnabled: info.isTranscoding)
        rtmpPublishing = publishList.infos.count > 0
    }
    
    func publishVC(_ publishVC: PublishViewController, didRemovePublishInfo info: PublishInfo) {
        publisher.removeStreamUrl(info.url)
        info.stop()
        rtmpPublishing = publishList.infos.count > 0
        
    }
}
//MARK:- TransCodingDelegate 实时设置推流参数
extension ChannelViewController:TranscodingTableVCDelegate{
    func transcodingTableVCDidUpdate(_ transcodingTableVC: TranscodingTableViewController) {
     transcoding = transcodingTableVC.transcoding
     transcodingLayout = transcodingTableVC.transcodingLayout
     isCustomTranscodingSetting = transcodingTableVC.isCustomTranscodingSettings
     isOnlyUseChannel0 = transcodingTableVC.isOnlyChannel0
     if isCustomTranscodingSetting{
        transcoding.transcodingUsers = transcodingLayout?.users(ofSessions: videoSessions, fullSession: doubleClickFullSession.session, canvasSize: transcoding.size, isOnlyChannel0: isOnlyUseChannel0)
         publisher.setLiveTranscoding(transcoding)
     }else{
        publisher.setLiveTranscoding(nil)
        }
        
    }
}
//MARK:- SubcriberTableviewControllerDelegate
extension ChannelViewController:SubscribeTableVCDelegate{
    func subscribeTableVC(_ subscribeTableVC: SubscribeTableViewController, didUpdateSubscribeInfo info: SubscribeInfo) {
        
        let uid  = info.uid
        let session = createSession(of: uid, renderMode: info.renderMode)
        subscriber.subscribe(toHostUid: uid, mediaType: info.mediaType, view: session.hostingView, renderMode: info.renderMode, videoType: info.videoType)
        }
    
}
extension ChannelViewController:VideoActionTableVCDelegate{
    func videoActionTableVC(_ vc: VideoActionTableViewController, needPublish: Bool) {
        isPublishing = needPublish
        if isPublishing {
            if publishList.infos.count > 0{
                rtmpPublishing = true
            }
            publishList.startAll()
            publisher.publish()
            
        }else{
            rtmpPublishing = false
            publisher.unpublish()
            publishList.stopAll()
            publishList.removeAllResult()
        }
//        updateInterface(withAnimation: true, targetSize: containerView.frame.size)
        
    }
    
    func videoActionTableVCNeedSwitchCamera(_ vc: VideoActionTableViewController) {
        publisher.switchCamera()
    }
    
}




