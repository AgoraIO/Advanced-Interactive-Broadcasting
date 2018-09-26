//
//  ViewController.swift
//  AgoraPushStreaming
//
//  Created by 湛孝超 on 2018/2/26.
//  Copyright © 2018年 湛孝超. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var channelName: UITextField!
    @IBOutlet weak var versionLabel: UILabel!
    fileprivate let channelConfig =  AgoraLiveChannelConfig.default()
    fileprivate var localRenderMode = AgoraVideoRenderMode.hidden
    fileprivate var videoProfile = AgoraVideoProfile.portrait360P
    fileprivate var audioProfile = AgoraAudioProfile.default
    fileprivate var audioScenario = AgoraAudioScenario.default
    fileprivate var dualStreamType = DualStreamType.auto
    fileprivate var customParameters = CustomParameters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVersion()
        
        
        
            }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier,!segueId.isEmpty else {
            return
        }
        switch segueId {
        case "mainToChannel":
            let channelVC = segue.destination as! ChannelViewController
            channelVC.channel = channelName.text
            channelVC.channelConfig = channelConfig
            channelVC.videoProfile = videoProfile
            channelVC.localRenderMode = localRenderMode
            channelVC.audioProfile = audioProfile
            channelVC.audioScenario = audioScenario
            channelVC.dualStreamType = dualStreamType
            channelVC.customParameters = customParameters
        case "mainToSettings":
            let naviVC = segue.destination as! UINavigationController
            let settingsVC = naviVC.viewControllers.first as! SettingsTableViewController
            settingsVC.videoProfile = videoProfile
            settingsVC.renderMode = localRenderMode
            settingsVC.audioProfile = audioProfile
            settingsVC.audioScenario = audioScenario
            settingsVC.dualStreamType = dualStreamType
            settingsVC.customParameters = customParameters
            settingsVC.delegate = self
        default:
            break
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
    //MARK:join channel
    func enterChannel() {
        guard let channel = channelName.text, !channel.isEmpty else {
            return
        }
        performSegue(withIdentifier: "mainToChannel", sender: channel)
    }
    
}
private extension ViewController{
    func loadVersion(){
        if let version  = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String{
        let sdkVersion = AgoraRtcEngineKit.getSdkVersion()
        versionLabel.text = "v\(version) build\(build),sdk\(sdkVersion)"
    }
    }
}
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case channelName:enterChannel()
            
        default:
            break
      
      }
    return true
    }
}
extension ViewController:SettingsTableVCDelegate{
    func settingsTableVCNeedClose(_ settingsTableVC: SettingsTableViewController) {
        videoProfile = settingsTableVC.videoProfile
        localRenderMode = settingsTableVC.renderMode
        audioScenario = settingsTableVC.audioScenario
        audioProfile = settingsTableVC.audioProfile
        dualStreamType = settingsTableVC.dualStreamType
        customParameters = settingsTableVC.customParameters
        dismiss(animated: true, completion: nil)
    }
    
    
}
