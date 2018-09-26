//
//  PublishList.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/28.
//  Copyright © 2017年 Agora. All rights reserved.
//

import Foundation

class PublishList {
    var infos = [PublishInfo]()
    
    func add(_ url: String, isTranscoding: Bool) -> PublishInfo? {
        if let _ = fetch(of: url) {
            return nil
        } else {
            let info = PublishInfo(url: url, isTranscoding: isTranscoding)
            infos.append(info)
            return info
        }
    }
    
    func remove(_ url: String) {
        if let (_, index) = fetch(of: url) {
            infos.remove(at: index)
        }
    }
    
    func fetch(of url: String) -> (PublishInfo, Int)? {
        for (index, info) in infos.enumerated() {
            if info.url == url {
                return (info, index)
            }
        }
        
        return nil
    }
    
    func setResult(for url: String, isSuccess: Bool) {
        if let (info, _) = fetch(of: url), !info.hasSetted {
            info.isSuccess = isSuccess
            info.hasSetted = true
        }
    }
    
    func removeAllResult() {
        for info in infos {
            info.isSuccess = nil
            info.hasSetted = false
        }
    }
    
    func startAll() {
        for info in infos {
            info.start()
        }
    }
    
    func stopAll() {
        for info in infos {
            info.stop()
        }
    }
}

class PublishInfo {
    static let ResultNotification = Notification.Name("io.agora.streaming.PublishResult")
    
    fileprivate(set) var url: String
    fileprivate(set) var isTranscoding = false
    fileprivate(set) var isSuccess: Bool? {
        didSet {
            successDate = (isSuccess ?? false) ? Date() : nil
            NotificationCenter.default.post(name: PublishInfo.ResultNotification, object: self)
        }
    }
    fileprivate(set) var hasSetted = false
    
    fileprivate var startDate: Date?
    fileprivate var successDate: Date?
    var successInterval: TimeInterval? {
        guard let successDate = successDate, let startTime = startDate else {
            return nil
        }
        return successDate.timeIntervalSince(startTime)
    }
    
    init(url: String, isTranscoding: Bool = false) {
        self.url = url
        self.isTranscoding = isTranscoding
    }
    
    func start() {
        startDate = Date()
        successDate = nil
    }
    
    func stop() {
        startDate = nil
        successDate = nil
    }
}
