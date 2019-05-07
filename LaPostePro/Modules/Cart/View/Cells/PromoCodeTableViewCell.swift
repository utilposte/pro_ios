//
//  PromoCodeTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol PromoCodeTableViewCellDelegate: class {
    func didTappedPromoCodeButton(cell: PromoCodeTableViewCell)
    func didTappedPromoCodeApplyButton(cell: PromoCodeTableViewCell)
}

class PromoCodeTableViewCell: UITableViewCell {

    // MARK: Properties
    weak var delegate: PromoCodeTableViewCellDelegate?
    @IBOutlet weak var promoCodeViewHeightConstraint: NSLayoutConstraint!

    // MARK: IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var promoCodeBenefitsLabel: UILabel!
    @IBOutlet weak var promoCodeTypeButton: UIButton!
    @IBOutlet weak var promoCodeView: UIView!
    @IBOutlet weak var promoCodeTextField: UITextField!
    @IBOutlet weak var promoCodeApplyButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.addRadius(value: 5, color: UIColor.lightGray.cgColor, width: 1)
        self.promoCodeView.layer.cornerRadius = 5

        self.promoCodeTypeButton.setTitleColor(.white, for: .normal)
        self.promoCodeBenefitsLabel.attributedText = NSMutableAttributedString.init()
            .custom("Je bénéficie d'un ", font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
            .custom("code de réduction ?", font: UIFont.boldSystemFont(ofSize: 15), color: .lpPurple)
        self.setupPromoCodeTypeButton()
        self.setupPromoCodeApplyButton()
        self.setupPromoCodeTextField()
    }

    func setupPromoCodeTypeButton() {
        self.promoCodeTypeButton.addRadius(value: self.promoCodeTypeButton.frame.height / 2)
        self.promoCodeTypeButton.backgroundColor = .lpPurple
        self.promoCodeTypeButton.setTitle("Saisir", for: .normal)
        self.promoCodeTypeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }

    func setupPromoCodeTextField() {
        self.promoCodeTextField.isHidden = true
        self.promoCodeTextField.autocapitalizationType = .allCharacters
        self.promoCodeTextField.autocorrectionType = .no
    }

    func setupPromoCodeApplyButton() {
        self.promoCodeApplyButton.setTitleColor(.lpPurple, for: .normal)
        self.promoCodeApplyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.promoCodeApplyButton.isHidden = true
    }

    internal func configurePromoCodeCell(expanded: Bool) {
        
        if expanded {
            self.promoCodeApplyButton.isHidden = false
            self.promoCodeTextField.isHidden = false
            self.promoCodeTypeButton.isHidden = true
            self.promoCodeBenefitsLabel.font = UIFont.boldSystemFont(ofSize: 15)
            self.promoCodeBenefitsLabel.text = "Mon code de réduction"
            self.promoCodeViewHeightConstraint.constant = 45
            self.layoutIfNeeded()
            self.promoCodeTextField.text = CartViewModel.sharedInstance.activeVoucher ?? ""
            self.updateCell()
        }
        else {
            self.promoCodeViewHeightConstraint.constant = 0
            self.layoutIfNeeded()
            self.promoCodeApplyButton.isHidden = true
            self.promoCodeTextField.isHidden = true
        }
    }
    
    func updateCell() {
        if CartViewModel.sharedInstance.activeVoucher != nil {
            self.promoCodeApplyButton.setTitle("Supprimer", for: .normal)
            self.promoCodeTextField.isEnabled = false
        }
        else {
            self.promoCodeApplyButton.setTitle("Appliquer", for: .normal)
            self.promoCodeTextField.isEnabled = true
        }
    }

    @IBAction func promoCodeButtonTapped(_ sender: Any) {
        self.delegate?.didTappedPromoCodeButton(cell: self)
    }

    @IBAction func promoCodeApplyButtonTapped(_ sender: Any) {
        self.delegate?.didTappedPromoCodeApplyButton(cell: self)
    }
}
