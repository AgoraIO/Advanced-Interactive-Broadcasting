//
//  LiveKitExtension.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/20.
//  Copyright © 2017年 Agora. All rights reserved.
//

import Foundation

extension AgoraVideoProfile {
    static func validProfileList() -> [AgoraVideoProfile] {
    #if os(iOS)
        return [.portrait120P,       // 160x120   15   65
            .portrait120P_3,		// 120x120   15   50
            .portrait180P,			// 320x180   15   140
            .portrait180P_3,		// 180x180   15   100
            .portrait180P_4,		// 240x180   15   120
            .portrait240P,          // 320x240   15   200
            .portrait240P_3,		// 240x240   15   140
            .portrait240P_4,		// 424x240   15   220
            .portrait360P,          // 640x360   15   400
            .portrait360P_3,		// 360x360   15   260
            .portrait360P_4,		// 640x360   30   600
            .portrait360P_6,		// 360x360   30   400
            .portrait360P_7,		// 480x360   15   320
            .portrait360P_8,		// 480x360   30   490
            .portrait360P_9,		// 640x360   15   800
            .portrait360P_10,       // 640x360   24   800
            .portrait360P_11,       // 640x360   24   1000
            .portrait480P,          // 640x480   15   500
            .portrait480P_3,		// 480x480   15   400
            .portrait480P_4,		// 640x480   30   750
            .portrait480P_6,		// 480x480   30   600
            .portrait480P_8,		// 848x480   15   610
            .portrait480P_9,		// 848x480   30   930
            .portrait480P_10,       // 640x480   10   400
            .portrait720P,          // 1280x720  15   1130
            .portrait720P_3,		// 1280x720  30   1710
            .portrait720P_5,		// 960x720   15   910
            .portrait720P_6,		// 960x720   30   1380
            .portrait1080P,         // 1920x1080 15   2080
            .portrait1080P_3,       // 1920x1080 30   3150
            .portrait1080P_5,       // 1920x1080 60   4780
            .portrait1440P,         // 2560x1440 30   4850
            .portrait1440P_2,       // 2560x1440 60   7350
            .portrait4K,			// 3840x2160 30   8190
            .portrait4K_3,          // 3840x2160 60   13500
            
            .landscape120P,         // 160x120   15   65
            .landscape120P_3,		// 120x120   15   50
            .landscape180P,         // 320x180   15   140
            .landscape180P_3,		// 180x180   15   100
            .landscape180P_4,		// 240x180   15   120
            .landscape240P,         // 320x240   15   200
            .landscape240P_3,		// 240x240   15   140
            .landscape240P_4,		// 424x240   15   220
            .landscape360P,         // 640x360   15   400
            .landscape360P_3,		// 360x360   15   260
            .landscape360P_4,		// 640x360   30   600
            .landscape360P_6,		// 360x360   30   400
            .landscape360P_7,		// 480x360   15   320
            .landscape360P_8,		// 480x360   30   490
            .landscape360P_9,		// 640x360   15   800
            .landscape360P_10,      // 640x360   24   800
            .landscape360P_11,      // 640x360   24   1000
            .landscape480P,         // 640x480   15   500
            .landscape480P_3,		// 480x480   15   400
            .landscape480P_4,		// 640x480   30   750
            .landscape480P_6,		// 480x480   30   600
            .landscape480P_8,		// 848x480   15   610
            .landscape480P_9,		// 848x480   30   930
            .landscape480P_10,      // 640x480   10   400
            .landscape720P,         // 1280x720  15   1130
            .landscape720P_3,		// 1280x720  30   1710
            .landscape720P_5,		// 960x720   15   910
            .landscape720P_6,		// 960x720   30   1380
            .landscape1080P,        // 1920x1080 15   2080
            .landscape1080P_3,      // 1920x1080 30   3150
            .landscape1080P_5,      // 1920x1080 60   4780
            .landscape1440P,        // 2560x1440 30   4850
            .landscape1440P_2,      // 2560x1440 60   7350
            .landscape4K,			// 3840x2160 30   8190
            .landscape4K_3           // 3840x2160 60   13500
        ]
    #else
        return [.portrait120P,      // 160x120   15   65
            .portrait240P,          // 320x240   15   200
            .portrait360P,          // 640x360   15   400
            .portrait360P_4,		// 640x360   30   600
            .portrait360P_6,		// 360x360   30   400
            .portrait360P_7,		// 480x360   15   320
            .portrait360P_8,		// 480x360   30   490
            .portrait360P_9,		// 640x360   15   800
            .portrait360P_10,       // 640x360   24   800
            .portrait360P_11,       // 640x360   24   1000
            .portrait480P,          // 640x480   15   500
            .portrait480P_4,		// 640x480   30   750
            .portrait480P_6,		// 480x480   30   600
            .portrait480P_8,		// 848x480   15   610
            .portrait480P_9,		// 848x480   30   930
            .portrait480P_10,       // 640x480   10   400
            .portrait720P,          // 1280x720  15   1130
            .portrait720P_3,		// 1280x720  30   1710
            .portrait720P_5,		// 960x720   15   910
            .portrait720P_6,		// 960x720   30   1380
            .portrait1080P,         // 1920x1080 15   2080
            .portrait1080P_3,       // 1920x1080 30   3150
            .portrait1080P_5,       // 1920x1080 60   4780
            .portrait1440P,         // 2560x1440 30   4850
            .portrait1440P_2,       // 2560x1440 60   7350
            .portrait4K,			// 3840x2160 30   8190
            .portrait4K_3,          // 3840x2160 60   13500
            
            .landscape120P,         // 160x120   15   65
            .landscape240P,         // 320x240   15   200
            .landscape360P,         // 640x360   15   400
            .landscape360P_4,		// 640x360   30   600
            .landscape360P_6,		// 360x360   30   400
            .landscape360P_7,		// 480x360   15   320
            .landscape360P_8,		// 480x360   30   490
            .landscape360P_9,		// 640x360   15   800
            .landscape360P_10,      // 640x360   24   800
            .landscape360P_11,      // 640x360   24   1000
            .landscape480P,         // 640x480   15   500
            .landscape480P_4,		// 640x480   30   750
            .landscape480P_6,		// 480x480   30   600
            .landscape480P_8,		// 848x480   15   610
            .landscape480P_9,		// 848x480   30   930
            .landscape480P_10,      // 640x480   10   400
            .landscape720P,         // 1280x720  15   1130
            .landscape720P_3,		// 1280x720  30   1710
            .landscape720P_5,		// 960x720   15   910
            .landscape720P_6,		// 960x720   30   1380
            .landscape1080P,        // 1920x1080 15   2080
            .landscape1080P_3,      // 1920x1080 30   3150
            .landscape1080P_5,      // 1920x1080 60   4780
            .landscape1440P,        // 2560x1440 30   4850
            .landscape1440P_2,      // 2560x1440 60   7350
            .landscape4K,			// 3840x2160 30   8190
            .landscape4K_3,         // 3840x2160 60   13500
        ]
    #endif
    }
    
