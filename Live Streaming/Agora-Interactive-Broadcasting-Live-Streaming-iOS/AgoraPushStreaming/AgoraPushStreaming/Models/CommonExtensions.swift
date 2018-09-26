//
//  CommonExtensions.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2/14/16.
//  Copyright © 2016 Agora. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Cocoa
#endif

extension AGColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        func transform(_ input: Int, offset: Int = 0) -> CGFloat {
            let value = (input >> offset) & 0xff
            return CGFloat(value) / 255
        }
        
        self.init(red: transform(hex, offset: 16),
                  green: transform(hex, offset: 8),
                  blue: transform(hex),
                  alpha: alpha)
    }
    
    func rgbValue() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return (red * 255, green * 255, blue * 255)
    }
}

extension CGSize {
    func fixedSize(with reference: CGSize) -> CGSize {
        if reference.width > reference.height {
            return fixedLandscapeSize()
        } else {
            return fixedPortraitSize()
        }
    }
    
    func fixedLandscapeSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width < height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }
    
    func fixedPortraitSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width > height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }
    
    func fixedSize() -> CGSize {
        let width = self.width
        let height = self.height
        if width < height {
            return CGSize(width: height, height: width)
        } else {
            return self
        }
    }
}

extension CGRect {
    mutating func swapXY() {
        let x = origin.x
        origin.x = origin.y
        origin.y = x
        
        let width = size.width
        size.width = size.height
        size.height = width
    }
}

func arc4random<T: ExpressibleByIntegerLiteral>(_ type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, MemoryLayout<T>.size)
    return r
}

#if os(iOS)
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UILabel {
    var formattedFloatValue: Float {
        get {
            if let text = text, let value = Float(text) {
                return value
            } else {
                return 0
            }
        }
        set {
            text = NSString(format: "%.0f", newValue) as String
        }
    }
    
    var formattedCGFloatValue: CGFloat {
        get {
            if let text = text, let value = Float(text) {
                return CGFloat(value)
            } else {
                return 0
            }
        }
        set {
            text = NSString(format: "%.0f", newValue) as String
        }
    }
    
    var formattedIntValue: Int {
        get {
            if let text = text, let value = Int(text) {
                return value
            } else {
                return 0
            }
        }
        set {
            text = NSString(format: "%d", newValue) as String
        }
    }
    
    var formattedDoubleValue: Double {
        get {
            if let text = text, let value = Double(text) {
                return value
            } else {
                return 0
            }
        }
        set {
            text = NSString(format: "%.2f", newValue) as String
        }
    }
}

extension UISlider {
    var cgFloatValue: CGFloat {
        get {
            return CGFloat(value)
        }
        set {
            value = Float(newValue)
        }
    }
    
    var intValue: Int {
        get {
            return Int(value)
        }
        set {
            value = Float(newValue)
        }
    }
}

#else
extension NSButton {
    var isOn: Bool {
        get {
            return state > 0
        }
        set {
            state = newValue ? 1 : 0
        }
    }
}

extension NSTextField {
    var formattedFloatValue: Float {
        get {
            return floatValue
        }
        set {
            stringValue = NSString(format: "%.0f", newValue) as String
        }
    }
    
    var formattedCGFloatValue: CGFloat {
        get {
            return CGFloat(floatValue)
        }
        set {
            stringValue = NSString(format: "%.0f", newValue) as String
        }
    }
    
    var formattedIntValue: Int {
        get {
            return intValue
        }
        set {
            stringValue = NSString(format: "%d", newValue) as String
        }
    }
    
    var text: String {
        get {
            return stringValue
        }
        set {
            stringValue = newValue
        }
    }
}
#endif

extension DispatchTimeInterval {
    static func randomTimeInterval(during second1: UInt32, to second2: UInt32) -> DispatchTimeInterval {
        let time = arc4random_uniform(second2 - second1) + second1
        return DispatchTimeInterval.seconds(Int(time))
    }
}

extension Float {
    func description() -> String {
        return String(format: "%.2f", self)
    }
}
