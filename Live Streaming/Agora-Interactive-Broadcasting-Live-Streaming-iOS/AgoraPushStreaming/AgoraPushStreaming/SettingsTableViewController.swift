//
//  SettingsTableViewController.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/9/18.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

protocol SettingsTableVCDelegate: NSObjectProtocol {
    func settingsTableVCNeedClose(_ settingsTableVC: SettingsTableViewController)
}

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var videoProfileLabel: UILabel!
    @IBOutlet weak var renderModeSwitch: UISegmentedControl!
    @IBOutlet weak var audioProfileLabel: UILabel!
    @IBOutlet weak var audioScenarioLabel: UILabel!
    @IBOutlet weak var autoTestTypeSwitch: UISegmentedControl!
    @IBOutlet weak var dualStreamTypeSwitch: UISegmentedControl!
    
    var renderMode = AgoraVideoRenderMode.hidden
    var videoProfile: AgoraVideoProfile! {
        didSet {
            updateVideoProfileLabel()
        }
    }
    var audioProfile = AgoraAudioProfile.default {
        didSet {
            updateAudioProfileLabel()
        }
    }
    var audioScenario = AgoraAudioScenario.default {
        didSet {
            updateAudioScenarioLabel()
        }
    }
    var autoTestType: AutoTestType?
    var dualStreamType = DualStreamType.auto
    var customParameters: CustomParameters!
    weak var delegate: SettingsTableVCDelegate?
    
    fileprivate let renderModes = AgoraVideoRenderMode.validRenderModes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateVideoProfileLabel()
        loadRenderModeItems()
        updateAudioProfileLabel()
        updateAudioScenarioLabel()
        updateAutoTestButtons()
        updateDualStreamButtons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, !segueId.isEmpty else {
            return
        }
        
        switch segueId {
        case "settingsToVideoProfiles":
            let videoProfileVC = segue.destination as! VideoProfilesViewController
            videoProfileVC.videoProfile = videoProfile
            videoProfileVC.delegate = self
        case "settingsToCustomParameters":
            let customParametersVC = segue.destination as! CustomParameterViewController
            customParametersVC.customParameters = customParameters
            customParametersVC.canDeleteParameter = true
            customParametersVC.delegate = self
        default:
            break
        }
    }
    
    @IBAction func doRenderModeSwitched(_ sender: UISegmentedControl) {
        if let renderMode = AgoraVideoRenderMode.mode(at: sender.selectedSegmentIndex) {
            self.renderMode = renderMode
        }
    }
    
    @IBAction func doAutoTestSwitched(_ sender: UISegmentedControl) {
        autoTestType = AutoTestType.type(of: sender.selectedSegmentIndex)
    }
    
    @IBAction func doDualStreamSwitched(_ sender: UISegmentedControl) {
        if let type = DualStreamType.type(of: sender.selectedSegmentIndex) {
            dualStreamType = type
        }
    }
    
    @IBAction func doOkPressed(_ sender: UIBarButtonItem) {
        delegate?.settingsTableVCNeedClose(self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            showAudioProfiles(fromView: audioProfileLabel)
        case 3:
            showAudioScenarios(fromView: audioScenarioLabel)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension SettingsTableViewController {
    func updateVideoProfileLabel() {
        videoProfileLabel?.text = videoProfile.description()
    }
    
    func loadRenderModeItems() {
        renderModeSwitch.removeAllSegments()
        for (index, renderMode) in renderModes.enumerated() {
            renderModeSwitch.insertSegment(withTitle: renderMode.description(), at: index, animated: false)
        }
        if let index = renderModes.index(of: renderMode) {
            renderModeSwitch.selectedSegmentIndex = index
        }
    }
    
    func updateAudioProfileLabel() {
        audioProfileLabel?.text = audioProfile.description()
    }
    
    func updateAudioScenarioLabel() {
        audioScenarioLabel?.text = audioScenario.description()
    }
    
    func updateAutoTestButtons() {
        if let type = autoTestType {
            switch type {
            case .joinLeave:    autoTestTypeSwitch.selectedSegmentIndex = 1
            case .muteUnmute:   autoTestTypeSwitch.selectedSegmentIndex = 2
            }
        } else {
//            autoTestTypeSwitch.selectedSegmentIndex = 0
        }
    }
    
    func updateDualStreamButtons() {
        switch dualStreamType {
        case .auto:     dualStreamTypeSwitch.selectedSegmentIndex = 0
        case .enable:   dualStreamTypeSwitch.selectedSegmentIndex = 1
        case .disable:  dualStreamTypeSwitch.selectedSegmentIndex = 2
        }
    }
}

private extension SettingsTableViewController {
    func showAudioProfiles(fromView view: UIView) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for profile in AgoraAudioProfile.validList() {
            let action = UIAlertAction(title: profile.description(), style: .default, handler: { [unowned self]_ in
                self.audioProfile = profile
            })
            sheet.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cancel)
        
        if let popoverController = sheet.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = view.bounds
        }
        present(sheet, animated: true, completion: nil)
    }
    
    func showAudioScenarios(fromView view: UIView) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for scenario in AgoraAudioScenario.validList() {
            let action = UIAlertAction(title: scenario.description(), style: .default, handler: { [unowned self]_ in
                self.audioScenario = scenario
            })
            sheet.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cancel)
        
        if let popoverController = sheet.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = view.bounds
        }
        present(sheet, animated: true, completion: nil)
    }
}

extension SettingsTableViewController: VideoProfilesVCDelegate {
    func videoProfilesVC(_ videoProfilesVC: VideoProfilesViewController, didSelectProfile profile: AgoraVideoProfile) {
        videoProfile = profile
    }
}

extension SettingsTableViewController: CustomParameterVCDelegate {
    func customParameterVCDidChanged(_ customParameterVC: CustomParameterViewController, changed: CustomParameter?) {
        self.customParameters = customParameterVC.customParameters
    }
}