    func resolution() -> CGSize? {
        switch self {
        case .portrait120P:      return CGSize(width: 120, height: 160)
        case .portrait240P:		return CGSize(width: 240, height: 320)
        case .portrait360P:		return CGSize(width: 360, height: 640)
        case .portrait360P_4:	return CGSize(width: 360, height: 640)
        case .portrait360P_6:	return CGSize(width: 360, height: 360)
        case .portrait360P_7:	return CGSize(width: 360, height: 480)
        case .portrait360P_8:	return CGSize(width: 360, height: 480)
        case .portrait360P_9:	return CGSize(width: 360, height: 640)
        case .portrait360P_10:   return CGSize(width: 360, height: 640)
        case .portrait360P_11:   return CGSize(width: 360, height: 640)
        case .portrait480P:		return CGSize(width: 480, height: 640)
        case .portrait480P_4:	return CGSize(width: 480, height: 640)
        case .portrait480P_6:	return CGSize(width: 480, height: 480)
        case .portrait480P_8:	return CGSize(width: 480, height: 848)
        case .portrait480P_9:	return CGSize(width: 480, height: 848)
        case .portrait480P_10:   return CGSize(width: 480, height: 640)
        case .portrait720P:		return CGSize(width: 720, height: 1280)
        case .portrait720P_3:	return CGSize(width: 720, height: 1280)
        case .portrait720P_5:	return CGSize(width: 720, height: 960)
        case .portrait720P_6:	return CGSize(width: 720, height: 960)
        case .portrait1080P:		return CGSize(width: 1080, height: 1920)
        case .portrait1080P_3:   return CGSize(width: 1080, height: 1920)
        case .portrait1080P_5:   return CGSize(width: 1080, height: 1920)
        case .portrait1440P:		return CGSize(width: 1440, height: 2560)
        case .portrait1440P_2:   return CGSize(width: 1440, height: 2560)
        case .portrait4K:		return CGSize(width: 2160, height: 3840)
        case .portrait4K_3:		return CGSize(width: 2160, height: 3840)
        
        case .landscape120P:      return CGSize(width: 160, height: 120)
        case .landscape240P:		return CGSize(width: 320, height: 240)
        case .landscape360P:		return CGSize(width: 640, height: 320)
        case .landscape360P_4:	return CGSize(width: 640, height: 360)
        case .landscape360P_6:	return CGSize(width: 360, height: 360)
        case .landscape360P_7:	return CGSize(width: 480, height: 360)
        case .landscape360P_8:	return CGSize(width: 480, height: 360)
        case .landscape360P_9:	return CGSize(width: 640, height: 360)
        case .landscape360P_10:   return CGSize(width: 640, height: 360)
        case .landscape360P_11:   return CGSize(width: 640, height: 360)
        case .landscape480P:		return CGSize(width: 640, height: 480)
        case .landscape480P_4:	return CGSize(width: 640, height: 480)
        case .landscape480P_6:	return CGSize(width: 480, height: 480)
        case .landscape480P_8:	return CGSize(width: 848, height: 480)
        case .landscape480P_9:	return CGSize(width: 848, height: 480)
        case .landscape480P_10:   return CGSize(width: 640, height: 480)
        case .landscape720P:		return CGSize(width: 1280, height: 720)
        case .landscape720P_3:	return CGSize(width: 1280, height: 720)
        case .landscape720P_5:	return CGSize(width: 960, height: 720)
        case .landscape720P_6:	return CGSize(width: 960, height: 720)
        case .landscape1080P:		return CGSize(width: 1920, height: 1080)
        case .landscape1080P_3:   return CGSize(width: 1920, height: 1080)
        case .landscape1080P_5:   return CGSize(width: 1920, height: 1080)
        case .landscape1440P:		return CGSize(width: 2560, height: 1440)
        case .landscape1440P_2:   return CGSize(width: 2560, height: 1440)
        case .landscape4K:		return CGSize(width: 3840, height: 2160)
        case .landscape4K_3:		return CGSize(width: 3840, height: 2160)
        default: break
        }
        
    #if os(iOS)
        switch self {
        case .portrait120P_3:	return CGSize(width: 120, height: 120)
        case .portrait180P:		return CGSize(width: 180, height: 320)
        case .portrait180P_3:	return CGSize(width: 180, height: 180)
        case .portrait180P_4:	return CGSize(width: 180, height: 240)
        case .portrait240P_3:	return CGSize(width: 240, height: 240)
        case .portrait240P_4:	return CGSize(width: 240, height: 424)
        case .portrait360P_3:	return CGSize(width: 360, height: 360)
        case .portrait480P_3:	return CGSize(width: 480, height: 480)
        
        case .landscape120P_3:	return CGSize(width: 120, height: 120)
        case .landscape180P:    return CGSize(width: 320, height: 180)
        case .landscape180P_3:	return CGSize(width: 180, height: 180)
        case .landscape180P_4:	return CGSize(width: 240, height: 180)
        case .landscape240P_3:	return CGSize(width: 240, height: 240)
        case .landscape240P_4:	return CGSize(width: 424, height: 240)
        case .landscape360P_3:	return CGSize(width: 360, height: 360)
        case .landscape480P_3:	return CGSize(width: 480, height: 480)
        default: break
        }
    #endif
        
        return nil
    }
    
