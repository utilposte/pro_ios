//
//  ReturnOrderProductCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 19/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ReturnOrderProductCellDelegate {
    func updateCell(_ cell: ReturnOrderProductCell, height: CGFloat, isHidden : Bool)
    func updateReturnOrder(_ returnOrder: ReturnOrderModel)
}

class ReturnOrderProductCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var selectedFilterView: UIView!
    // Details
    @IBOutlet weak var refLabel: UILabel!
    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var detailProductLabel: UILabel!
    // Quantity
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    // Motif
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var reasonContainerView: UIView!
    // Sous motif
    @IBOutlet weak var subReasonLabel: UILabel!
    @IBOutlet weak var subReasonContainerView: UIView!
    // Description
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionContainerView: UIView!
    @IBOutlet weak var descriptionErrorIcon: UIImageView!
    @IBOutlet weak var descriptionErrorLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionHeightLayoutConstraint: NSLayoutConstraint!
    
    let descriptionViewHeight : CGFloat = 170
    let descriptionSubReasonViewHeight : CGFloat = 50
    
    var returnOrder = ReturnOrderModel()
    var delegate : ReturnOrderProductCellDelegate?
    var picker : ReturnProductPickerView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpCell(order : ReturnOrderModel) {
        returnOrder = order
        quantityLabel.text = "\(returnOrder.quantity)"
        totalQuantityLabel.text = "x\(returnOrder.maxProducts)"
        
        refLabel.text = order.refLabel
        nameProductLabel.text = order.nameProduct
        detailProductLabel.text = order.detailsProduct
        descriptionTextField.text = order.description
        descriptionTextField.delegate = self
        
        if returnOrder.isSelected {
            checkImageView.isHidden = false
            selectedFilterView.isHidden = true
            descriptionHeightLayoutConstraint.constant = getDescriptionHeight()
            descriptionView.isHidden = false
            
            if let reason = returnOrder.currentReason {
                reasonLabel.text = reason.libelle?.capitalized
                if let subreasons = reason.sousMotifs, subreasons.count > 1 {
                    subReasonContainerView.isHidden = false
                    if let subreason = returnOrder.currentSubReason {
                        subReasonLabel.text = subreason.libelle?.capitalized
                    }
                }
                else {
                    subReasonContainerView.isHidden = true
                }
            }
            
        }
        else {
            checkImageView.isHidden = true
            selectedFilterView.isHidden = false
            descriptionHeightLayoutConstraint.constant = 0
            descriptionView.isHidden = true
        }
        updateCellWithError()
        
    }
    func getDescriptionHeight() -> CGFloat{
        var height : CGFloat = 0
        if returnOrder.isSelected {
            height = descriptionViewHeight
            if let reason = returnOrder.currentReason, let subReason = reason.sousMotifs, subReason.count > 1 {
                height = descriptionViewHeight + descriptionSubReasonViewHeight
            }
        }
        return height
    }
    
    func updateCellWithError() {
        descriptionContainerView.borderWidth = 0
        reasonContainerView.borderWidth = 0
        subReasonContainerView.borderWidth = 0
        descriptionErrorIcon.isHidden = true
        descriptionErrorLabel.isHidden = true
        
        var resultError = false
        for error in returnOrder.errorType {
            
            switch error {
            case .reason:
                reasonContainerView.borderWidth = 1
                resultError = true
            case .description:
                descriptionContainerView.borderWidth = 1
                descriptionErrorIcon.isHidden = false
                resultError = true
            case .subReason:
                subReasonContainerView.borderWidth = 1
                resultError = true
            }
        }
        descriptionErrorLabel.isHidden = !resultError
    }
    
    func validate() -> (ReturnOrderModel?, Bool) {
        var error = 0
        returnOrder.errorType = [ReturnOrderModel.ErrorType]()
        if returnOrder.isSelected && returnOrder.quantity > 0 {
            returnOrder.returnedQuantity = "\(returnOrder.quantity)"
            // Error
            if descriptionTextField.text?.isEmpty == true {
                returnOrder.errorType.append(.description)
                error = error+1
            }
            else {
                returnOrder.description = descriptionTextField.text ?? ""
            }
            
            if let reason = returnOrder.currentReason {
                // check sub Reason
                if let subReasons = reason.sousMotifs {
                    // Check number Of subReasons
                    if subReasons.count == 1 {
                        //
                        let subReason = subReasons[0]
                        returnOrder.source  = reason.codeSource ?? ""
                        returnOrder.famille = subReason.famille ?? ""
                        returnOrder.motif   = subReason.codeMotifScore ?? ""
                        returnOrder.produit = reason.codeProduitScore ?? ""
                    }
                    else if subReasons.count > 1 {
                        //
                        if let subReason = returnOrder.currentSubReason {
                            returnOrder.source  = reason.codeSource ?? ""
                            returnOrder.famille = subReason.famille ?? ""
                            returnOrder.motif   = subReason.codeMotifScore ?? ""
                            returnOrder.produit = reason.codeProduitScore ?? ""
                        }
                        else {
                            returnOrder.errorType.append(.subReason)
                        }
                    }
                    else {
                        // Problem withSubreason :: put reason for sucrity (Shoud never enter this closure)
                        returnOrder.source = reason.codeSource ?? ""
                        returnOrder.famille = reason.famille ?? ""
                        returnOrder.motif = reason.codeMotifScore ?? ""
                        returnOrder.produit = reason.codeProduitScore ?? ""
                    }
                }
                else {
                    // No SubReason
                    returnOrder.source = reason.codeSource ?? ""
                    returnOrder.famille = reason.famille ?? ""
                    returnOrder.motif = reason.codeMotifScore ?? ""
                    returnOrder.produit = reason.codeProduitScore ?? ""
                }
            }
            else {
                returnOrder.errorType.append(.reason)
            }
        }
        else {
            delegate?.updateReturnOrder(returnOrder)
            return (nil, false)
        }
        updateCellWithError()
        if returnOrder.errorType.count == 0 {
            delegate?.updateReturnOrder(returnOrder)
            return (returnOrder, false)
        }
        else {
            delegate?.updateReturnOrder(returnOrder)
            return (nil, true)
        }
    }
    
    // MARK: - IBAction
    @IBAction func selectReason() {
        hidePickerView()
        if let reasons = returnOrder.reasons {
            if picker == nil {
                picker = ReturnProductPickerView()
            }
            picker?.delegate = self
            descriptionTextField.resignFirstResponder()
            picker?.showReason(list: reasons, current: returnOrder.currentReason)
        }
        else {
            // GetReasons
        }
    }
    
    // MARK: - IBAction
    @IBAction func selectSubReason() {
        hidePickerView()
        if let subReasons = returnOrder.currentReason?.sousMotifs {
            if picker == nil {
                picker = ReturnProductPickerView()
            }
            picker?.delegate = self
            descriptionTextField.resignFirstResponder()
            picker?.showSubReason(list: subReasons, current: returnOrder.currentSubReason)
        }
        else {
            // GetReasons
        }
    }
    
    @IBAction func activateProduct() {
        hidePickerView()
        returnOrder.isSelected = !returnOrder.isSelected
        if returnOrder.isSelected {
            checkImageView.isHidden = false
            selectedFilterView.isHidden = true
            if returnOrder.quantity > 0 {
                delegate?.updateCell(self, height: getDescriptionHeight(), isHidden: false)
                descriptionView.isHidden = false
            }
        }
        else {
            checkImageView.isHidden = true
            selectedFilterView.isHidden = false
            delegate?.updateCell(self, height: 0, isHidden: true)
            descriptionView.isHidden = true
            
        }
    }
    
    @IBAction func chooseQuantityClicked() {
        hidePickerView()
        if picker == nil {
            picker = ReturnProductPickerView()
        }
        picker?.delegate = self
        descriptionTextField.resignFirstResponder()
        picker?.showQuantity(max: returnOrder.maxProducts, current: returnOrder.quantity)
    }
    
    @IBAction func addProduct() {
        hidePickerView()
        if returnOrder.quantity == returnOrder.maxProducts {
            return
        }
        returnOrder.quantity = returnOrder.quantity+1
        delegate?.updateReturnOrder(returnOrder)
        quantityLabel.text = "\(returnOrder.quantity)"
        if returnOrder.quantity == 1 {
            delegate?.updateCell(self, height: getDescriptionHeight(), isHidden: false)
            descriptionView.isHidden = false
        }
    }
    
    @IBAction func removeProduct(_ sender: Any) {
        hidePickerView()
        if returnOrder.quantity == 1 {
            return
        }
        returnOrder.quantity = returnOrder.quantity-1
        delegate?.updateReturnOrder(returnOrder)
        quantityLabel.text = "\(returnOrder.quantity)"
        if returnOrder.quantity == 1 {
//            delegate?.updateCell(self, height: 0, isHidden: true)
//            descriptionView.isHidden = true
        }
    }
    
    func hidePickerView() {
        if let _picker = picker {
            _picker.didCancel()
        }
    }
}

