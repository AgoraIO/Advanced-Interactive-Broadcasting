//
//  MediaInfo.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/24.
//  Copyright © 2017年 Agora. All rights reserved.
//

import Foundation

struct MediaInfo {
    var width = 0
    var height = 0
    var fps = 0
    var bitRate = 0
    
    init() {}
    
    init?(videoProfile: AgoraVideoProfile) {
        if let resolution = videoProfile.resolution(), let bitRate = videoProfile.bitRate() {
            self.width = Int(resolution.width)
            self.height = Int(resolution.height)
            self.bitRate = bitRate
            self.fps = videoProfile.fps()
        } else {
            return nil
        }
    }
    
    func description() -> String {
        return "\(width)×\(height), \(fps)fps, \(bitRate)k"
    }
}
