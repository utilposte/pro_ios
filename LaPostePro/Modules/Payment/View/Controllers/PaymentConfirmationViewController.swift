//
//  PaymentConfirmationViewController.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 20/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPColissimo
import LPSharedMCM
import UIKit

@objc enum OrderType: Int {
    case physical
    case colissimo
    case mixed
    case other
    
    init?(isOnlyService: Bool, containsColissimo: Bool) {
        if isOnlyService {
            if containsColissimo {
                self = .colissimo
            } else {
                self = .other
            }
        } else {
            if containsColissimo {
                self = .mixed
            } else {
                self = .physical
            }
        }
    }
}

class PaymentConfirmationViewController: UIViewController {
    @IBOutlet var footerView: UIView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet weak var colissimoView: UIView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var colissimoMessageLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderToCollisimoConstraint: NSLayoutConstraint!
    @IBOutlet weak var colissimoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var equalHeightsConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var colissimoViewBottomConstraint: NSLayoutConstraint!
    
    // Block error Colissimo
    @IBOutlet weak var errorColissimoView: UIView!
    @IBOutlet weak var errorColissimoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var downloadButtonHeightConstraint: NSLayoutConstraint!
    
    var deliveryDateMessage: String?
    var orderNumber: String?
    var orderType: OrderType = .mixed
    var isError = false
    lazy var loaderManager = LoaderViewManager()
    @objc var isDepositModePostOffice = false
    @objc var orderDate: String = "28/01/2019"
    @objc var depositDate: String = "2018-09-10T09:37:25+0000"
    
    @objc func setup(deliveryDateMessage: String, orderNumber: String, isOnlyService: Bool, containsColissimo: Bool, depositDate: String, isDepositModePostOffice: Bool) {
        self.deliveryDateMessage = deliveryDateMessage
        self.orderNumber = orderNumber
        orderType = OrderType(isOnlyService: isOnlyService, containsColissimo: containsColissimo)!
        self.depositDate = depositDate
        self.isDepositModePostOffice = isDepositModePostOffice
    }
    
    override func viewDidLayoutSubviews() {
        if orderType == .physical {
            colissimoViewBottomConstraint.isActive = false
            orderViewBottomConstraint.isActive = true
        }
    }
    
    func configureView() {
        switch orderType {
        case .physical:
            colissimoView.isHidden = true
            colissimoViewHeightConstraint.constant = 0
            containerView.backgroundColor = .clear
            containerView.borderWidth = 0
        case .colissimo:
            self.deliveryDateMessage = ""
            orderView.backgroundColor = .clear
            orderView.borderWidth = 0
            colissimoView.backgroundColor = .clear
            colissimoView.borderWidth = 0
            colissimoViewBottomConstraint.isActive = true
            colissimoMessageLabel.attributedText = generateColissimoMesage(date: depositDate)
        case .mixed:
            topViewConstraint.constant = 0
            iconImageView.isHidden = true
            iconHeightConstraint.constant = 0
            orderToCollisimoConstraint.constant = 30
            containerView.backgroundColor = .clear
            containerView.borderWidth = 0
            colissimoViewBottomConstraint.isActive = true
            colissimoMessageLabel.attributedText = generateColissimoMesage(date: depositDate)
            
        default:
            break
        }
        
        if isError {
            downloadButton.isHidden = true
            errorButton.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupModalNavigationBar(title: "Votre commande", image: R.image.ic_close()!)
        if let message = deliveryDateMessage?.replacingOccurrences(of: "Votre commande ", with: ""), let order = orderNumber {
            let text = NSMutableAttributedString()
            text.normal("Votre commande n° ").custom(order, font: UIFont.boldSystemFont(ofSize: 15),
                                                      color: UIColor.lpPurple).normal("\n\(message)")
            detailLabel.attributedText = text
        } else {
            detailLabel.text = ""
        }
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kPaiementConfirmation,
                                                             chapter1: TaggingData.kTunnel,
                                                             chapter2: nil,
                                                             level2: TaggingData.kCommerceLevel)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        gotoHome()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        gotoHome()
    }
    
    @IBAction func errorTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://boutique.laposte.fr//colissimo-en-ligne/inbenta-duplicata-refund.") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func showErrorDownloadColissimo() {
        self.errorColissimoView.isHidden = false
        self.downloadButton.isHidden = true
        self.downloadButton.isUserInteractionEnabled = false
    }
    
    @IBAction func downloadTapped(_ sender: UIButton) {
        loaderManager.showLoderView()
        if let uID = UserAccount.shared.customerInfo?.displayUid, let _orderNumber = orderNumber {
            ColissimoAPIClient.sharedInstance.getBordereauxAffranchissement(user: uID, orderCode: _orderNumber,
                                                                            callback: { result, error in
                                                                                self.loaderManager.hideLoaderView()
                                                                                if error == nil {
                                                                                    let vc = R.storyboard.payment.pdfWebViewController()
                                                                                    vc?.pdfData = result
                                                                                    self.present(vc!, animated: true, completion: nil)
                                                                                } else {
                                                                                    self.showErrorDownloadColissimo()
                                                                                }
            })
        } else {
            loaderManager.hideLoaderView()
            let alertController = UIAlertController(title: nil, message: "Une erreur est survenue", dismissActionTitle: "Fermer", dismissActionBlock: {})
            present(alertController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func showOrderViewTapped(_ sender: Any) {
        let viewModel = OrderViewModel()
        viewModel.getOrderDetail(code: orderNumber ?? "") { order in
            if order != nil {
                let viewController = R.storyboard.order.orderDetailViewController()!
                viewController.viewModel = viewModel
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let myFooterView = FooterView().initFooterView()
        myFooterView.frame.size.height = self.footerView.frame.height
        myFooterView.frame.size.width = self.footerView.frame.width
        myFooterView.layoutIfNeeded()
        self.footerView.addSubview(myFooterView)
        self.footerView.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func generateColissimoMesage(date: String) -> NSMutableAttributedString {
        let messageString = NSMutableAttributedString()
        
        let endMessage = isDepositModePostOffice ? " - Le déposer en bureau de poste." : " - Le déposer dans votre boîte aux lettres avant 8h, pour que le facteur puisse récupérer votre colis  demain (si votre commande est passée avant 22h30) ou après-demain (si votre commande est passée après 22h30) et déposer un avis de prise en charge."
        messageString
            .normal("Si vous choisissez de ne pas imprimer tout de suite, votre bordereau pourra être téléchargé depuis votre compte client. Attention, vous avez")
            .bold(" 7 jours", size: 14)
            .normal(" à partir d'aujourd'hui")
            .normal(" pour:\n - Imprimer et coller le bordereau sur votre colis.\n")
            .normal(endMessage)
        
        return messageString
    }
}
