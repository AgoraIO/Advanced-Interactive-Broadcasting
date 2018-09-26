//
//  AutoTestSettings.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/8/2.
//  Copyright © 2017年 Agora. All rights reserved.
//

import Foundation

enum AutoTestType {
    case joinLeave, muteUnmute
}

struct AutoTestSettings {
    var type: AutoTestType?
    var isTesting = false
    var count = 0
}

extension AutoTestSettings {
    mutating func reset() {
        isTesting = false
        count = 0
    }
    
    func description() -> String {
        if let type = type {
            let typeDescription = type.description()
            if count > 0 {
                return typeDescription + ": \(count)"
            } else {
                return typeDescription
            }
        } else {
            return "Auto Test"
        }
    }
}

extension AutoTestType {
    func scheduleFirstTimeInterval() -> DispatchTimeInterval {
        switch self {
        case .joinLeave:  return DispatchTimeInterval.randomTimeInterval(during: 60, to: 90)
        case .muteUnmute: return DispatchTimeInterval.randomTimeInterval(during: 60, to: 90)
        }
    }
    
    func scheduleSecondTimeInterval() -> DispatchTimeInterval {
        switch self {
        case .joinLeave:  return DispatchTimeInterval.randomTimeInterval(during: 20, to: 40)
        case .muteUnmute: return DispatchTimeInterval.randomTimeInterval(during: 20, to: 40)
        }
    }
    
    static func type(of index: Int) -> AutoTestType? {
        switch index {
        case 1:     return .joinLeave
        case 2:     return .muteUnmute
        default:    return nil
        }
    }
    
    func description() -> String {
        switch self {
        case .joinLeave:    return "Auto Join & Leave"
        case .muteUnmute:   return "Auto Mute & Unmute"
        }
    }
}
