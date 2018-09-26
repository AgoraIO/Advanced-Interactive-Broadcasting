//
//  TranscodingLayout.swift
//  AgoraPremium
//
//  Created by GongYuhua on 2016/12/14.
//  Copyright © 2016年 Agora. All rights reserved.
//

import Foundation

enum TranscodingLayout {
    case float, tile, matrix
    
    static func type(ofIndex index: Int) -> TranscodingLayout? {
        switch index {
        case 1: return .float
        case 2: return .tile
        case 3: return .matrix
        default: return nil
        }
    }
    
    func index() -> Int {
        switch self {
        case .float:    return 1
        case .tile:     return 2
        case .matrix:   return 3
        }
    }
}

extension TranscodingLayout {
    func users(ofSessions sessions: [VideoSession],
               fullSession: VideoSession?,
               canvasSize: CGSize,
               isOnlyChannel0: Bool) -> [AgoraLiveTranscodingUser]? {
        guard !sessions.isEmpty else {
            return nil
        }
        
        let full = fullSession ?? sessions.first!
        var smalls = [VideoSession]()
        for session in sessions {
            if session != full {
                smalls.append(session)
            }
        }
        
        var users = [AgoraLiveTranscodingUser]()

        switch self {
        case .float:
            users.append(TranscodingLayout.fullLayout(ofSession: full, canvasSize: canvasSize))
            users.append(contentsOf: TranscodingLayout.floatLayouts(ofSessions: smalls, canvasSize: canvasSize))
        case .tile:
            users.append(contentsOf: TranscodingLayout.tileLayouts(ofFullSession: full, smallSessions: smalls, canvasSize: canvasSize))
        case .matrix:
            users.append(contentsOf: TranscodingLayout.matrixLayouts(ofSessions: sessions, canvasSize: canvasSize))
        }
        if !isOnlyChannel0 {
            for (index, user) in users.enumerated() {
                user.audioChannel = min(index + 1, 6)
            }
        }
        
        return users
    }
}

private extension TranscodingLayout {
    static func fullLayout(ofSession session: VideoSession, canvasSize: CGSize) -> AgoraLiveTranscodingUser {
        
        let user = AgoraLiveTranscodingUser()
        user.uid = session.uid
        user.rect = CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height)
        user.zOrder = 0
        user.alpha = 1
        
        return user
    }
    
    static func floatLayouts(ofSessions sessions: [VideoSession], canvasSize: CGSize) -> [AgoraLiveTranscodingUser] {
        
        var users = [AgoraLiveTranscodingUser]()
        
        let canvasWidth = canvasSize.width
        let canvasHeight = canvasSize.height
        
        let virtualWidth = min(canvasWidth, canvasHeight)
        let virtualHeight = max(canvasWidth, canvasHeight)
        let viewWidth = virtualWidth * 0.3
        let viewHEdge = virtualWidth * 0.025
        let viewHeight = viewWidth
        let viewVEdge = viewHEdge
        
        for (index, session) in sessions.enumerated() {
            if index >= 6 {
                break
            }
            
            let user = AgoraLiveTranscodingUser()
            user.uid = session.uid
            
            let xIndex = CGFloat(index % 3)
            let yIndex = CGFloat(index / 3)
            
            user.rect = CGRect(x: xIndex * (viewWidth + viewHEdge) + viewHEdge,
                               y: virtualHeight - (yIndex + 1) * (viewHeight + viewVEdge),
                               width: viewWidth,
                               height: viewHeight)
            user.zOrder = index + 1
            user.alpha = randAlpha()
            users.append(user)
        }
        
        if canvasWidth > canvasHeight {
            for user in users {
                user.rect.swapXY()
            }
        }
        
        return users
    }
    
    static func tileLayouts(ofFullSession fullSession: VideoSession, smallSessions: [VideoSession], canvasSize: CGSize) -> [AgoraLiveTranscodingUser] {
        
        var users = [AgoraLiveTranscodingUser]()
        let canvasWidth = canvasSize.width
        let canvasHeight = canvasSize.height
        let virtualWidth = min(canvasWidth, canvasHeight)
        let virtualHeight = max(canvasWidth, canvasHeight)
        
        let viewWidth = virtualWidth * 0.3
        let viewHEdge = virtualWidth * 0.025
        let viewHeight = viewWidth
        let viewVEdge = viewHEdge
        
        var fullViewHeight = virtualHeight
        
        for (index, session) in smallSessions.enumerated() {
            if index >= 6 {
                break
            }
            
            let user = AgoraLiveTranscodingUser()
            user.uid = session.uid
            
            let xIndex = CGFloat(index % 3)
            let yIndex = CGFloat(index / 3)
            
            user.rect = CGRect(x: xIndex * (viewWidth + viewHEdge) + viewHEdge,
                               y: virtualHeight - (yIndex + 1) * (viewHeight + viewVEdge),
                               width: viewWidth,
                               height: viewHeight)
            user.alpha = randAlpha()
            users.append(user)
            
            fullViewHeight = user.rect.minY - viewVEdge
        }
        
        let bigUser = AgoraLiveTranscodingUser()
        bigUser.uid = fullSession.uid
        bigUser.rect = CGRect(x: 0, y: 0, width: virtualWidth, height: fullViewHeight)
        bigUser.alpha = 1
        users.append(bigUser)
        
        if canvasWidth > canvasHeight {
            for user in users {
                user.rect.swapXY()
            }
        }
        
        return users
    }
    
    static func matrixLayouts(ofSessions sessions: [VideoSession], canvasSize: CGSize) -> [AgoraLiveTranscodingUser] {
        
        var users = [AgoraLiveTranscodingUser]()
        
        let canvasWidth = canvasSize.width
        let canvasHeight = canvasSize.height
        let virtualWidth = min(canvasWidth, canvasHeight)
        let virtualHeight = max(canvasWidth, canvasHeight)
        
        let viewWidth = virtualWidth * 0.3
        let viewHEdge = virtualWidth * 0.025
        let viewHeight = viewWidth
        let viewVEdge = viewHEdge
        
        for (index, session) in sessions.enumerated() {
            if index >= 9 {
                break
            }
            
            let user = AgoraLiveTranscodingUser()
            user.uid = session.uid
            
            let xIndex = CGFloat(index % 3)
            let yIndex = CGFloat(index / 3)
            
            user.rect = CGRect(x: xIndex * (viewWidth + viewHEdge) + viewHEdge,
                               y: (virtualHeight - viewHeight) / 2 + (yIndex - 1) * (viewHeight + viewVEdge),
                               width: viewWidth,
                               height: viewHeight)
            user.alpha = randAlpha()
            users.append(user)
        }
        
        if canvasWidth > canvasHeight {
            for user in users {
                user.rect.swapXY()
            }
        }
        
        return users
    }
}

extension TranscodingLayout {
    static func randAlpha() -> Double {
        let value = arc4random_uniform(70) + 20
        return Double(value) / 100
    }
}
