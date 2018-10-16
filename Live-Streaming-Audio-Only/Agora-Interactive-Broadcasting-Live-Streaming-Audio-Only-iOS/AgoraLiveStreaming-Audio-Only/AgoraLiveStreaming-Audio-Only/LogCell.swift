//
//  LogCell.swift
//  AgoraLiveStreaming-Audio-Only
//
//  Created by ZhangJi on 2018/8/3.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var logLabel: UILabel!
    
    func set(log: String) {        
        logLabel.text = log
    }
}