    func fps() -> Int {
        switch self {
        case .portrait360P_10,
             .portrait360P_11,
             
             .landscape360P_10,
             .landscape360P_11:
            return 24
        case .portrait360P_4,
             .portrait360P_6,
             .portrait360P_8,
             .portrait480P_4,
             .portrait480P_6,
             .portrait480P_9,
             .portrait720P_3,
             .portrait720P_6,
             .portrait1080P_3,
             .portrait1440P,
             .portrait4K,
             
             .landscape360P_4,
             .landscape360P_6,
             .landscape360P_8,
             .landscape480P_4,
             .landscape480P_6,
             .landscape480P_9,
             .landscape720P_3,
             .landscape720P_6,
             .landscape1080P_3,
             .landscape1440P,
             .landscape4K:
            return 30
        case .portrait1080P_5,
             .portrait1440P_2,
             .portrait4K_3,
             
             .landscape1080P_5,
             .landscape1440P_2,
             .landscape4K_3:
            return 60
        case .portrait480P_10,
             
             .landscape480P_10:
            return 10
        default:
            return 15
        }
    }
    
    func bitRate() -> Int? {
        switch self {
        case .portrait120P:     return 65
        case .portrait240P:		return 200
        case .portrait360P:		return 400
        case .portrait360P_4:	return 600
        case .portrait360P_6:	return 400
        case .portrait360P_7:	return 320
        case .portrait360P_8:	return 490
        case .portrait360P_9:	return 800
        case .portrait360P_10:	return 800
        case .portrait360P_11:	return 1000
        case .portrait480P:		return 500
        case .portrait480P_4:	return 750
        case .portrait480P_6:	return 600
        case .portrait480P_8:	return 610
        case .portrait480P_9:	return 930
        case .portrait480P_10:  return 400
        case .portrait720P:		return 1130
        case .portrait720P_3:	return 1710
        case .portrait720P_5:	return 910
        case .portrait720P_6:	return 1380
        case .portrait1080P:    return 2080
        case .portrait1080P_3:	return 3150
        case .portrait1080P_5:	return 4780
        case .portrait1440P:    return 4850
        case .portrait1440P_2:	return 7350
        case .portrait4K:		return 8190
        case .portrait4K_3:		return 13500
        
        case .landscape120P:    return 65
        case .landscape240P:    return 200
        case .landscape360P:    return 400
        case .landscape360P_4:	return 600
        case .landscape360P_6:	return 400
        case .landscape360P_7:	return 320
        case .landscape360P_8:	return 490
        case .landscape360P_9:	return 800
        case .landscape360P_10:	return 800
        case .landscape360P_11:	return 1000
        case .landscape480P:    return 500
        case .landscape480P_4:	return 750
        case .landscape480P_6:	return 600
        case .landscape480P_8:	return 610
        case .landscape480P_9:	return 930
        case .landscape480P_10: return 400
        case .landscape720P:    return 1130
        case .landscape720P_3:	return 1710
        case .landscape720P_5:	return 910
        case .landscape720P_6:	return 1380
        case .landscape1080P:   return 2080
        case .landscape1080P_3:	return 3150
        case .landscape1080P_5:	return 4780
        case .landscape1440P:   return 4850
        case .landscape1440P_2:	return 7350
        case .landscape4K:		return 8190
        case .landscape4K_3:    return 13500
        default: break
        }
        
    #if os(iOS)
        switch self {
        case .portrait120P_3:	return 50
        case .portrait180P:		return 140
        case .portrait180P_3:	return 100
        case .portrait180P_4:	return 120
        case .portrait240P_3:	return 140
        case .portrait240P_4:	return 220
        case .portrait360P_3:	return 260
        case .portrait480P_3:	return 400
        
        case .landscape120P_3:	return 50
        case .landscape180P:    return 140
        case .landscape180P_3:	return 100
        case .landscape180P_4:	return 120
        case .landscape240P_3:	return 140
        case .landscape240P_4:	return 220
        case .landscape360P_3:	return 260
        case .landscape480P_3:	return 400
        default: break
        }
    #endif
        
        return nil
    }
    
