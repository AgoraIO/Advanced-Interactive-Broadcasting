//
//  VideoSession.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 3/28/16.
//  Copyright © 2016 Agora. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Cocoa
#endif

class VideoSession: NSObject {
    var uid: UInt = 0
    var hostingView: VideoView!
    var renderMode: AgoraVideoRenderMode!
    
    var audioMuted = false
    var videoMuted = false
    
    var mediaInfo = MediaInfo() {
        didSet {
            hostingView?.updateVideoInfo(withInfo: mediaInfo)
        }
    }
    
    var isVideoMuted = false {
        didSet {
            hostingView.isVideoMuted = isVideoMuted
        }
    }
    
    var isVideoDisabled = false {
        didSet {
            hostingView.isVideoDisabled = isVideoDisabled
        }
    }
    
    var isSpeaking = false {
        didSet {
            hostingView.isSpeaking = isSpeaking
        }
    }
    
    init(uid: UInt) {
        self.uid = uid
        
        hostingView = VideoView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        hostingView.updateUserInfo(withUid: uid)
    }
    
    func setAudioMuted(audioMuted: Bool) {
        self.audioMuted = audioMuted
    }
    
    func setVideoMuted(videoMuted: Bool) {
        self.videoMuted = videoMuted
    }
}

extension VideoSession {
    static func localSession(renderMode: AgoraVideoRenderMode) -> VideoSession {
        let session = VideoSession(uid: 0)
        session.renderMode = renderMode
        return session
    }
    
    func updateMediaInfo(resolution: CGSize? = nil, bitRate: Int? = nil, fps: Int? = nil) {
        if let resolution = resolution {
            mediaInfo.width = Int(resolution.width)
            mediaInfo.height = Int(resolution.height)
        }
        
        if let bitRate = bitRate {
            mediaInfo.bitRate = bitRate
        }
        
        if let fps = fps {
            mediaInfo.fps = fps
        }
        
        hostingView.updateVideoInfo(withInfo: mediaInfo)
    }
    
    func updateAudioInfo(withVolume volume: Int, isMuted: Bool) {
        hostingView.updateAudioInfo(withVolume: volume, isMuted: isMuted)
    }
    
    func updateUserInfo(withUid uid: UInt) {
        self.uid = uid
        hostingView.updateUserInfo(withUid: uid)
    }
    
    func updateStreamTypeInto(withType type: AgoraVideoStreamType) {
        hostingView.updateStreamTypeInto(withType: type)
    }
    
    func updateAudioQuality(_ quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
        hostingView.updateAudioQuality(quality, delay: delay, lost: lost)
    }
}
