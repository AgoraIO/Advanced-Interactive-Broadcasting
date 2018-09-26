//
//  Message.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 16/8/19.
//  Copyright © 2016年 Agora. All rights reserved.
//

import Foundation
import UIKit

enum MessageType {
    case chat, alert, warning, info
    
    func color() -> UIColor {
        switch self {
        case .chat:     return UIColor(hex: 0x444444, alpha: 0.6)
        case .alert:    return UIColor(hex: 0xff3c32, alpha: 0.6)
        case .warning:  return UIColor(hex: 0xffa22e, alpha: 0.6)
        case .info:     return UIColor(hex: 0x23b9dc, alpha: 0.6)
        }
    }
}

struct Message {
    var uid: Int64?
    var text: String!
    var type: MessageType = .chat
    
    init(text: String, type: MessageType, uid: Int64? = nil) {
        self.text = text
        self.type = type
        self.uid = uid
    }
    
    func string() -> String {
        let string = text ?? " "
        
        if let uid = uid {
            return "\(uid): \(string)"
        } else {
            return string
        }
    }
}
    