extension ReturnOrderProductCell : ReturnProductPickerViewDelegate {
    
    
    func didSelect(_ quantity: String) {
        quantityLabel.text = quantity
        if let result = Int(quantity) {
            if returnOrder.quantity == 0 {
                delegate?.updateCell(self, height: getDescriptionHeight(), isHidden: false)
                subReasonContainerView.isHidden = false
            }
            else {
                returnOrder.quantity = result
                delegate?.updateReturnOrder(returnOrder)
            }
        }
    }
    
    func didSelect(_ reason: ReturnProductReason) {
        reasonLabel.text = reason.libelle?.capitalized
        returnOrder.currentSubReason = nil
        subReasonLabel.text = ""
        subReasonContainerView.isHidden = true
        returnOrder.currentReason = reason
        
        delegate?.updateReturnOrder(returnOrder)
        if let sousMotifs = reason.sousMotifs, sousMotifs.count > 1 {
            delegate?.updateCell(self, height: getDescriptionHeight(), isHidden: false)
            subReasonContainerView.isHidden = false
        }
    }
    
    func didSelect(_ reason: ReturnProductSubReason) {
        subReasonLabel.text = reason.libelle?.capitalized
        returnOrder.currentSubReason = reason
        delegate?.updateReturnOrder(returnOrder)
    }
    
    func didHide() {
        //
    }
}

extension ReturnOrderProductCell : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if returnOrder.errorType.contains(.description) {
            descriptionContainerView.borderWidth = 0
            descriptionErrorIcon.isHidden = true
            if returnOrder.errorType.isEmpty {
                descriptionErrorLabel.isHidden = true
            }
            else {
                var i = 0
                for error in returnOrder.errorType {
                    if error == .description {
                        returnOrder.errorType.remove(at: i)
                    }
                    i += 1
                }
            }
            delegate?.updateReturnOrder(returnOrder)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.isEmpty && !returnOrder.errorType.contains(.description) {
                returnOrder.errorType.append(.description)
                descriptionContainerView.borderWidth = 1
                descriptionErrorIcon.isHidden = false
                descriptionErrorLabel.isHidden = false
            }
            returnOrder.description = text
        }
        else if !returnOrder.errorType.contains(.description) {
            returnOrder.errorType.append(.description)
            descriptionContainerView.borderWidth = 1
            descriptionErrorIcon.isHidden = false
            descriptionErrorLabel.isHidden = false
        }
        delegate?.updateReturnOrder(returnOrder)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
