//
//  ShippingCartViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedMCM
import RealmSwift
import UIKit

class ShippingCartViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var sections = [ShippingCart]()
    var CGVChecked = false
    var deliveryAddresses = [DeliveryAddress]()
    var colissmoCostShipping: String?
    let viewModel: ShippingCartViewModel = ShippingCartViewModel()
    lazy var loaderManager = LoaderViewManager()
    var isModel = false
    
    enum ShippingCart: Equatable {
        case infoShipping(title: String)
        case adressesShipping(addresses: [DeliveryAddress])
        case addressBilling
        case shippingMode(type: String, amount: String)
        case cgvCondition(isChecked: Bool)
        case payment(isEnabled: Bool)
        case help
        case addressDetail
        case addressListDescription
        case titlePaymentAddress
        
        var cellIdentifier: String {
            switch self {
            case .titlePaymentAddress:
                return "TitleAddressPaymentTableViewCellID"
            case .infoShipping:
                return "ShippingInfoTableViewCellID"
            case .adressesShipping:
                return "AdressesShippingTableViewCellID"
            case .addressBilling:
                return "AddressBillingTableViewCellID"
            case .shippingMode:
                return "ShippingModeTableViewCellID"
            case .cgvCondition:
                return "CGVConditionTableViewCellID"
            case .payment:
                return "PaymentTableViewCellID"
            case .help:
                return "HelpTableViewCellID"
            case .addressDetail:
                return "AddressShippingTableViewCell"
            case .addressListDescription:
                return "AddressListDescriptionTableViewCell"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .titlePaymentAddress:
                return 40
            case .infoShipping:
                return 70
            case .help:
                return 100
            default:
                return UITableViewAutomaticDimension
            }
        }
        
        static func ==(lhs: ShippingCart, rhs: ShippingCart) -> Bool {
            switch (lhs, rhs) {
            case (.infoShipping, .infoShipping), (.adressesShipping, .adressesShipping), (.addressBilling, .addressBilling):
                return true
            case (.shippingMode, .shippingMode), (.payment, .payment), (.cgvCondition, .cgvCondition):
                return true
            case (.help, .help), (.addressListDescription, .addressListDescription), (.addressDetail, .addressDetail):
                return true
            default:
                return false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        //When it is open from the home is model view
        if isModel {
            self.setupModalNavigationBar(title: "Mes coordonnées", image: R.image.ic_close() ?? UIImage())
        } else {
            self.setupTitleNavigationBar(backEnabled: true, title: "Mes coordonnées")
        }
        self.tableView.register(UINib(nibName: "AddressShippingCell", bundle: nil), forCellReuseIdentifier: "AddressShippingTableViewCell")
    }
    
    func refresh() {
        self.deliveryAddresses = [DeliveryAddress]()
        if let deliveryAddress = viewModel.getDeliveryAddress() {
            self.deliveryAddresses.append(deliveryAddress)
        }
        colissmoCostShipping = String(describing: CartViewModel.sharedInstance.deliveryCost())
        self.buildSection()
        self.tableView.reloadData()
    }
    
//    func setDeliveryViewController(completion: @escaping (LPNetworkError?) -> ()) {
//        let address = Address()
//        address.firstName = "Matthieu"
//        address.lastName = "Lemonnier"
//        address.line1 = "62 RUE CAMILLE DESMOULINS"
//        address.postalCode = "92130"
//        address.country = "FRANCE"
//        address.countryIsoCode = "FR"
//        address.town = "Issy-les-Moulineaux"
//
//        address.countryIsoCode = address.countryIsoCode?.lowercased()
//        let dict = MCMAddressToDictionaryMapper.mapHYBAddressToDictionary(forHybrisAPI: HYBAddress(address: address))
//        MCMCartManager.shared().createAddress(dict as! [AnyHashable: Any], forCart: "current", withCallback: { _, error in
//            if error == nil {
//                MCMCartManager.shared().setCartDeliveryModeWithDeliveryId("so-colissimo-gross", cartId: "current", withCallback: { _, error in
//                    completion(error)
//                })
//            } else {
//                completion(error)
//            }
//        })
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.refresh()
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kAddressAndDeliveryType,
                                                             chapter1: TaggingData.kTunnel,
                                                             chapter2: nil,
                                                             level2: TaggingData.kCommerceLevel)
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func buildSection() {
        //
        if self.viewModel.isOnlyService() {
            self.sections = [.infoShipping(title: "Mes informations de facturation"), .titlePaymentAddress, .addressDetail, .cgvCondition(isChecked: self.viewModel.CGVChecked), .payment(isEnabled: self.viewModel.paymentEnabled()), .help]
        } else {
            if self.viewModel.getUseTheSameAddress() {
                self.sections = [.infoShipping(title: "Mes informations de livraison"), .adressesShipping(addresses: self.deliveryAddresses), .addressBilling, .shippingMode(type: "Livraison Colissimo*", amount: self.colissmoCostShipping ?? ""), .cgvCondition(isChecked: self.viewModel.CGVChecked), .payment(isEnabled: self.viewModel.paymentEnabled()), .help]
            } else {
                self.sections = [.infoShipping(title: "Mes informations de livraison"), .adressesShipping(addresses: self.deliveryAddresses), .addressBilling, .addressDetail, .shippingMode(type: "Livraison Colissimo*", amount: self.colissmoCostShipping ?? ""), .cgvCondition(isChecked: self.viewModel.CGVChecked), .payment(isEnabled: self.viewModel.paymentEnabled()), .help]
            }
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
}

extension ShippingCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.row]
        switch item {
        case .infoShipping(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ShippingInfoTableViewCell
            cell.setupCell(title: title)
            return cell
        case .adressesShipping(let addresses):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AdressesShippingTableViewCell
            cell.setupTableViewCell(addresses: addresses)
            cell.delegate = self
            return cell
        case .addressBilling:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AddressBillingTableViewCell
            cell.setSwitch(isOn: self.viewModel.getUseTheSameAddress(), isEnabled: self.viewModel.getDeliveryAddress() != nil)
            cell.delegate = self
            return cell
        case .shippingMode(let type, let amount):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ShippingModeTableViewCell
            cell.setupShippingModeCell(type: type, amount: amount)
            return cell
        case .cgvCondition(let CGVCheck):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CGVConditionTableViewCell
            cell.setupCGVCell(CGVCheck: CGVCheck)
            cell.delegate = self
            return cell
        case .payment(let paymentEnabled):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! PaymentTableViewCell
            cell.setupPaymentCell(isEnabled: paymentEnabled)
            cell.delegate = self
            return cell
        case .help:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HelpTableViewCell
            return cell
        case .addressListDescription:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AddressListDescriptionTableViewCell
            return cell
        case .addressDetail:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AddressShippingTableViewCell
            cell.isBillingAddress = true
            cell.delegate = self
            cell.setupAddressCell(address: viewModel.getBillingAddress())
            return cell
        case .titlePaymentAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! TitleAddressPaymentTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.sections[indexPath.row]
        switch item {
        case .help:
            let viewController = R.storyboard.webView.webViewControllerID()!
            viewController.url = "https://aide.laposte.fr/professionnel/"
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.sections[indexPath.row]
        switch item {
        case .adressesShipping:
            if !self.deliveryAddresses.isEmpty {
                return CGFloat(self.deliveryAddresses.count * 200) + 30
            } else {
                return 140
            }
        default:
            return self.sections[indexPath.row].rowHeight
        }
    }
}

extension ShippingCartViewController: CGVConditionTableViewCellDelegate, ChangeBillingAddressDelegate, OrderAddressesDelegate {
    func edit(address: DeliveryAddress) {
        guard let editAddressViewController = R.storyboard.payment.billingAddressViewController() else {
            return
        }
        editAddressViewController.viewModel.address = address
        self.navigationController?.pushViewController(editAddressViewController, animated: true)
    }
    
    func cgvCondidionButtonDidTapped() {
        self.viewModel.CGVChecked = !self.viewModel.CGVChecked
        self.buildSection()
        self.tableView.reloadData()
    }
    
    func sameBillingAddressAsDeliverySwitchChangeValue(useTheSame: Bool) {
        if useTheSame {
            for shippingCartCell in self.sections {
                if shippingCartCell == ShippingCart.addressDetail {
                    self.viewModel.setUseTheSameAddress(bool: true)
                    let itemIndex = self.sections.index(of: shippingCartCell)!
                    self.sections.remove(at: itemIndex)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [IndexPath(row: itemIndex, section: 0)], with: .automatic)
                    tableView.endUpdates()
                }
            }
        } else {
            if !self.sections.contains(.addressListDescription) {
                self.sections.insert(.addressDetail, at: 3)
                self.viewModel.setUseTheSameAddress(bool: false)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
}

extension ShippingCartViewController: PaymentTableViewCellDelegate {
    func payTapped() {
        self.viewModel.executePayment { success in
            if success {
                self.navigationController?.pushViewController(R.storyboard.payment.paymentMethodsViewControllerID()!, animated: true)
            }
        }
    }
}

extension ShippingCartViewController: AdressesShippingTableViewCellDelegate {
    func tableViewCellTapped(indexPath: IndexPath) {
        self.loaderManager.showLoderView()
        self.viewModel.getDeliveryMode { url, error in
            self.loaderManager.hideLoaderView()
            if error != nil || url == nil {
                let alertController = UIAlertController(title: "Erreur", message: "Impossible de charger la page colissimo", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Fermer", style: .destructive, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.loaderManager.hideLoaderView()
                let viewController = R.storyboard.webView.webViewControllerID()!
                viewController.webViewType = WebViewControllerType.colissimo(completion: { url in
                    self.loaderManager.showLoderView()
                    self.viewModel.postResultColissimo(urlString: url, completion: { success in
                        self.loaderManager.hideLoaderView()
                        if success {
                            self.loaderManager.showLoderView()
                            CartViewModel.sharedInstance.getCart(onCompletion: { _ in
                                self.loaderManager.hideLoaderView()
                                self.viewModel.updateBillingAddress()
                                self.refresh()
                            })
                        } else {
                            let alertController = UIAlertController(title: "Erreur", message: "Erreur lors de la sauvegarde de l'adresse de livraison", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Fermer", style: .destructive, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                })
                viewController.url = url
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
