//
//  PaymentMethodsViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 25/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

class PaymentMethodsViewController: UIViewController {

    // Outlets
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var commandePriceLabel: UILabel!
    @IBOutlet weak var shipmentPriceLabel: UILabel!
    @IBOutlet weak var shipmentLabel: UILabel!
    @IBOutlet weak var detailTotalLabel: UILabel!
    @IBOutlet weak var bottomLineModeStackView: UIStackView!
    @IBOutlet weak var paylibView: UIView!
    
    
    
    // Constraint
    @IBOutlet weak var topDetailTotalConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomDetailTotalConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightDetailTotalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topDeliveryConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomDeliveryConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightShipmentLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightBlockPriceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lineOneView: UIView!
    @IBOutlet weak var lineTwoView: UIView!
    
    
    var paymentViewModel = PaymentViewModel()
    
    func maskForEService() {
        topDetailTotalConstraint.constant = 0
        bottomDetailTotalConstraint.constant = 0
        heightDetailTotalConstraint.constant = 0
        detailTotalLabel.isHidden = true
        
        topDeliveryConstraint.constant = 0
        bottomDeliveryConstraint.constant = 0
        self.heightShipmentLabelConstraint.constant = 0
        shipmentLabel.isHidden = true
        heightBlockPriceConstraint.constant = 64
        
        lineOneView.isHidden = true
        lineTwoView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleNavigationBar(backEnabled: true, title:"Paiement", showCart: false)
        totalView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 0, y: 2, blur: 20, spread: 0)
        
        self.paymentViewModel.delegate = self
        
        commandePriceLabel.text = CartViewModel.sharedInstance.cart?.subTotal.formattedValue
        let deliveryCost = CartViewModel.sharedInstance.cart?.deliveryCost
        if (deliveryCost != nil && deliveryCost!.value.doubleValue > 0.0) {
            shipmentPriceLabel.text = deliveryCost?.formattedValue
        } else {
            shipmentPriceLabel.text = "Offerts"
        }
        totalPriceLabel.text = CartViewModel.sharedInstance.cart?.totalPriceWithTax.formattedValue
    
        if self.paymentViewModel.cartContainColissimo() {
            self.paylibView.isHidden = true
            self.bottomLineModeStackView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)))
        }
        
        if self.paymentViewModel.cart?.hasOnlyEservice ?? false {
            self.maskForEService()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kCardChoice,
                                                             chapter1: TaggingData.kTunnel,
                                                             chapter2: nil,
                                                             level2: TaggingData.kCommerceLevel)
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectPaymentMethod(_ sender: UIButton) {
        switch sender.tag {
        // CB, Visa, Mastercard
        case 1, 2, 3:
            self.paymentViewModel.provider(paymentMode: .cb)
            break
        // Paylib
        case 4:
            
            self.paymentViewModel.provider(paymentMode: .paylib)
            break
        // Paypal
        default:
            self.paymentViewModel.provider(paymentMode: .paypal)
            break
        }
    }
    
}

extension PaymentMethodsViewController : PayPalPaymentDelegate {
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        self.dismiss(animated: true) {
            self.showPaymentView()
            self.paymentViewModel.payPalPaymentCompleted(completedPayment: completedPayment)
        }
    }
    
    func showPaymentView() {
        let paymentView = UIView()
        paymentView.frame = self.view.bounds
        paymentView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 20, y: paymentView.frame.size.height/2 - 200, width: paymentView.frame.size.width - 40, height: 70))
        label.text = "Veuillez patienter svp, la transaction est en cours de vérification."
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        paymentView.addSubview(label);
        self.view.addSubview(paymentView)
    }
    
}


extension PaymentMethodsViewController : PaymentDelegate {
    
    func showPayPalViewController(payment: PayPalPayment, config: PayPalConfiguration) {
        let payPalPaymentViewController = PayPalPaymentViewController(payment: payment, configuration: config, delegate: self)
        self.present(payPalPaymentViewController!, animated: true)
    }
    
    func showPaymentScellius(html: String, orderNumber: String, cart: HYBCart) {
        let controller = R.storyboard.payment.mcmPaymentWebViewController()!
        controller.paymentMean = self.paymentViewModel.paymentMode?.rawValue ?? ""
        controller.initalPaymentFormHTML = html
        controller.hybrisUrl = EnvironmentUrlsManager.sharedManager.getHybrisServiceHost()
        controller.orderNumber = orderNumber
        controller.cart = cart
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func resultPaypal(success: Bool, orderNumber: String?, messageDelivery: String?) {
        
        
        if (success) {
            let confirmationViewController = R.storyboard.payment.paymentConfirmationViewController()!
            
            confirmationViewController.setup(deliveryDateMessage: messageDelivery ?? "",
                                             orderNumber: orderNumber ?? "",
                                             isOnlyService: (CartViewModel.sharedInstance.cart?.hasOnlyEservice)!,
                                             containsColissimo: CartViewModel.sharedInstance.cartContainColissimo(),
                                             depositDate: CartViewModel.sharedInstance.getDepositDate(),
                                             isDepositModePostOffice: CartViewModel.sharedInstance.isDepositModePostOffice())
            // Need change
            self.navigationController?.pushViewController(confirmationViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Erreur de paiement",
                                          message: "Votre commande n'a malheureusement pas pu aboutir. Nous vous confirmons que votre compte bancaire ne sera pas débité du montant de votre commande.",
                                          dismissActionTitle: "Ok")
            {
                self.navigationController?.popViewController(animated: true)
                return
            }

            self.present(alert!, animated: true, completion: nil)
        }
    }
}




