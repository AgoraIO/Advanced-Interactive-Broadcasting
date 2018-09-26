//
//  VideoViewLayouter.swift
//  AgoraStreaming
//
//  Created by GongYuhua on 3/24/16.
//  Copyright © 2016 Agora. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Cocoa
#endif

class VideoViewLayouter {
    
    var containerView: AGView?
    var sessions = [VideoSession]()
    var fullSession: VideoSession?
    var isForceFullView = false
    var targetSize = CGSize.zero
    
    fileprivate var layoutConstraints = [NSLayoutConstraint]()
    fileprivate var dummyViews = [VideoDummyView]()
}

extension VideoViewLayouter {
    func layoutVideoViews() -> [VideoSession] {
        var actualFullSessions = [VideoSession]()
        
        guard let containerView = containerView else {
            return actualFullSessions
        }
        
        clearConstraints()
        
        for session in sessions {
            session.hostingView.removeFromSuperview()
        }
        clearDummyViews()
        
        let sessionsCount = sessions.count
        if sessionsCount == 0 {
            
        } else if sessionsCount == 1 {
            //full screen for one person
            actualFullSessions = sessions
            
            let view = sessions.first!.hostingView!
            containerView.addSubview(view)
            layoutConstraints.append(contentsOf: layout(fullView: view))
            
        } else if fullSession != nil && isForceFullView {
            //force full screen
            actualFullSessions = [fullSession!]
            
            let view = fullSession!.hostingView!
            containerView.addSubview(view)
            layoutConstraints.append(contentsOf: layout(fullView: view))
            
        } else if sessionsCount == 2 && fullSession == nil {
            //divide the screen into two havles
            actualFullSessions = sessions
            
            let view1 = sessions.first!.hostingView!
            let view2 = sessions.last!.hostingView!
            containerView.addSubview(view1)
            containerView.addSubview(view2)
            
            if targetSize.width >= targetSize.height {
                let constraintsH1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view1]|", options: [], metrics: nil, views: ["view1": view1])
                let constraintsH2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view2]|", options: [], metrics: nil, views: ["view2": view2])
                let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view2]-1-[view1]|", options: [], metrics: nil, views: ["view1": view1, "view2": view2])
                let constraintsWidth = NSLayoutConstraint(item: view2, attribute: .width, relatedBy: .equal, toItem: view1, attribute: .width, multiplier: 1, constant: 0)
                layoutConstraints.append(contentsOf: constraintsH1)
                layoutConstraints.append(contentsOf: constraintsH2)
                layoutConstraints.append(contentsOf: constraintsV)
                layoutConstraints.append(constraintsWidth)
            } else {
                let constraintsH1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view1]|", options: [], metrics: nil, views: ["view1": view1])
                let constraintsH2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view2]|", options: [], metrics: nil, views: ["view2": view2])
                let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view2]-1-[view1]|", options: [], metrics: nil, views: ["view1": view1, "view2": view2])
                let constraintsHeight = NSLayoutConstraint(item: view2, attribute: .height, relatedBy: .equal, toItem: view1, attribute: .height, multiplier: 1, constant: 0)
                layoutConstraints.append(contentsOf: constraintsH1)
                layoutConstraints.append(contentsOf: constraintsH2)
                layoutConstraints.append(contentsOf: constraintsV)
                layoutConstraints.append(constraintsHeight)
            }
            
        } else if sessionsCount <= 4 && fullSession == nil {
            //divide the screen into four equal parts
            actualFullSessions = sessions
            var views = sessions.map({ (session) -> AGView in
                return session.hostingView
            })
            setSmallViews(&views, maxTo: 4)
            
            let view1 = views[0]
            let view2 = views[1]
            let view3 = views[2]
            let view4 = views[3]
            containerView.addSubview(view1)
            containerView.addSubview(view2)
            containerView.addSubview(view3)
            containerView.addSubview(view4)
            
            let constraintsH1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view1]-1-[view2]|", options: [], metrics: nil, views: ["view1": view1, "view2": view2])
            let constraintsH2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view3]-1-[view4]|", options: [], metrics: nil, views: ["view3": view3, "view4": view4])
            let constraintsV1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view1]-1-[view3]|", options: [], metrics: nil, views: ["view1": view1, "view3": view3])
            let constraintsV2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view2]-1-[view4]|", options: [], metrics: nil, views: ["view2": view2, "view4": view4])
            let constraintsWidth1 = NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: view2, attribute: .width, multiplier: 1, constant: 0)
            let constraintsWidth2 = NSLayoutConstraint(item: view3, attribute: .width, relatedBy: .equal, toItem: view4, attribute: .width, multiplier: 1, constant: 0)
            let constraintsHeight1 = NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: view3, attribute: .height, multiplier: 1, constant: 0)
            let constraintsHeight2 = NSLayoutConstraint(item: view2, attribute: .height, relatedBy: .equal, toItem: view4, attribute: .height, multiplier: 1, constant: 0)
            layoutConstraints.append(contentsOf: constraintsH1)
            layoutConstraints.append(contentsOf: constraintsH2)
            layoutConstraints.append(contentsOf: constraintsV1)
            layoutConstraints.append(contentsOf: constraintsV2)
            layoutConstraints.append(constraintsWidth1)
            layoutConstraints.append(constraintsWidth2)
            layoutConstraints.append(constraintsHeight1)
            layoutConstraints.append(constraintsHeight2)
            
        } else {
            //one big view, some small views
            let fullView: AGView
            var smallViews = [AGView]()
            
            if let fullSession = fullSession {
                fullView = fullSession.hostingView!
                actualFullSessions = [fullSession]
                
                for session in sessions {
                    if session != fullSession {
                        smallViews.append(session.hostingView)
                    }
                }
            } else {
                fullView = sessions.first!.hostingView!
                actualFullSessions = [sessions.first!]
                
                for (index, session) in sessions.enumerated() {
                    if index != 0 {
                        smallViews.append(session.hostingView)
                    }
                }
            }
            
            let edgePosition: EdgePosition = (targetSize.width >= targetSize.height ? .right : .bottom)
            
            //maximum width for small view
        #if os(iOS)
            let MaxSmallViewWidth: CGFloat = 150
        #else
            let MaxSmallViewWidth: CGFloat = 220
        #endif
            //minimum width to height ratio of large view
            let MinLargeViewRatio: CGFloat = (targetSize.width / targetSize.height >= 0.667 || targetSize.width / targetSize.height <= 1.5) ? 0.75 : 1
            
            //count the number of small view in a row
            var MaxPosibleCountPerLine = smallViews.count
            let largerSide: CGFloat
            let smallerSide: CGFloat
            if targetSize.width >= targetSize.height {
                largerSide = targetSize.width
                smallerSide = targetSize.height
            } else {
                largerSide = targetSize.height
                smallerSide = targetSize.width
            }
            MaxPosibleCountPerLine = max(MaxPosibleCountPerLine, Int(ceil(largerSide / MaxSmallViewWidth)))
            MaxPosibleCountPerLine = max(MaxPosibleCountPerLine, Int(ceil(smallerSide / (largerSide - smallerSide * MinLargeViewRatio))))
            
            var countPerLine = 1
            var lines = 1
            for count in 1..<(MaxPosibleCountPerLine+1) {
                countPerLine = count
                
                let smallWidth = smallerSide / CGFloat(count)
                if smallWidth > MaxSmallViewWidth {
                    continue
                }
                lines = Int(ceil(Double(smallViews.count) / Double(count)))
                if (largerSide - smallWidth * CGFloat(lines)) / smallerSide < MinLargeViewRatio {
                    continue
                }
                
                break
            }
            
            //start layout
            containerView.addSubview(fullView)
            setSmallViews(&smallViews, maxTo: (countPerLine * lines))
            for view in smallViews {
                containerView.addSubview(view)
            }
            
            layoutConstraints.append(contentsOf: layouts(ofSmallViews: smallViews, fullView: fullView, countPerLine: countPerLine, edgePosition: edgePosition))
                
        }
        
        if !layoutConstraints.isEmpty {
            NSLayoutConstraint.activate(layoutConstraints)
        }
        
        return actualFullSessions
    }
    
