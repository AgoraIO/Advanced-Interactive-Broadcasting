//
//  DualStreamType.swift
//  AgoraPushStreaming
//
//  Created by 湛孝超 on 2018/2/26.
//  Copyright © 2018年 湛孝超. All rights reserved.
//

import Foundation
enum DualStreamType {
    case auto, enable, disable
}

extension DualStreamType {
    static func type(of index: Int) -> DualStreamType? {
        switch index {
        case 0:     return .auto
        case 1:     return .enable
        case 2:     return .disable
        default:    return nil
        }
    }
}

