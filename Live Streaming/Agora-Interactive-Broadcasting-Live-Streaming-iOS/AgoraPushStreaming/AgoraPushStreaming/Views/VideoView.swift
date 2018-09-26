//
//  VideoView.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 2/14/16.
//  Copyright © 2016 Agora. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Cocoa
#endif

class VideoView: AGView {
    
    fileprivate(set) var videoView: AGView!
    
    fileprivate var infoView: AGView!
    fileprivate var videoInfoLabel: AGLabel!
    fileprivate var audioInfoLabel: AGLabel!
    fileprivate var userInfoLabel: AGLabel!
    fileprivate var streamTypeInfoLabel: AGLabel!
    fileprivate var viewSizeLabel: AGLabel!
    fileprivate var audioQualityLabel: AGLabel!
    fileprivate var speakingLabel: AGLabel!
    
    var isVideoMuted = false {
        didSet {
            let description = isVideoMuted ? "Video Muted" : ""
            videoInfoLabel?.text = description
        }
    }
    var isVideoDisabled = false {
        didSet {
            let description = isVideoDisabled ? "Video Disabled" : ""
            videoInfoLabel?.text = description
        }
    }
    var isSpeaking = false {
        didSet {
            speakingLabel?.isHidden = !isSpeaking
        }
    }
    
    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        translatesAutoresizingMaskIntoConstraints = false
    #if os(iOS)
        backgroundColor = AGColor.lightGray
    #else
        wantsLayer = true
        layer?.backgroundColor = AGColor.lightGray.cgColor
    #endif
        
        addVideoView()
        addInfoView()
        addViewSizeLabel()
    }
    
#if os(iOS)
    override var bounds: CGRect {
        didSet {
            let string = "\(bounds.width)*\(bounds.height)"
            viewSizeLabel?.text = string
        }
    }
#else
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        let string = "\(newSize.width)*\(newSize.height)"
        viewSizeLabel?.stringValue = string
    
    }
#endif
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension VideoView {
    func updateVideoInfo(withInfo info: MediaInfo) {
        guard !isVideoMuted, !isVideoDisabled else {
            return
        }
        
        videoInfoLabel?.text = info.description()
    }
    
    func updateAudioInfo(withVolume volume: Int, isMuted: Bool) {
        let description = isMuted ? "Audio Muted" : "vol: \(volume)"
        audioInfoLabel?.text = description
    }
    
    func updateUserInfo(withUid uid: UInt) {
        let description = "uid: \(uid)"
        userInfoLabel?.text = description
    }
    
    func updateStreamTypeInto(withType type: AgoraVideoStreamType) {
        let description = "stream: \(type.description())"
        streamTypeInfoLabel?.text = description
    }
    
    func updateAudioQuality(_ quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
        audioQualityLabel?.text = "audio: \(quality.description()), delay: \(delay)"
    }
}

private extension VideoView {
    func addVideoView() {
        videoView = AGView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
    #if os(iOS)
        videoView.backgroundColor = AGColor.clear
    #endif
        addSubview(videoView)
        
        let videoViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[video]|", options: [], metrics: nil, views: ["video": videoView])
        let videoViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[video]|", options: [], metrics: nil, views: ["video": videoView])
        NSLayoutConstraint.activate(videoViewH + videoViewV)
    }
    
