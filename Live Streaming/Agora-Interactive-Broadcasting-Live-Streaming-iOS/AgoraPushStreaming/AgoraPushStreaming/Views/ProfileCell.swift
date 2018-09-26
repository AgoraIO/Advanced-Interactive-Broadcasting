//
//  ProfileCell.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 6/26/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var resLabel: UILabel!
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var bitRateLabel: UILabel!
    
    func update(with profile: AgoraVideoProfile, isSelected: Bool) {
        if let size = profile.resolution() {
            resLabel.text = "\(Int(size.width))x\(Int(size.height))"
        } else {
            resLabel.text = ""
        }
        
        if let bitRate = profile.bitRate() {
            bitRateLabel.text = "\(bitRate)"
        } else {
            bitRateLabel.text = ""
        }
        
        frameLabel.text = "\(profile.fps())"
        
        backgroundColor = isSelected ? UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.3) : UIColor.white
    }
}
