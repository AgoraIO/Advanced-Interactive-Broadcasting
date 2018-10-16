//
//  PublishInfoCell.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/25.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

class PublishInfoCell: UITableViewCell {

    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var transcodingLabel: UILabel!
    
    var index: Int = 0 {
        didSet {
            urlLabel?.accessibilityIdentifier = "list_url\(index + 1)"
            intervalLabel?.accessibilityIdentifier = "time_url\(index + 1)"
        }
    }
    
    var info: PublishInfo? {
        didSet {
            guard let info = info else {
                return
            }
          
            urlLabel?.text = info.url
            urlLabel?.accessibilityValue = info.url
            
            transcodingLabel?.isHidden = !info.isTranscoding
            
            if let isSuccess = info.isSuccess {
                urlLabel?.textColor = isSuccess ? UIColor.blue : UIColor.red
            } else {
                urlLabel?.textColor = UIColor.black
            }
            
            if let interval = info.successInterval {
                intervalLabel?.formattedDoubleValue = interval
                intervalLabel?.accessibilityValue = NSString(format: "%.2f", interval) as String
            } else {
                intervalLabel?.text = ""
                intervalLabel?.accessibilityValue = ""
            }
        }
    }
}
