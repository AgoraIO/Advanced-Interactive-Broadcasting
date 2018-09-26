//
//  CustomParameterViewController.swift
//  AgoraPremium
//
//  Created by GongYuhua on 2017/2/28.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit

protocol CustomParameterVCDelegate: NSObjectProtocol {
    func customParameterVCDidChanged(_ customParameterVC: CustomParameterViewController, changed: CustomParameter?)
}

class CustomParameterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var customParameters: CustomParameters!
    var canDeleteParameter = false
    weak var delegate: CustomParameterVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: 300, height: 418)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        addButton?.isHidden = canDeleteParameter
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    @IBAction func doVOSServerPressed(_ sender: UIButton) {
//        let vosParameter = customParameters.addParameter("rtc.vos_list", value: "[\"58.211.82.170\"]")
        let vocsParameter = customParameters.addParameter("rtc.signal_debug", value: "{\"lbss\":\"lbss\", \"host\":\"125.88.159.176\"}")
        tableView.reloadData()
//        delegate?.customParameterVCDidChanged(self, changed: vosParameter)
        delegate?.customParameterVCDidChanged(self, changed: vocsParameter)
    }
    
    @IBAction func doAddPressed(_ sender: Any) {
        alertForAddParameter()
    }
}

private extension CustomParameterViewController {
    func alertForAddParameter() {
        let alert = UIAlertController(title: "Add custom parameter", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = CustomParameter.placeholderOfKey
        }
        alert.addTextField { (textField) in
            textField.placeholder = CustomParameter.placeholderOfValue
        }
        
        let ok = UIAlertAction(title: "Add", style: .default) { [unowned self] _ in
            if let textFileds = alert.textFields, textFileds.count == 2,
                let key = textFileds.first?.text, !key.isEmpty,
                let value = textFileds.last?.text, !value.isEmpty {
                
                let parameter = self.customParameters.addParameter(key, value: value)
                self.tableView.reloadData()
                
                self.delegate?.customParameterVCDidChanged(self, changed: parameter)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func alert(forEdit parameter: CustomParameter) {
        let alert = UIAlertController(title: "Edit custom parameter", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = CustomParameter.placeholderOfKey
            textField.text = parameter.key
        }
        alert.addTextField { (textField) in
            textField.placeholder = CustomParameter.placeholderOfValue
            textField.text = parameter.value
        }
        
        let ok = UIAlertAction(title: "Ok", style: .default) { [unowned self] _ in
            if let textFileds = alert.textFields, textFileds.count == 2,
                let key = textFileds.first?.text, key != "",
                let value = textFileds.last?.text, value != "" {
                
                parameter.key = key
                parameter.value = value
                self.tableView.reloadData()
                
                self.delegate?.customParameterVCDidChanged(self, changed: parameter)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension CustomParameterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customParameters.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setPrivateParameterCell", for: indexPath) as! CustomParameterCell
        cell.update(with: customParameters.list[indexPath.row])
        return cell
    }
}

extension CustomParameterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canDeleteParameter
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if canDeleteParameter {
            alert(forEdit: customParameters.list[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {[unowned self] (_, indexPath) in
            _ = self.customParameters.removeParameter(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            
            self.delegate?.customParameterVCDidChanged(self, changed: nil)
        }
        
        return [delete]
    }
}
