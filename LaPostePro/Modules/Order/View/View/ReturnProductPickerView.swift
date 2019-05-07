//
//  ReturnProductPickerView.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 20/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ReturnProductPickerViewDelegate {
    func didSelect(_ quantity : String)
    func didSelect(_ reason : ReturnProductReason)
    func didSelect(_ reason : ReturnProductSubReason)
    func didHide()
}

private enum ReturnProductPickerType : Int {
    case quantity
    case reason
    case subReason
}

class ReturnProductPickerView: NSObject {
    
    private var listQuantity    = [String]()
    private var listReason      = [ReturnProductReason]()
    private var listSubReason   = [ReturnProductSubReason]()
    private var type = ReturnProductPickerType.quantity
    private var containerView : UIView
    private var pickerView    : UIPickerView
    
    var delegate : ReturnProductPickerViewDelegate?
    
    override init() {
        let screenSize = UIScreen.main.bounds
        containerView = UIView(frame: CGRect(x: 0, y:Int(screenSize.height-240) , width: Int(screenSize.width), height: 240))
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 40, width: Int(screenSize.width), height: 200))
        
        super.init()
        containerView.backgroundColor = UIColor.white
        pickerView.delegate = self
        let barView = UIView(frame: CGRect(x: 0, y: 0, width: Int(screenSize.width), height: 40))
        barView.backgroundColor = UIColor.groupTableViewBackground
        let validateButton = UIButton(frame: CGRect(x: Int(screenSize.width-80), y: 0, width: 60, height: 40))
        validateButton.setTitle("Valider", for: .normal)
        validateButton.setTitleColor(UIColor.lpPurple, for: .normal)
        validateButton.addTarget(self, action: #selector(ReturnProductPickerView.didValidateChoice), for: UIControlEvents.touchUpInside)
        
        let cancelButton = UIButton(frame: CGRect(x: 20, y: 0, width: 80, height: 40))
        cancelButton.setTitle("Annuler", for: .normal)
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.addTarget(self, action: #selector(ReturnProductPickerView.didCancel), for: UIControlEvents.touchUpInside)
        
        
        barView.addSubview(validateButton)
        barView.addSubview(cancelButton)
        containerView.addSubview(barView)
        containerView.addSubview(pickerView)
    }
    
    private func showView() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(containerView)
            window.bringSubview(toFront: containerView)
        }
    }
    
    func showQuantity(max : Int, current: Int) {
        type = ReturnProductPickerType.quantity
        var list = [String]()
        for i in 1...max {
            list.append("\(i)")
        }
        listQuantity = list
        pickerView.reloadAllComponents()
        if current > 0 {
            pickerView.selectRow(current-1, inComponent: 0, animated: false)
        }
        showView()
    }
    
    func showReason(list : [ReturnProductReason], current : ReturnProductReason?) {
        type = ReturnProductPickerType.reason
        listReason = list
        pickerView.reloadAllComponents()
        if let currentReason = current {
            var i = 0
            for reason in list {
                if reason.code == currentReason.code {
                    pickerView.selectRow(i, inComponent: 0, animated: false)
                    break
                }
                i += 1
            }
        }
        showView()
    }
    
    func showSubReason(list : [ReturnProductSubReason], current : ReturnProductSubReason?) {
        type = ReturnProductPickerType.subReason
        listSubReason = list
        pickerView.reloadAllComponents()
        if let currentReason = current {
            var i = 0
            for reason in list {
                if reason.code == currentReason.code {
                    pickerView.selectRow(i, inComponent: 0, animated: false)
                    break
                }
                i += 1
            }
        }
        showView()
    }

    @objc private func didValidateChoice() {
        let selectIndex = pickerView.selectedRow(inComponent: 0)
        switch type {
        case .quantity:
            let quantity = listQuantity[selectIndex]
            delegate?.didSelect(quantity)
            
        case .reason:
            let reason = listReason[selectIndex]
            delegate?.didSelect(reason)
        case .subReason:
            let subReason = listSubReason[selectIndex]
            delegate?.didSelect(subReason)
        }
        didCancel()
    }
    
    @objc func didCancel() {
        self.containerView.removeFromSuperview()
        delegate?.didHide()
    }
}


extension ReturnProductPickerView : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .quantity:
            return listQuantity.count
        case .reason:
            return listReason.count
        case .subReason:
            return listSubReason.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type {
        case .quantity:
            return listQuantity[row]
        case .reason:
            return listReason[row].libelle
        case .subReason:
            return listSubReason[row].libelle
        }
    }
}
