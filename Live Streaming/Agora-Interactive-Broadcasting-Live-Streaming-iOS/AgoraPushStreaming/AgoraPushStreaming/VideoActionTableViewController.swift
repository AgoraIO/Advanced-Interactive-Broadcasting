//
//  VideoActionTableViewController.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/9/14.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

protocol VideoActionTableVCDelegate: NSObjectProtocol {
    func videoActionTableVC(_ vc: VideoActionTableViewController, needPublish: Bool)
    func videoActionTableVCNeedSwitchCamera(_ vc: VideoActionTableViewController)
}

class VideoActionTableViewController: UITableViewController {
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    
    var isPublishing = false {
        didSet {
            updateButtonTitles()
        }
    }
    
    var isPreview = false {
        didSet {
            updateButtonTitles()
        }
    }
    
    weak var delegate: VideoActionTableVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 240, height: 131)
        updateButtonTitles()
    }
    
    @IBAction func doPublishPressed(_ sender: UIButton) {
        isPublishing = !isPublishing
        delegate?.videoActionTableVC(self, needPublish: isPublishing)
    }
    
    @IBAction func doSwitchCameraPressed(_ sender: UIButton) {
        delegate?.videoActionTableVCNeedSwitchCamera(self)
    }
    

}

private extension VideoActionTableViewController {
    func updateButtonTitles() {
        let normalColor = #colorLiteral(red: 0.2823529412, green: 0.3921568627, blue: 1, alpha: 1);
        let highlightColor = #colorLiteral(red: 1, green: 0.3450980392, blue: 0.3450980392, alpha: 1);
        publishButton?.setTitle(isPublishing ? "Stop Publish" : "Publish", for: .normal)
        publishButton?.setTitleColor(isPublishing ? highlightColor : normalColor, for: .normal)
        switchCameraButton?.setTitleColor(normalColor, for: .normal)
        previewButton?.setTitle(isPreview ? "Stop Preview" : "Start Preview", for: .normal)
        previewButton?.setTitleColor(isPreview ? highlightColor : normalColor, for: .normal)
    }
}