    func description() -> String {
        guard let resolution = resolution(), let bitRate = bitRate() else {
            return ""
        }
        return "\(Int(resolution.width))×\(Int(resolution.height)), \(fps())fps, \(bitRate)k"
    }
}

extension AgoraVideoStreamType {
    func description() -> String {
        switch self {
        case .low:      return "Low"
        case .high:     return "High"
        }
    }
}

extension AgoraNetworkQuality {
    func description() -> String {
        switch self {
        case .unknown:      return "0 Unknown"
        case .down:         return "6 Down"
        case .vBad:         return "5 Very Bad"
        case .bad:          return "4 Bad"
        case .poor:         return "3 Poor"
        case .good:         return "2 Good"
        case .excellent:    return "1 Excellent"
        }
    }
}

extension AgoraVideoRenderMode {
    static func validRenderModes() -> [AgoraVideoRenderMode] {
        return [
            .hidden,
            .fit,
            .adaptive
        ]
    }
    
    func description() -> String {
        switch self {
        case .hidden:    return "Hidden"
        case .fit:       return "Fit"
        case .adaptive:  return "Adaptive"
        }
    }
    
    func index() -> Int {
        switch self {
        case .hidden:   return 0
        case .fit:      return 1
        case .adaptive: return 2
        }
    }
    
