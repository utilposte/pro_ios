//
//  CartTotalPriceTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 27/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

protocol CartTotalPriceTableViewCellDelegate: class {
    func confirmButtonDidTapped(cell: CartTotalPriceTableViewCell)
}

class CartTotalPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    // Montant total HT
    @IBOutlet weak var totalAmountHTView: UIView!
    @IBOutlet weak var totalAmountHTLabel: UILabel!
    @IBOutlet weak var totalAmountHTValue: UILabel!
    
    // Montant  TVA
    @IBOutlet weak var tvaAmountView: UIView!
    @IBOutlet weak var tvaAmountLabel: UILabel!
    @IBOutlet weak var tvaAmountValue: UILabel!
    
    // Frais de livraison
    @IBOutlet weak var shippingAmountView: UIView!
    @IBOutlet weak var shippingAmountLabel: UILabel!
    @IBOutlet weak var shippingAmountValue: UILabel!
    
    // Montant réduction
    @IBOutlet weak var promoAmountView: UIView!
    @IBOutlet weak var promoAmountLabel: UILabel!
    @IBOutlet weak var promoAmountValue: UILabel!
    
    // Montant total TTC
    @IBOutlet weak var totalAmountTTCView: UIView!
    @IBOutlet weak var totalAmountTTCLabel: UILabel!
    @IBOutlet weak var totalAmountTTCValue: UILabel!
    @IBOutlet weak var totalAmountTTCSentence: UILabel!
    @IBOutlet weak var totalAmountTTCButton: UIButton!
    @IBOutlet weak var totalAmountTTCButtonView: UIView!
    
    // Secure Payment
    @IBOutlet weak var securePaymentView: UIView!
    @IBOutlet weak var securePaymentImage: UIImageView!
    @IBOutlet weak var securePaymentLabel: UILabel!
    
    weak var delegate: CartTotalPriceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 10
        self.stackView.layer.cornerRadius = 10
        self.containerView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 0, y: 2, blur: 20, spread: 0)
        self.setupTotalAmountHT()
        self.setupTotalAmountTVA()
        self.setupShippingAmount()
        self.setupPromoAmount()
        self.setupTotalAmountTTC()
        
        self.totalAmountTTCSentence.text = "Total TTC calculé en application de la législation en vigueur"
        self.totalAmountTTCSentence.numberOfLines = 0
        self.securePaymentLabel.text = "Paiement sécurisé"
        self.securePaymentLabel.textColor = .lpDeepBlue
        self.securePaymentLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setupTotalAmountHT() {
        self.totalAmountHTLabel.font = UIFont.systemFont(ofSize: 15)
        self.totalAmountHTLabel.textColor = .lpGrey
        self.totalAmountHTValue.textColor = .lpDeepBlue
        self.totalAmountHTValue.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func setupTotalAmountTVA() {
        self.tvaAmountLabel.font = UIFont.systemFont(ofSize: 15)
        self.tvaAmountLabel.textColor = .lpGrey
        self.tvaAmountValue.textColor = .lpDeepBlue
        self.tvaAmountValue.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func setupShippingAmount() {
        self.shippingAmountLabel.font = UIFont.systemFont(ofSize: 15)
        self.shippingAmountLabel.textColor = .lpGrey
        self.shippingAmountValue.textColor = .lpDeepBlue
        self.shippingAmountValue.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func setupPromoAmount() {
        self.promoAmountLabel.font = UIFont.systemFont(ofSize: 15)
        self.promoAmountLabel.textColor = .lpGrey
        self.promoAmountValue.textColor = .lpDeepBlue
        self.promoAmountValue.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func setupTotalAmountTTC() {
        self.totalAmountTTCLabel.textColor = .lpDeepBlue
        self.totalAmountTTCLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.totalAmountTTCValue.textColor = .lpPurple
        self.totalAmountTTCValue.font = UIFont.boldSystemFont(ofSize: 24)
        self.totalAmountTTCSentence.textColor = .lpGrey
        self.totalAmountTTCSentence.font = UIFont.italicSystemFont(ofSize: 12)
        self.totalAmountTTCButtonView.layer.cornerRadius = 5
    }
    
    func setupCartTotalPriceCell(priceWithTVA: HYBPrice, priceWithoutTVA: HYBPrice, totalTVA: HYBPrice, shippingPrice: HYBPrice?, reductionPrice: HYBPrice, shouldDisplay: Bool) {

        self.totalAmountHTValue.text = priceWithoutTVA.formattedValue
        self.totalAmountHTLabel.text = "Montant total HT"
        self.totalAmountHTView.isHidden = false

        self.tvaAmountValue.text = totalTVA.formattedValue
        self.tvaAmountLabel.text = "Montant TVA"
        self.tvaAmountView.isHidden = false
        
        self.shippingAmountView.isHidden = true

//        self.shippingAmountValue.text = String(describing: shippingPrice)
        self.shippingAmountValue.text = shippingPrice?.formattedValue ?? "0,00 €"
        self.shippingAmountLabel.text = "Frais de livraison estimés"
        self.shippingAmountView.isHidden = false
        
        if shouldDisplay {
            self.promoAmountValue.text = CartViewModel.sharedInstance.discountValue()
            self.promoAmountLabel.text = "Montant de la réduction"
            self.promoAmountView.isHidden = false
        } else {
            self.promoAmountView.isHidden = true
        }
        
//        if reductionPrice.value != 0 {
//            self.promoAmountValue.text = reductionPrice.formattedValue
//            self.shippingAmountLabel.text = "Montant de la réduction"
//            self.promoAmountView.isHidden = false
//        } else {
//            self.promoAmountView.isHidden = true
//        }
        
        self.totalAmountTTCValue.text = priceWithTVA.formattedValue
        self.totalAmountTTCLabel.text = "Total"
        self.totalAmountTTCView.isHidden = false
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.delegate?.confirmButtonDidTapped(cell: self)
    }
    
}
