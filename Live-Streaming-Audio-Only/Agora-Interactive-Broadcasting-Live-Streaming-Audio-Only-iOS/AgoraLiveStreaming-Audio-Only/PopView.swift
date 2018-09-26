//
//  PopView.swift
//  Agora-Online-PK
//
//  Created by ZhangJi on 2018/6/5.
//  Copyright © 2018 CavanSu. All rights reserved.
//

import UIKit

@objc protocol PopViewDelegate: NSObjectProtocol {
    func popViewButtonDidPressed(_ popView: PopView)
    
    @objc optional func popViewDidRemoved(_ popView: PopView)
}

class PopView: UIView {
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var popViewButton: UIButton!
    
    weak var delegate: PopViewDelegate?
    
    static func newPopViewWith(buttonTitle: String, placeholder: String) -> PopView? {
        let nibView = Bundle.main.loadNibNamed("PopView", owner: nil, options: nil)
        if let view = nibView?.first as? PopView {
            let attDic = NSMutableDictionary()
            attDic[NSAttributedStringKey.foregroundColor] = UIColor.lightGray
            let attPlaceholder = NSAttributedString(string: placeholder, attributes: attDic as? [NSAttributedStringKey : Any])
            view.inputTextField.attributedPlaceholder = attPlaceholder
            view.popViewButton.setTitle(buttonTitle, for: .normal)
            return view
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func doCancelButton(_ sender: UIButton) {
        if delegate != nil {
            delegate?.popViewDidRemoved?(self)
        }
        self.removeFromSuperview()
    }
    
    @IBAction func doPopViewButtonPressed(_ sender: UIButton) {
        if delegate != nil {
            delegate?.popViewButtonDidPressed(self)
        }
    }
}
