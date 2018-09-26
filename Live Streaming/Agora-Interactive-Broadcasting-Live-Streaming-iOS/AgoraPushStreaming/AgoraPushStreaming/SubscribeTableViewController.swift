//
//  SubscribeTableViewController.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/24.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

protocol SubscribeTableVCDelegate: NSObjectProtocol {
    func subscribeTableVC(_ subscribeTableVC: SubscribeTableViewController, didUpdateSubscribeInfo info: SubscribeInfo)
//    func subscribeTableVC(_ subscribeTableVC: SubscribeTableViewController, didInteractive type: InteractiveType, toUid uid: UInt)
}

class SubscribeTableViewController: UITableViewController {

    var subscribeList = SubscribeList() {
        didSet {
            tableView?.reloadData()
        }
    }
    var isPublishing = false
    weak var delegate: SubscribeTableVCDelegate?
    
    private var requestResultObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 240, height: 360)
        
        requestResultObserver = NotificationCenter.default.addObserver(forName: SubscribeInfo.ResultNotification, object: nil, queue: nil) { [unowned self] notify in
            guard let info = notify.object as? SubscribeInfo else {
                return
            }
            
            for cell in self.tableView.visibleCells {
                if let cell = cell as? SubscribeInfoCell, cell.subscribeInfo.uid == info.uid {
                    cell.subscribeInfo = info
                    break
                }
            }
        }
    }
    
    deinit {
        if let observer = requestResultObserver {
            NotificationCenter.default.removeObserver(observer)
            requestResultObserver = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeList.infos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscribeInfoCell", for: indexPath) as! SubscribeInfoCell
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 198
    }
}

extension SubscribeTableViewController: SubscribeInfoCellDelegate {
    func subscribeInfoCell(_ cell: SubscribeInfoCell, didUpdateSubscribeInfo info: SubscribeInfo) {
        
        delegate?.subscribeTableVC(self, didUpdateSubscribeInfo: info)
        
    }
    
//    func subscribeInfoCell(_ cell: SubscribeInfoCell, didInteractive type: InteractiveType, toUid uid: UInt) {
//        delegate?.subscribeTableVC(self, didInteractive: type, toUid: uid)
//    }
}
