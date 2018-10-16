//
//  MainViewController.swift
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/5.
//  Copyright © 2017 Agora. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var sampleRateSwitcher: UISegmentedControl!
    @IBOutlet weak var samplesPerCallSwitcher: UISegmentedControl!
    
    private let sampleRateArray = [8000, 16000, 32000, 441000, 48000]
    private let samplesPerCallArray = [360, 720, 1024, 2048]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return
        }
        
        switch segueId {
        case "mainToLive":
            let liveVC = segue.destination as! LiveRoomViewController
            liveVC.roomName = roomNameTextField.text!
            if let value = sender as? NSNumber, let role = AgoraClientRole(rawValue: value.intValue) {
                liveVC.clientRole = role
            }
            
            liveVC.sampleRate = sampleRateArray[sampleRateSwitcher.selectedSegmentIndex]
            liveVC.samplesPerCall = samplesPerCallArray[samplesPerCallSwitcher.selectedSegmentIndex]
            
            liveVC.delegate = self
            
        default:
            break
        }
    }
    
    @IBAction func doJoinPressed(_ sender: UIButton) {
        guard let string = roomNameTextField.text , !string.isEmpty else {
            return
        }
        
        showRoleSelection()
    }
}

private extension MainViewController {
    func showRoleSelection() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let broadcaster = UIAlertAction(title: "Broadcaster", style: .default) { [weak self] _ in
            self?.join(withRole: .broadcaster)
        }
        let audience = UIAlertAction(title: "Audience", style: .default) { [weak self] _ in
            self?.join(withRole: .audience)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(broadcaster)
        sheet.addAction(audience)
        sheet.addAction(cancel)
        sheet.popoverPresentationController?.sourceView = joinButton
        sheet.popoverPresentationController?.sourceRect = joinButton.frame
        sheet.popoverPresentationController?.permittedArrowDirections = .up
        present(sheet, animated: true, completion: nil)
    }
    
    func join(withRole role: AgoraClientRole) {
        performSegue(withIdentifier: "mainToLive", sender: NSNumber(value: role.rawValue as Int))
    }
}

extension MainViewController: LiveRoomVCDelegate {
    func liveVCNeedClose(_ liveVC: LiveRoomViewController) {
        let _ = navigationController?.popViewController(animated: true)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let string = textField.text , !string.isEmpty {
            showRoleSelection()
        }
        
        return true
    }
}