#if os(iOS)
    func responseSession(of gesture: UIGestureRecognizer) -> VideoSession? {
        guard let containerView = containerView else {
            return nil
        }
        
        let location = gesture.location(in: containerView)
        for session in sessions {
            if let view = session.hostingView , view.frame.contains(location) {
                return session
            }
        }
        
        return nil
    }
#else
    func responseSession(of event: NSEvent) -> VideoSession? {
        guard let _ = containerView else {
            return nil
        }

        let location = event.locationInWindow
        for session in sessions {
            if let view = session.hostingView , view.frame.contains(location) {
            return session
            }
        }

        return nil
    }
#endif
}

private enum EdgePosition {
    case bottom, right
}

private extension VideoViewLayouter {
    func setSmallViews(_ smallViews: inout [AGView], maxTo count: Int) {
        while smallViews.count < count {
            let dummyView = VideoDummyView.reuseDummy()
            smallViews.append(dummyView)
            dummyViews.append(dummyView)
        }
    }
    
    func layout(fullView: AGView) -> [NSLayoutConstraint] {
        var layoutConstraints = [NSLayoutConstraint]()
        
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": fullView])
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": fullView])
        layoutConstraints.append(contentsOf: constraintsH)
        layoutConstraints.append(contentsOf: constraintsV)
        
        return layoutConstraints
    }
    
