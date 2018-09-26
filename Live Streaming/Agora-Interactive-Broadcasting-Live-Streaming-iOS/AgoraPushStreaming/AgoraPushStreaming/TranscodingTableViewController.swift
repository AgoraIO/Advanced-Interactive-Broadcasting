//
//  TranscodingTableViewController.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2017/7/31.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

protocol TranscodingTableVCDelegate: NSObjectProtocol {
    func transcodingTableVCDidUpdate(_ transcodingTableVC: TranscodingTableViewController)
}

class TranscodingTableViewController: UITableViewController {

    @IBOutlet weak var enableCustomSwitch: UISwitch!
    
    // video
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var widthLabel: UILabel!
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var bitrateSlider: UISlider!
    @IBOutlet weak var bitrateLabel: UILabel!
    
    @IBOutlet weak var fpsSlider: UISlider!
    @IBOutlet weak var fpsLabel: UILabel!
    
    @IBOutlet weak var gopSlider: UISlider!
    @IBOutlet weak var gopLabel: UILabel!
    
    @IBOutlet weak var lowLatencySwitch: UISwitch!
    
    @IBOutlet weak var videoCodecSwitch: UISegmentedControl!
    
    // audio
    @IBOutlet weak var sampleRateSwitch: UISegmentedControl!
    @IBOutlet weak var audioBitRateSwitch: UISegmentedControl!
    @IBOutlet weak var audioChannelsSwitch: UISegmentedControl!
    @IBOutlet weak var audioOnlyUseChannel0Switch: UISwitch!
    
    // background coloe
    @IBOutlet weak var colorEnabledSwitch: UISwitch!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var blueLabel: UILabel!
    
    // layout
    @IBOutlet weak var transcodingLayoutSwitch: UISegmentedControl!
    
    //
    var transcoding: AgoraLiveTranscoding!
    var isCustomTranscodingSettings = false
    var transcodingLayout: TranscodingLayout?
    var isOnlyChannel0 = true
    
    weak var delegate: TranscodingTableVCDelegate?
    
    fileprivate var backgroundColor = UIColor.white {
        didSet {
            colorView?.backgroundColor = backgroundColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: 320, height: 380)
        
        updateView(with: transcoding, isCustom: isCustomTranscodingSettings)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.transcodingTableVCDidUpdate(self)
    }
    
    @IBAction func doEnableCustomSwitched(_ sender: UISwitch) {
        isCustomTranscodingSettings = sender.isOn
    }
    
    @IBAction func doWidthSlided(_ sender: UISlider) {
        let width = sender.value
        widthLabel.formattedFloatValue = width
        transcoding.size.width = CGFloat(width)
    }
    
    @IBAction func doHeightSlided(_ sender: UISlider) {
        let height = sender.value
        heightLabel.formattedFloatValue = height
        transcoding.size.height = CGFloat(height)
    }
    
    @IBAction func doBitrateSlided(_ sender: UISlider) {
        let bitrate = sender.value
        bitrateLabel.formattedFloatValue = bitrate
        transcoding.videoBitrate = Int(bitrate)
    }
    
    @IBAction func doFPSSlided(_ sender: UISlider) {
        let fps = sender.value
        fpsLabel.formattedFloatValue = fps
        transcoding.videoFramerate = Int(fps)
    }
    
    @IBAction func doGOPSlided(_ sender: UISlider) {
        let gop = sender.value
        gopLabel.formattedFloatValue = gop
        transcoding.videoGop = Int(gop)
    }
    
    @IBAction func doLowLatencySwitched(_ sender: UISwitch) {
        transcoding.lowLatency = sender.isOn
    }
    
    @IBAction func doVideoCodecSwitched(_ sender: UISegmentedControl) {
        if let codec = AgoraVideoCodecProfileType.codec(at: sender.selectedSegmentIndex) {
            transcoding.videoCodecProfile = codec
        }
    }
    
    @IBAction func doAudioSampleRateSwitched(_ sender: UISegmentedControl) {
        if let audioSampleRate = AgoraAudioSampleRateType.sampleRate(at: sender.selectedSegmentIndex) {
            transcoding.audioSampleRate = audioSampleRate
        }
    }
    
    @IBAction func doAudioBitRateSwitched(_ sender: UISegmentedControl) {
        if let bitRateType = AGStreamAudioBitRate.bitRate(at: sender.selectedSegmentIndex) {
            transcoding.audioBitrate = bitRateType.rawValue
        }
    }
    
    @IBAction func doAudioChannelsSwitched(_ sender: UISegmentedControl) {
        transcoding.audioChannels = sender.selectedSegmentIndex + 1
    }
    