    static func mode(at index: Int) -> AgoraVideoRenderMode? {
        var renderMode: AgoraVideoRenderMode?
        switch index {
        case 0: renderMode = .hidden
        case 1: renderMode = .fit
        case 2: renderMode = .adaptive
        default: break
        }
        
        return renderMode
    }
}

extension AgoraMediaType {
    func description() -> String {
        switch self {
        case .audioAndVideo:    return "Audio and Video"
        case .audioOnly:        return "Audio Only"
        case .videoOnly:        return "Video Only"
        case .none:             return "None"
        }
    }
    
    func index() -> Int {
        switch self {
        case .audioAndVideo:    return 0
        case .audioOnly:        return 1
        case .videoOnly:        return 2
        case .none:             return 3
        }
    }
    
    static func type(at index: Int) -> AgoraMediaType? {
        switch index {
        case 0: return .audioAndVideo
        case 1: return .audioOnly
        case 2: return .videoOnly
        case 3: return AgoraMediaType.none
        default: return nil
        }
    }
}

extension AgoraVideoStreamType {
    func index() -> Int {
        switch self {
        case .high: return 0
        case .low:  return 1
        }
    }
    
    static func type(at index: Int) -> AgoraVideoStreamType? {
        switch index {
        case 0: return .high
        case 1: return .low
        default: return nil
        }
    }
}

// MARK: - AgoraAudioProfile
extension AgoraAudioProfile {
    func description() -> String {
        switch self {
        case .default:                 return "Default"
        case .speechStandard:          return "SpeechStandard"
        case .musicStandard:           return "MusicStandard"
        case .musicStandardStereo:     return "MusicStandardStereo"
        case .musicHighQuality:        return "MusicHighQuality"
        case .musicHighQualityStereo:  return "MusicHighQualityStereo"
        }
    }
    
    static func validList() -> [AgoraAudioProfile] {
        return [
            .default,
            .speechStandard,
            .musicStandard,
            .musicStandardStereo,
            .musicHighQuality,
            .musicHighQualityStereo
        ]
    }
    
    func biterate() -> Int {
        switch self {
        case .default: return AGStreamAudioBitRate.type48k.rawValue
        case .speechStandard: return AGStreamAudioBitRate.type48k.rawValue
        case .musicStandard: return AGStreamAudioBitRate.type48k.rawValue
        case .musicStandardStereo: return AGStreamAudioBitRate.type48k.rawValue
        case .musicHighQuality: return AGStreamAudioBitRate.type128k.rawValue
        case .musicHighQualityStereo: return AGStreamAudioBitRate.type128k.rawValue
        }
    }
    
    func channels() -> Int {
        switch self {
        case .default:              return 1
        case .speechStandard:       return 1
        case .musicStandard:        return 1
        case .musicStandardStereo:  return 2
        case .musicHighQuality:     return 1
        case .musicHighQualityStereo: return 2
        }
    }
}

// MARK: - AgoraAudioScenario
extension AgoraAudioScenario {
    func description() -> String {
        switch self {
        case .default:              return "Default"
        case .chatRoomGaming:       return "ChatRoomGaming"
        case .chatRoomEntertainment: return "ChatRoomEntertainment"
        case .education:            return "Education"
        case .gameStreaming:        return "GameStreaming"
        case .showRoom:             return "ShowRoom"
        }
    }
    
    static func validList() -> [AgoraAudioScenario] {
        return [
            .default,
            .chatRoomGaming,
            .chatRoomEntertainment,
            .education,
            .gameStreaming,
            .showRoom
        ]
    }
}

//MARK: - AgoraInjectStreamStatus
extension AgoraInjectStreamStatus {
    func description() -> String {
        switch self {
        case .startSuccess:         return "Start Success"
        case .startAlreadyExists:   return "Start Already Exists"
        case .startUnauthorized:    return "Start Unauthorized"
        case .startTimedout:        return "Start TimeOut"
        case .startFailed:          return "Start Failed"
        case .stopSuccess:          return "Stop Success"
        case .stopNotFound:         return "Stop Not Found"
        case .stopUnauthorized:     return "Stop Unauthorized"
        case .stopTimedout:         return "Stop TimeOut"
        case .stopFailed:           return "Stop Failed"
        case .broken:               return "Broken"
        }
    }
}
