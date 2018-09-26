//
//  CustomParameterCell.swift
//  AgoraPremium
//
//  Created by GongYuhua on 2017/2/28.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

class CustomParameterCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var warningLabelHeight: NSLayoutConstraint!
    
    func update(with parameter: CustomParameter) {
        label.text = parameter.jsonString()
        warningLabelHeight.constant = parameter.isValid() ? 0 : 22
    }
}
