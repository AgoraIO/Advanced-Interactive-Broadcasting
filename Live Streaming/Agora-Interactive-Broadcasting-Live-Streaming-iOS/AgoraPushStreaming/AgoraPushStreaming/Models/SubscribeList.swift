//
//  SubscribeList.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/24.
//  Copyright © 2017年 Agora. All rights reserved.
//

import Foundation

struct SubscribeList {
    var infos = [SubscribeInfo]()
    
    mutating func add(_ uid: UInt) {
        if let _ = fetch(of: uid) {
            return
        }
        infos.append(SubscribeInfo(uid: uid))
    }
    
    mutating func remove(_ uid: UInt) {
        if let (_, index) = fetch(of: uid) {
            infos.remove(at: index)
        }
    }
    
    func fetch(of uid: UInt) -> (SubscribeInfo, Int)? {
        for (index, info) in infos.enumerated() {
            if info.uid == uid {
                return (info, index)
            }
        }
        
        return nil
    }
    
    func setRequesting(for uid: UInt, isRequesting: Bool) {
        if let (info, _) = fetch(of: uid) {
            info.isRequesting = isRequesting
        }
    }
}

class SubscribeInfo {
    static let ResultNotification = Notification.Name("io.agora.streaming.RequestResult")
    
    var uid: UInt = 0
    var isSubscribed = false
    var mediaType = AgoraMediaType.audioAndVideo
    var renderMode = AgoraVideoRenderMode.hidden
    var videoType = AgoraVideoStreamType.high
    
    var isRequesting = false {
        didSet {
            NotificationCenter.default.post(name: SubscribeInfo.ResultNotification, object: self)
        }
    }
    
    init(uid: UInt) {
        self.uid = uid
    }
}
