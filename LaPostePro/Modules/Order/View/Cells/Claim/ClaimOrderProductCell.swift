//
//  ClaimOrderProductCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 10/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol ClaimOrderProductCellDelegate {
    func updateCell(_ cell: ClaimOrderProductCell, action: Selector)
    func updateReturnOrder(_ returnOrder: ReturnOrderModel)
}

class ClaimOrderProductCell: UITableViewCell {
    // MARK: - IBOutlet
    /** First Part : Product Description
     ** description of the product
     ** always visible
     ** button to select/deselect product
    **/
    @IBOutlet weak var claimProductDetailView: UIView!
    @IBOutlet weak var claimProductReferenceLabel: UILabel!
    @IBOutlet weak var claimProductTitleLabel: UILabel!
    @IBOutlet weak var claimProductDescriptionLabel: UILabel!
    @IBOutlet weak var claimProductCheckImageView: UIImageView!
    /** Second Part : Claim Reason
     ** List of claim reasons for the product
     ** Visible when Product is Selected
     ** shows a PickerView with the list of Reasons
    **/
    @IBOutlet weak var claimReasonView: UIView!
    @IBOutlet weak var claimReasonContainerView: UIView!
    @IBOutlet weak var claimReasonLabel: UILabel!
    @IBOutlet weak var claimReasonViewHeightConstraint: NSLayoutConstraint!
    /** Third Part : Claim SubReason
     ** List of claim sub reasons for the product
     ** Visible when Product is Selected, and the selected reason has more than subReason
     ** shows a PickerView with the list of SubReasons
     **/
    @IBOutlet weak var claimSubReasonView: UIView!
    @IBOutlet weak var claimSubReasonContainerView: UIView!
    @IBOutlet weak var claimSubReasonLabel: UILabel!
    @IBOutlet weak var claimSubReasonViewHeightConstraint: NSLayoutConstraint!
    /** Fourth Part : Description text written by the client
     ** TextView for the product
     ** Visible when Product is Selected, reason and subReason (if needed) are filled
     ** textView that supports multiline (changes dynamically when typing)
     **/
    @IBOutlet weak var claimDescriptionView: UIView!
    @IBOutlet weak var claimSDescriptionContainerView: UIView!
    @IBOutlet weak var claimDescriptionTextView: UITextView!
    @IBOutlet weak var claimDescriptionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Constants
    let reasonViewHeight : CGFloat = 100
    let errorCoplor = UIColor.lpRedForUnavailableProduct
    let validColor = UIColor.lpGrey
    
    // MARK: - Variables
    var returnOrder = ReturnOrderModel()
    var delegate : ClaimOrderProductCellDelegate?
    var picker : ReturnProductPickerView?
    var isOneProduct = false