    func layouts(ofSmallViews smallViews: [AGView], fullView: AGView, countPerLine: Int, edgePosition: EdgePosition) -> [NSLayoutConstraint] {
        
        var layoutConstraints = [NSLayoutConstraint]()
        
        //number of rows
        let smallViewLineCounts: Int
        if countPerLine > 0 {
            smallViewLineCounts = Int(ceil(Double(smallViews.count) / Double(countPerLine)))
        } else {
            smallViewLineCounts = 0
        }
        
        for view in smallViews {
            let squar = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
            layoutConstraints.append(squar)
        }
        
        //large view
        let constraintsFullViewA: [NSLayoutConstraint]
        switch edgePosition {
        case .bottom:
            constraintsFullViewA = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": fullView])
        case .right:
            constraintsFullViewA = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": fullView])
        }
        layoutConstraints.append(contentsOf: constraintsFullViewA)
        
        var constraintsFullViewBString: String
        switch edgePosition {
        case .bottom:   constraintsFullViewBString = "V:|[view]"
        case .right:    constraintsFullViewBString = "H:|[view]"
        }
        
        var constraintsFullViewBViewDic = ["view": fullView]
        for lineNumber in 0..<smallViewLineCounts {
            let viewKey = "view\(lineNumber)"
            constraintsFullViewBString.append("-1-[\(viewKey)]")
            constraintsFullViewBViewDic[viewKey] = smallViews[lineNumber * countPerLine]
        }
        constraintsFullViewBString.append("|")
        
        let constraintsFullViewB = NSLayoutConstraint.constraints(withVisualFormat: constraintsFullViewBString, options: [], metrics: nil, views: constraintsFullViewBViewDic)
        layoutConstraints.append(contentsOf: constraintsFullViewB)
        
        //small views
        for lineNumber in 0..<smallViewLineCounts {
            
            let rulerIndex = lineNumber * countPerLine
            let rulerView = smallViews[rulerIndex]
            
            var constraintsSmallViewString: String
            switch edgePosition {
            case .bottom:   constraintsSmallViewString = "H:|[view]"
            case .right:    constraintsSmallViewString = "V:|[view]"
            }
            
            var constraintsSmallViewDic = ["view": smallViews[rulerIndex]]
            
            for index in (rulerIndex + 1)..<(rulerIndex + countPerLine) {
                if index >= smallViews.count {
                    break
                }
                
                let view = smallViews[index]
                
                let equalSize: NSLayoutConstraint
                let equalSide: NSLayoutConstraint
                switch edgePosition {
                case .bottom:
                    equalSize = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: rulerView, attribute: .width, multiplier: 1, constant: 0)
                    equalSide = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: rulerView, attribute: .bottom, multiplier: 1, constant: 0)
                default:
                    equalSize = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: rulerView, attribute: .height, multiplier: 1, constant: 0)
                    equalSide = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: rulerView, attribute: .trailing, multiplier: 1, constant: 0)
                }
                layoutConstraints.append(equalSize)
                layoutConstraints.append(equalSide)
                
                let viewKey = "view\(index)"
                constraintsSmallViewString.append("-1-[\(viewKey)]")
                constraintsSmallViewDic[viewKey] = smallViews[index]
            }
            
            constraintsSmallViewString.append("|")
            let constraintsSmallViewV = NSLayoutConstraint.constraints(withVisualFormat: constraintsSmallViewString, options: [], metrics: nil, views: constraintsSmallViewDic)
            layoutConstraints.append(contentsOf: constraintsSmallViewV)
        }
        
        return layoutConstraints
    }
    
    func clearDummyViews() {
        for view in dummyViews {
            view.removeFromSuperview()
            view.backToPool()
        }
        dummyViews.removeAll()
    }
    
    func clearConstraints() {
        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints.removeAll()
    }
}
