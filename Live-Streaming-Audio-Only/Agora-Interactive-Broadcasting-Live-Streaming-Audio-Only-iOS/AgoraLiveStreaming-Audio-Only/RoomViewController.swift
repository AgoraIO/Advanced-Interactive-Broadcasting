//
//  RoomViewController.swift
//  AgoraLiveStreaming-Audio-Only
//
//  Created by ZhangJi on 2018/8/3.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

import UIKit
import AgoraAudioKit

protocol RoomVCDelegate: class {
    func roomVCNeedClose(_ roomVC: RoomViewController)
}

class RoomViewController: UIViewController {
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var muteAudioButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var rtmpButton: UIButton!
    
    var roomName: String!
    var clientRole = AgoraClientRole.audience {
        didSet {
            updateBroadcastButton()
        }
    }
    weak var delegate: RoomVCDelegate?
    
    fileprivate var agoraKit: AgoraRtcEngineKit!
    fileprivate var logs = [String]()
    
    fileprivate var isBroadcaster: Bool {
        return clientRole == .broadcaster
    }
    fileprivate var audioMuted = false {
        didSet {
            muteAudioButton?.setImage(audioMuted ? #imageLiteral(resourceName: "btn_mute_blue") : #imageLiteral(resourceName: "btn_mute"), for: .normal)
        }
    }
    
    fileprivate var speakerEnabled = true {
        didSet {
            speakerButton?.setImage(speakerEnabled ? #imageLiteral(resourceName: "btn_speaker_blue") : #imageLiteral(resourceName: "btn_speaker"), for: .normal)
            speakerButton?.setImage(speakerEnabled ? #imageLiteral(resourceName: "btn_speaker") : #imageLiteral(resourceName: "btn_speaker_blue"), for: .highlighted)
        }
    }
    
    var transcoding: AgoraLiveTranscoding?
    
    var users = [AgoraLiveTranscodingUser]() {
        didSet {
            if rtmpButton.isSelected {
                transcoding?.transcodingUsers = users
                agoraKit.setLiveTranscoding(transcoding)
            }
        }
    }
    
    fileprivate var rtmpUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomNameLabel.text = "\(roomName!)"
        logTableView.rowHeight = UITableView.automaticDimension
        logTableView.estimatedRowHeight = 25
        
        updateBroadcastButton()
        
        loadAgoraKit()
    }
    
    @IBAction func doBroadcastPressed(_ sender: UIButton) {
        audioMuted = false
        clientRole = isBroadcaster ? .audience : .broadcaster
        
        agoraKit.setClientRole(clientRole)
    }
    
    @IBAction func doMuteAudioPressed(_ sender: UIButton) {
        audioMuted = !audioMuted
        agoraKit.muteLocalAudioStream(audioMuted)
    }
    
    @IBAction func doSpeakerPressed(_ sender: UIButton) {
        speakerEnabled = !speakerEnabled
        agoraKit.setEnableSpeakerphone(speakerEnabled)
    }
    
    @IBAction func doClosePressed(_ sender: UIButton) {
        leaveChannel()
    }
    
    @IBAction func doRtmpPressed(_ sender: UIButton) {
        if sender.isSelected {
            guard let url = rtmpUrl else { return }
            agoraKit.removePublishStreamUrl(url)
        } else {
            let popView = PopView.newPopViewWith(buttonTitle: "RTMP URL", placeholder: "Please input rtmp url...")
            popView?.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight)
            popView?.delegate = self
            self.view.addSubview(popView!)
            UIView.animate(withDuration: 0.2) {
                popView?.frame = self.view.frame
            }
        }
    }
}

private extension RoomViewController {
    func append(log string: String) {
        guard !string.isEmpty else {
            return
        }
        
        logs.append(string)
        
        var deleted: String?
        if logs.count > 200 {
            deleted = logs.removeFirst()
        }
        
        updateLogTable(withDeleted: deleted)
    }
    
    func updateLogTable(withDeleted deleted: String?) {
        guard let tableView = logTableView else {
            return
        }
        
        let insertIndexPath = IndexPath(row: logs.count - 1, section: 0)
        
        tableView.beginUpdates()
        if deleted != nil {
            tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        tableView.insertRows(at: [insertIndexPath], with: .none)
        tableView.endUpdates()
        
        tableView.scrollToRow(at: insertIndexPath, at: .bottom, animated: false)
    }
    
    func updateBroadcastButton() {
        muteAudioButton?.isEnabled = isBroadcaster
        broadcastButton?.setImage(isBroadcaster ? #imageLiteral(resourceName: "btn_join_blue") : #imageLiteral(resourceName: "btn_join"), for: .normal)
    }
}

//MARK: - table view
extension RoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as! LogCell
        cell.set(log: logs[(indexPath as NSIndexPath).row])
        return cell
    }
}

//MARK: - engine
private extension RoomViewController {
    func loadAgoraKit() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.setClientRole(clientRole)
        
        let code = agoraKit.joinChannel(byToken: nil, channelId: roomName, info: nil, uid: 0, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                self.append(log: "Join channel failed: \(code)")
            })
        }
    }
    
    func leaveChannel() {
        if rtmpButton.isSelected {
            guard let url = rtmpUrl else { return }
            agoraKit.removePublishStreamUrl(url)
        }
        agoraKit.leaveChannel(nil)
        delegate?.roomVCNeedClose(self)
    }
}

extension RoomViewController: AgoraRtcEngineDelegate {
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Interrupted")
    }
    
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Lost")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        append(log: "Occur error: \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        let transcodingUser = AgoraLiveTranscodingUser()
        transcodingUser.uid = uid
        users.append(transcodingUser)
        append(log: "Did joined channel: \(channel), with uid: \(uid), elapsed: \(elapsed)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let transcodingUser = AgoraLiveTranscodingUser()
        transcodingUser.uid = uid
        users.append(transcodingUser)
        append(log: "Did joined of uid: \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        for (index, user) in users.enumerated() {
            if user.uid == uid {
                users.remove(at: index)
            }
        }
        append(log: "Did offline of uid: \(uid), reason: \(reason.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioQualityOfUid uid: UInt, quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
        append(log: "Audio Quality of uid: \(uid), quality: \(quality.rawValue), delay: \(delay), lost: \(lost)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute api: String, error: Int) {
        append(log: "Did api call execute: \(api), error: \(error)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, streamPublishedWithUrl url: String, errorCode: AgoraErrorCode) {
        if errorCode == .noError {
            rtmpButton.isSelected = true
        }
        append(log: "stream Published With Url \(url), error: \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, streamUnpublishedWithUrl url: String) {
        rtmpButton.isSelected = false
        append(log: "stream Published With Url \(url)")
    }
}

extension RoomViewController: PopViewDelegate {
    func popViewButtonDidPressed(_ popView: PopView) {
        guard let url = popView.inputTextField.text else {
            return
        }
        
        // Notes: size must be 16x16, videoBitrate = 1
        transcoding = AgoraLiveTranscoding()
        transcoding?.size = CGSize(width: 16, height: 16)
        transcoding?.videoBitrate = 1
        transcoding?.audioChannels = 1
        transcoding?.transcodingUsers = users
        
        agoraKit.setLiveTranscoding(transcoding)
        agoraKit.addPublishStreamUrl(url, transcodingEnabled: true)
        
        rtmpUrl = url
        
        popView.removeFromSuperview()
    }
}
