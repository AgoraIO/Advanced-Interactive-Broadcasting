//
//  TypeAlias.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 4/11/16.
//  Copyright © 2016 Agora. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Cocoa
#endif

#if os(iOS)
    public typealias AGView = UIView
    public typealias AGColor = UIColor
    public typealias AGImageView = UIImageView
    public typealias AGIndicator = UIActivityIndicatorView
    
    typealias AGFont = UIFont
    typealias AGImage = UIImage
    typealias AGLabel = UILabel
    typealias AGScrollView = UIScrollView
    
#else
    public typealias AGView = NSView
    public typealias AGColor = NSColor
    public typealias AGImageView = NSImageView
    public typealias AGIndicator = NSProgressIndicator
    
    typealias AGFont = NSFont
    typealias AGImage = NSImage
    typealias AGLabel = NSTextField
    typealias AGScrollView = NSScrollView
    
#endif
