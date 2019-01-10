//
//  PublishViewController.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/25.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

let PushUrl: String = <#Your Stream URL#>

protocol PublishVCDelegate: NSObjectProtocol {
    func publishVC(_ publishVC: PublishViewController, didAddPublishInfo info: PublishInfo)
    func publishVC(_ publishVC: PublishViewController, didRemovePublishInfo info: PublishInfo)
}

class PublishViewController: UIViewController {

    @IBOutlet weak var pushRtmpView: UIView!
    @IBOutlet weak var pushRtmpURLTableView: UITableView!
    var publishList = PublishList()
    var injectStreamPath: String?
    weak var delegate: PublishVCDelegate?
    
    private var publishResultObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 320, height: 380)
        
        publishResultObserver = NotificationCenter.default.addObserver(forName: PublishInfo.ResultNotification, object: nil, queue: nil) { [unowned self] notify in
            guard let info = notify.object as? PublishInfo else {
                return
            }
            
            for cell in self.pushRtmpURLTableView.visibleCells {
                if let cell = cell as? PublishInfoCell, let cellInfo = cell.info, cellInfo.url == info.url {
                    cell.info = info
                    break
                }
            }
        }
    }
    
    deinit {
        if let observer = publishResultObserver {
            NotificationCenter.default.removeObserver(observer)
            publishResultObserver = nil
        }
    }
    
    @IBAction func doRTMPTypeSwitched(_ sender: UISegmentedControl) {
        pushRtmpView.isHidden = sender.selectedSegmentIndex != 0
    }
    
    @IBAction func doAddNoneTranscodingPressed(_ sender: UIButton) {
        showPublishURLAlert(isTranscoding: false)
    }
    
    @IBAction func doAddTranscodingPressed(_ sender: UIButton) {
        showPublishURLAlert(isTranscoding: true)
    }
    

}

private extension PublishViewController {
    func showPublishURLAlert(isTranscoding: Bool) {
        let alert = UIAlertController(title: nil, message: "Set \(isTranscoding ? "Transcoding" : "None Transcoding") Stream", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Input name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else {
                return
            }
            
            let streamURL = self.streamURL(for: name)
            if let info = self.publishList.add(streamURL, isTranscoding: isTranscoding) {
                self.pushRtmpURLTableView.reloadData()
                self.delegate?.publishVC(self, didAddPublishInfo: info)
            } else {
                self.alert(string: "Existed name")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.textFields?.first?.accessibilityIdentifier = "publish_url"
        
        present(alert, animated: true, completion: nil)
    }
    //Setting Push Streaming URL, Also Custom url
    func streamURL(for room: String) -> String {
        return PushUrl + "\(room)"
    }
    func alert(string: String) {
        let alert = UIAlertController(title: nil, message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension PublishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case pushRtmpURLTableView:
            return publishList.infos.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case pushRtmpURLTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "publishInfoCell", for: indexPath) as! PublishInfoCell
            cell.info = publishList.infos[indexPath.row]
            cell.index = indexPath.row
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tableView {
        case pushRtmpURLTableView:
            let info = publishList.infos[indexPath.row]
            publishList.infos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            delegate?.publishVC(self, didRemovePublishInfo: info)
        default:
            break
        }
    }
}

extension PublishViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