    // MARK: - private Variables
    private var state = ClaimState.deselected {
        didSet {
            delegate?.updateCell(self, action: #selector(updateCell))
        }
    }
    private enum ClaimState : Int {
        case deselected
        case reason
        case subreason
        case noSubReason
        case all
    }

    // MARK: - Cell SetData
    func setUpCell() {
        // Details
        if isOneProduct {
            returnOrder.isSelected = true
            claimProductCheckImageView.setImageColor(color: UIColor.lpGrayShadow)
            
        }
        claimDescriptionTextView.resignFirstResponder()
        claimProductReferenceLabel.text = returnOrder.refLabel
        claimProductTitleLabel.text = returnOrder.nameProduct
        claimProductDescriptionLabel.text = returnOrder.detailsProduct
        claimDescriptionTextView.text = returnOrder.description
        claimDescriptionTextView.delegate = self
        claimProductCheckImageView.isHidden = !returnOrder.isSelected
        // Selected
        if returnOrder.isSelected == false {
            state = .deselected
            return
        }
        // Check Reason
        if let reason = returnOrder.currentReason {
            // Has reason
            claimReasonContainerView.borderColor = validColor
            claimReasonLabel.text = reason.libelle ?? ""
            // check SubReason
            if let subreasons = reason.sousMotifs, subreasons.count > 1 {
                if let subReason = returnOrder.currentSubReason {
                    // Has selected subReason --> Show all Fields
                    claimSubReasonContainerView.borderColor = validColor
                    claimSubReasonLabel.text = subReason.libelle ?? ""
                    state = .all
                }
                else {
                    // Need to insert subreason
                    state = .subreason
                }
            }
            else {
                // Do not show Subreason field --> show Description
                state = .noSubReason
            }
        }
        else {
            // Need to insert Reason
            state = .reason
        }
    }
    
    func getDescriptionSize() -> CGFloat {
        let fixedWidth = UIScreen.main.bounds.width-80
        let newSize = claimDescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let height = newSize.height+70
        return (height>reasonViewHeight) ?  height : reasonViewHeight
    }
    
    @objc func getViewConstraints() -> [CGFloat] {
        switch state {
        case .deselected:
            return [0, 0, 0]
        case .reason:
            return [reasonViewHeight, 0, 0]
        case .subreason:
            return [reasonViewHeight, reasonViewHeight, 0]
        case .noSubReason:
            return [reasonViewHeight, 0, getDescriptionSize()]
        case .all:
            return [reasonViewHeight, reasonViewHeight, getDescriptionSize()]
        }
    }
    
    @objc func updateCell() {
        let constraints = getViewConstraints()
        claimReasonView.isHidden = (constraints[0] == 0)
        claimSubReasonView.isHidden = (constraints[1] == 0)
        claimDescriptionView.isHidden = (constraints[2] == 0)
        
        claimReasonViewHeightConstraint.constant = constraints[0]
        claimSubReasonViewHeightConstraint.constant = constraints[1]
        claimDescriptionViewHeightConstraint.constant = constraints[2]
    }
    
    // MARK: - @IBAction
    
    @IBAction func selectProduct() {
        hidePickerView()
        if isOneProduct {
            return
        }
        returnOrder.isSelected = !returnOrder.isSelected
        claimDescriptionTextView.resignFirstResponder()
        delegate?.updateReturnOrder(returnOrder)
        setUpCell()
    }
    
    @IBAction func getReason() {
        hidePickerView()
        if let reasons = returnOrder.reasons {
            if picker == nil {
                picker = ReturnProductPickerView()
            }
            picker?.delegate = self
            claimDescriptionTextView.resignFirstResponder()
            picker?.showReason(list: reasons, current: returnOrder.currentReason)
        }
        else {
            // GetReasons
        }
    }
    
    @IBAction func getSubReason() {
        hidePickerView()
        if let subReasons = returnOrder.currentReason?.sousMotifs {
            if picker == nil {
                picker = ReturnProductPickerView()
            }
            picker?.delegate = self
            claimDescriptionTextView.resignFirstResponder()
            picker?.showSubReason(list: subReasons, current: returnOrder.currentSubReason)
        }
        else {
            // GetReasons ??
        }
    }
    func hidePickerView() {
        if let _picker = picker {
            _picker.didCancel()
        }
    }
}

extension ClaimOrderProductCell : ReturnProductPickerViewDelegate {
    
    func didSelect(_ quantity: String) {
        // Not needed in Claim view
    }
    
    func didSelect(_ reason: ReturnProductReason) {
        claimReasonLabel.text = reason.libelle ?? ""
        returnOrder.currentSubReason = nil
        claimSubReasonLabel.text = ""
        returnOrder.currentReason = reason
        
        delegate?.updateReturnOrder(returnOrder)
        
        if let sousMotifs = reason.sousMotifs, sousMotifs.count > 1 {
            state = .subreason
        }
        else {
            state = .noSubReason
        }
    }
    
    func didSelect(_ reason: ReturnProductSubReason) {
        claimSubReasonLabel.text = reason.libelle ?? ""
        returnOrder.currentSubReason = reason
        delegate?.updateReturnOrder(returnOrder)
        state = .all
    }
    
    func didHide() {
        //
    }
}

extension ClaimOrderProductCell : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        hidePickerView()
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        if returnOrder.isSelected == false { // Check to secure case when keyboard still open when product is deselected
//            textView.resignFirstResponder()
//            return
//        }
        Logger.shared.debug("textView==========DidChange")
        returnOrder.description = textView.text ?? ""
        
        self.delegate?.updateCell(self, action: #selector(adjustTextViewHeight))
        self.delegate?.updateReturnOrder(returnOrder)
    }
    
    @objc func adjustTextViewHeight() {
        Logger.shared.debug("adjustTextView============Height")
        let descriptionConstant = getDescriptionSize()
        claimDescriptionViewHeightConstraint.constant = descriptionConstant
    }
}

private extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
