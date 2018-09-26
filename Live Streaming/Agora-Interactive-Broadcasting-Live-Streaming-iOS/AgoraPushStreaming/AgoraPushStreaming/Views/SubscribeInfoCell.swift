//
//  SubscribeInfoCell.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/24.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

protocol SubscribeInfoCellDelegate: NSObjectProtocol {
    func subscribeInfoCell(_ cell: SubscribeInfoCell, didUpdateSubscribeInfo info: SubscribeInfo)
}

class SubscribeInfoCell: UITableViewCell {

    @IBOutlet weak var uidLable: UILabel!
    @IBOutlet weak var subscribeSwitch: UISwitch!
    @IBOutlet weak var mediaTypeSwitch: UISegmentedControl!
    @IBOutlet weak var renderModeSwitch: UISegmentedControl!
    @IBOutlet weak var videoTypeSwitch: UISegmentedControl!
    @IBOutlet weak var interactionButton: UIButton!
    @IBOutlet weak var requestingSpinner: UIActivityIndicatorView!
    
    weak var delegate: SubscribeInfoCellDelegate?
    var subscribeInfo = SubscribeInfo(uid: 0) {
        didSet {
            uidLable?.text = "\(subscribeInfo.uid)"
            subscribeSwitch?.isOn = subscribeInfo.isSubscribed
            mediaTypeSwitch?.selectedSegmentIndex = subscribeInfo.mediaType.index()
            renderModeSwitch?.selectedSegmentIndex = subscribeInfo.renderMode.index()
            videoTypeSwitch?.selectedSegmentIndex = subscribeInfo.videoType.index()
            
            if subscribeInfo.isRequesting {
                requestingSpinner?.startAnimating()
            } else {
                requestingSpinner?.stopAnimating()
            }
        }
    }

    
    @IBAction func doSubscribeSwitched(_ sender: UISwitch) {
        subscribeInfo.isSubscribed = sender.isOn
        delegate?.subscribeInfoCell(self, didUpdateSubscribeInfo: subscribeInfo)
    }
    
    @IBAction func doMediaTypeSwitched(_ sender: UISegmentedControl) {
        if let type = AgoraMediaType.type(at: sender.selectedSegmentIndex) {
            subscribeInfo.mediaType = type
            delegate?.subscribeInfoCell(self, didUpdateSubscribeInfo: subscribeInfo)
        }
    }
    
    @IBAction func doRenderModeSwitched(_ sender: UISegmentedControl) {
        if let renderMode = AgoraVideoRenderMode.mode(at: sender.selectedSegmentIndex) {
            subscribeInfo.renderMode = renderMode
            delegate?.subscribeInfoCell(self, didUpdateSubscribeInfo: subscribeInfo)
        }
    }
    
    @IBAction func doVideoTypeSwitched(_ sender: UISegmentedControl) {
        if let videoType = AgoraVideoStreamType.type(at: sender.selectedSegmentIndex) {
            subscribeInfo.videoType = videoType
            delegate?.subscribeInfoCell(self, didUpdateSubscribeInfo: subscribeInfo)
        }
    }
    
}