    func addInfoView() {
        infoView = AGView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
    #if os(iOS)
        infoView.backgroundColor = AGColor.clear
    #endif
        
        addSubview(infoView)
        let infoViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[info]|", options: [], metrics: nil, views: ["info": infoView])
        let infoViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[info(==135)]", options: [], metrics: nil, views: ["info": infoView])
        infoView.lowerContentCompressionResistancePriority()
        NSLayoutConstraint.activate(infoViewH + infoViewV)
        
        videoInfoLabel = createInfoLabel()
        audioInfoLabel = createInfoLabel()
        userInfoLabel = createInfoLabel()
        streamTypeInfoLabel = createInfoLabel()
        audioQualityLabel = createInfoLabel()
        speakingLabel = createInfoLabel(withText: "Speaking", textColor: AGColor.red)
        speakingLabel.isHidden = true
        
        infoView.addSubview(videoInfoLabel)
        infoView.addSubview(audioInfoLabel)
        infoView.addSubview(userInfoLabel)
        infoView.addSubview(streamTypeInfoLabel)
        infoView.addSubview(audioQualityLabel)
        infoView.addSubview(speakingLabel)
        
    #if os(iOS)
        let top: CGFloat = 20
        let left: CGFloat = 2
    #else
        let top: CGFloat = 16
        let left: CGFloat = 8
    #endif
        
        func layoutLabel(_ label: AGLabel, topView: AGView?, topMargin: CGFloat, leftView: AGView?, leftMargin: CGFloat) {
            let v: [NSLayoutConstraint]
            let h: [NSLayoutConstraint]
            if let topView = topView {
                v = NSLayoutConstraint.constraints(withVisualFormat: "V:[topView]-(\(topMargin))-[label]", options: [], metrics: nil, views: ["topView": topView, "label": label])
            } else {
                v = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(topMargin))-[label]", options: [], metrics: nil, views: ["label": label])
            }
            
            if let leftView = leftView {
                h = NSLayoutConstraint.constraints(withVisualFormat: "H:[leftView]-(\(leftMargin))-[label]", options: [], metrics: nil, views: ["leftView": leftView, "label": label])
            } else {
                h = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(leftMargin))-[label]", options: [], metrics: nil, views: ["label": label])
            }
            
            NSLayoutConstraint.activate(v)
            NSLayoutConstraint.activate(h)
        }
        
        layoutLabel(userInfoLabel, topView: nil, topMargin: top, leftView: nil, leftMargin: left)
        layoutLabel(videoInfoLabel, topView: userInfoLabel, topMargin: -2, leftView: nil, leftMargin: left)
        layoutLabel(audioInfoLabel, topView: videoInfoLabel, topMargin: -2, leftView: nil, leftMargin: left)
        layoutLabel(streamTypeInfoLabel, topView: videoInfoLabel, topMargin: -2, leftView: audioInfoLabel, leftMargin: 2)
        layoutLabel(audioQualityLabel, topView: audioInfoLabel, topMargin: -2, leftView: nil, leftMargin: left)
        layoutLabel(speakingLabel, topView: audioQualityLabel, topMargin: -2, leftView: nil, leftMargin: left)
    }
    
    func addViewSizeLabel() {
        let label = createInfoLabel()
        addSubview(label)
        viewSizeLabel = label
        
        let labelBottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let labelLeft = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([labelBottom, labelLeft])
    }
}

private extension AGView {
    func lowerContentCompressionResistancePriority() {
    #if os(OSX)
        setContentCompressionResistancePriority(200, for: .horizontal)
        setContentCompressionResistancePriority(200, for: .vertical)
    #endif
    }
    
    func createInfoLabel(withText text: String = " ", textColor: AGColor = AGColor.white) -> AGLabel {
        let label = AGLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        
        #if os(iOS)
            label.shadowOffset = CGSize(width: 0, height: 1)
            label.shadowColor = AGColor.black
            label.numberOfLines = 0
        #else
            let shadow = NSShadow()
            shadow.shadowOffset = NSSize(width: 0, height: 1)
            shadow.shadowColor = AGColor.black
            label.shadow = shadow
            if #available(OSX 10.11, *) {
                label.maximumNumberOfLines = 0
            }
            
            label.isEditable = false
            label.isBezeled = false
            label.drawsBackground = false
        #endif
        
        label.font = AGFont.systemFont(ofSize: 11)
        label.textColor = textColor
        
        return label
    }
}

//MARK: - DummyView
class VideoDummyView: AGView {
    private static var Pool = [VideoDummyView]()
    
    class func reuseDummy() -> VideoDummyView {
        if Pool.count > 0 {
            return Pool.removeFirst()
        } else {
            return VideoDummyView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
    
    func backToPool() {
        VideoDummyView.Pool.append(self)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        loadDefaultSets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadDefaultSets()
    }
    
    private func loadDefaultSets() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