    @IBAction func doAudioOnlyChannel0Switched(_ sender: UISwitch) {
        isOnlyChannel0 = sender.isOn
    }
    
    @IBAction func doColorEnableSwitched(_ sender: UISwitch) {
        transcoding.backgroundColor = sender.isOn ? backgroundColor : nil
    }
    
    @IBAction func doColorSlided(_ sender: UISlider) {
        let r = redSlider.cgFloatValue
        let g = greenSlider.cgFloatValue
        let b = blueSlider.cgFloatValue
        
        backgroundColor = UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
        redLabel.formattedCGFloatValue = r
        greenLabel.formattedCGFloatValue = g
        blueLabel.formattedCGFloatValue = b
        
        if let _ = transcoding.backgroundColor {
            transcoding.backgroundColor = backgroundColor
        }
    }
    
    @IBAction func doTranscodingLayoutSwitched(_ sender: UISegmentedControl) {
        transcodingLayout = TranscodingLayout.type(ofIndex: sender.selectedSegmentIndex)
    }
}

private extension TranscodingTableViewController {
    func updateView(with transcoding: AgoraLiveTranscoding, isCustom: Bool) {
        enableCustomSwitch.isOn = isCustom
        
        let width = transcoding.size.width
        widthSlider.cgFloatValue = width
        widthLabel.formattedCGFloatValue = width
        
        let height = transcoding.size.height
        heightSlider.cgFloatValue = height
        heightLabel.formattedCGFloatValue = height
        
        let bitRate = transcoding.videoBitrate
        bitrateSlider.intValue = bitRate
        bitrateLabel.formattedIntValue = bitRate
        
        let fps = transcoding.videoFramerate
        fpsSlider.intValue = fps
        fpsLabel.formattedIntValue = fps
        
        let gop = transcoding.videoGop
        gopSlider.intValue = gop
        gopLabel.formattedIntValue = gop
        
        lowLatencySwitch.isOn = transcoding.lowLatency
        videoCodecSwitch.selectedSegmentIndex = transcoding.videoCodecProfile.index()
        
        sampleRateSwitch.selectedSegmentIndex = transcoding.audioSampleRate.index()
        if let index = AGStreamAudioBitRate.index(of: transcoding.audioBitrate) {
            audioBitRateSwitch.selectedSegmentIndex = index
        }
        audioChannelsSwitch.selectedSegmentIndex = transcoding.audioChannels - 1
        audioOnlyUseChannel0Switch.isOn = isOnlyChannel0
        
        if let backgroundColor = transcoding.backgroundColor {
            self.backgroundColor = backgroundColor
            colorEnabledSwitch.isOn = true
            
            let (r, g, b) = backgroundColor.rgbValue()
            redSlider.cgFloatValue = r
            redLabel.formattedCGFloatValue = r
            greenSlider.cgFloatValue = g
            greenLabel.formattedCGFloatValue = g
            blueSlider.cgFloatValue = b
            blueLabel.formattedCGFloatValue = b
        } else {
            colorEnabledSwitch.isOn = false
        }
        
        if let transcodingLayout = transcodingLayout {
            transcodingLayoutSwitch.selectedSegmentIndex = transcodingLayout.index()
        } else {
            transcodingLayoutSwitch.selectedSegmentIndex = 0
        }
    }
}

extension AgoraVideoCodecProfileType {
    func index() -> Int {
        switch self {
        case .baseLine: return 0
        case .main: return 1
        case .high: return 2
        }
    }
    
    static func codec(at index: Int) -> AgoraVideoCodecProfileType? {
        switch index {
        case 0: return .baseLine
        case 1: return .main
        case 2: return .high
        default: return nil
        }
    }
}

extension AgoraAudioSampleRateType {
    func index() -> Int {
        switch self {
        case .type32000: return 0
        case .type44100: return 1
        case .type48000: return 2
        }
    }
    
    static func sampleRate(at index: Int) -> AgoraAudioSampleRateType? {
        switch index {
        case 0: return .type32000
        case 1: return .type44100
        case 2: return .type48000
        default: return nil
        }
    }
}

enum AGStreamAudioBitRate: Int {
    case type48k = 48
    case type128k = 128
    
    static func index(of rate: Int) -> Int? {
        switch rate {
        case 48:    return 0
        case 128:   return 1
        default:        return nil
        }
    }
    
    static func bitRate(at index: Int) -> AGStreamAudioBitRate? {
        switch index {
        case 0: return .type48k
        case 1: return .type128k
        default: return nil
        }
    }
}
