//
//  VideoProfilesViewController.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2016/12/6.
//  Copyright © 2016年 Agora. All rights reserved.
//

import UIKit

protocol VideoProfilesVCDelegate: NSObjectProtocol {
    func videoProfilesVC(_ videoProfilesVC: VideoProfilesViewController, didSelectProfile profile: AgoraVideoProfile)
}

class VideoProfilesViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    
    var videoProfile: AgoraVideoProfile! {
        didSet {
            profileTableView?.reloadData()
        }
    }
    weak var delegate: VideoProfilesVCDelegate?
    
    fileprivate let profiles = AgoraVideoProfile.validProfileList()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.videoProfilesVC(self, didSelectProfile: videoProfile)
    }
}

extension VideoProfilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        let profile = profiles[indexPath.row]
        
        let isSelected = (profile == videoProfile)
        cell.update(with: profile, isSelected: isSelected)
        
        return cell
    }
}

extension VideoProfilesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProfile = profiles[indexPath.row]
        videoProfile = selectedProfile
    }
}
