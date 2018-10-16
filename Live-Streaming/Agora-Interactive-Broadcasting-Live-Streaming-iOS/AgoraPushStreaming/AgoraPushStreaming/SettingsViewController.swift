//
//  SettingsViewController.swift
//  AgoraPushStreaming
//
//  Created by ZhangJi on 2018/9/28.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit

protocol SettingsVCDelegate: NSObjectProtocol {
    func settingsVC(_ settingsVC: SettingsViewController, didSelectProfile profile: CGSize)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!

    var videoProfile: CGSize! {
        didSet {
            profileTableView?.reloadData()
        }
    }
    weak var delegate: SettingsVCDelegate?
    
    fileprivate let profiles: [CGSize] = CGSize.list()
    
    @IBAction func doConfirmPressed(_ sender: UIButton) {
        delegate?.settingsVC(self, didSelectProfile: videoProfile)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        let selectedProfile = profiles[(indexPath as NSIndexPath).row]
        cell.update(withProfile: selectedProfile, isSelected: (selectedProfile == videoProfile))
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProfile = profiles[(indexPath as NSIndexPath).row]
        videoProfile = selectedProfile
    }
}

private extension CGSize {
    static func list() -> [CGSize] {
        return [AgoraVideoDimension160x120,
                AgoraVideoDimension320x180,
                AgoraVideoDimension320x240,
                AgoraVideoDimension640x360,
                AgoraVideoDimension640x480,
                AgoraVideoDimension1280x720]
    }
}
