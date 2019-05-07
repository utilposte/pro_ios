//
//  InscriptionFormFooter.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 11/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import ActiveLabel

protocol inscriptionFormFooterDelegate {
    func displayOptionalAddressField(hide: Bool)
}

class InscriptionFormFooter: UIView {
    //MARK: PROPRETIES
    var delegate: inscriptionFormFooterDelegate?
    let viewModel = CompanyInformationViewModel()
    var cguChecked = false
    var hideOptionalsFields = true
    
    //OUTLETS
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var displayOptionalsFieldLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayOptionalsFieldsLabelClicked))
        displayOptionalsFieldLabel.isUserInteractionEnabled = true
        displayOptionalsFieldLabel.addGestureRecognizer(tapGesture)
        displayOptionalsFieldLabel.attributedText = viewModel.getTextForDisplayOptionalFieldLabel(display: hideOptionalsFields)
    }

    @objc func displayOptionalsFieldsLabelClicked() {
        hideOptionalsFields = !hideOptionalsFields
        displayOptionalsFieldLabel.attributedText = viewModel.getTextForDisplayOptionalFieldLabel(display: hideOptionalsFields)
        if delegate != nil {
            delegate?.displayOptionalAddressField(hide: hideOptionalsFields)
        }
    }
    
}
