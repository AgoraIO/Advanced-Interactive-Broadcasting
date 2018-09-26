//
//  CustomParameters.swift
//  AgoraPremium
//
//  Created by GongYuhua on 2017/2/28.
//  Copyright © 2017年 Agora. All rights reserved.
//

import Foundation

class CustomParameter {
    var key: String
    var value: String
    
    static let placeholderOfKey = "Key: string without quotation marks"
    static let placeholderOfValue = "Value: number, bool, string"
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    func jsonString() -> String {
        return "{\"\(key)\":\(value)}"
    }
    
    func isValid() -> Bool {
        if let data = jsonString().data(using: .utf8), let _ = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            return true
        } else {
            return false
        }
    }
}

class CustomParameters {
    var list = [CustomParameter]()
    
    func addParameter(_ key: String, value: String) -> CustomParameter {
        let parameter = CustomParameter(key: key, value: value)
        list.append(parameter)
        return parameter
    }
    
    func removeParameter(at index: Int) -> CustomParameter? {
        if list.count > index {
            return list.remove(at: index)
        }
        
        return nil
    }
    
    func shouldWarning() -> Bool {
        return list.count > 0
    }
}
