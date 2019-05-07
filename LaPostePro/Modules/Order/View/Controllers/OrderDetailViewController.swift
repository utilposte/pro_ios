//
//  OrderDetailViewController.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 31/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: OrderViewModel!
    var sections: [[OrderDetailRow]] = [[OrderDetailRow]]()
    
    enum OrderDetailRow: Equatable {
        case main
        case detailShippement
        case detailPrice(finish: Bool)
        case address(delivery: Bool)
        case entry
        case detailPayment
        case contactUs
        case returnOrder
        case download
        case simpleTotal
        
        
        var cellIdentifier: String {
            switch self {
            case .main:
                return R.reuseIdentifier.mainOrderDetailTableViewCell.identifier
            case .detailShippement, .detailPayment:
                return R.reuseIdentifier.orderDetailImageTableViewCell.identifier
            case .detailPrice:
                return R.reuseIdentifier.orderPriceDetailTableViewCell.identifier
            case .address:
                return R.reuseIdentifier.orderAddressTableViewCell.identifier
            case .entry:
                return R.reuseIdentifier.orderEntryTableViewCell.identifier
            case .contactUs, .returnOrder:
                return R.reuseIdentifier.orderContactTableViewCell.identifier
            case .download:
                return R.reuseIdentifier.orderDownloadTableViewCell.identifier
            case .simpleTotal:
                return R.reuseIdentifier.orderDetailTotalSimpleTableViewCell.identifier
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .main:
                return UITableViewAutomaticDimension
            case .detailShippement, .detailPayment, .simpleTotal:
                return 72
            case .detailPrice(let finish):
                return finish ? 278 : 202
            case .address:
                return 205
            case .entry:
                return UITableViewAutomaticDimension  //210
            case .contactUs, .returnOrder:
                return 190
            case .download:
                return 70
            }
        }
        
        static func == (lhs: OrderDetailRow, rhs: OrderDetailRow) -> Bool {
            switch (lhs, rhs) {
            case (.entry, .entry):
                return true
            default:
                return false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleNavigationBar(backEnabled: true, title: "Détail de commande", showCart: false)
        let downloadButton = self.createBarButtonItem(image: R.image.ic_btn_download(), action: #selector(OrderDetailViewController.getBillOrder))
        self.navigationItem.setRightBarButtonItems([downloadButton], animated: false)

        self.sections.append([OrderDetailRow]())
        self.sections[0].append(.main)
        if !self.viewModel.hasOnlyService() {
            self.sections[0].append(.detailShippement)
        }
        self.sections.append([OrderDetailRow]())

        let numberEntry = viewModel.numberEntries()
        var i = 0
        while i < numberEntry {
            self.sections[1].append(.entry)
            i += 1
        }
        
        self.sections.append([OrderDetailRow]())
        if self.viewModel.hasOnlyService() {
            self.sections[2].append(.simpleTotal)
        }
        else {
            self.sections[2].append(.detailPrice(finish: true))
        }
        self.sections[2].append(.detailPayment)
        
        self.sections.append([OrderDetailRow]())
        if viewModel.detailOrder?.canReturnOrder() == true{            
            self.sections[3].append(.returnOrder)
        }
        self.sections[3].append(.contactUs)
        
        self.sections.append([OrderDetailRow]())
        if !self.viewModel.hasOnlyService() {
            self.sections[4].append(.address(delivery: true))
        }
        self.sections[4].append(.address(delivery: false))
        
        self.sections.append([OrderDetailRow]())
        self.sections[5].append(.download)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kOrderDetails,
                                                             chapter1: TaggingData.kMyOrders,
                                                             chapter2: nil,
                                                             level2: TaggingData.kAccountLevel)
        
    }

    func renewOrder() {
        self.viewModel.renewOrder(completion: { message in
            let toastConfiguration = Toast(title: message, titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 2)
            let toast = ToastView()
            VibrationHelper.addToCart()
            toast.drawToast(toast: toastConfiguration)
        })
    }
    
    @objc func getBillOrder() {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kTelechargerFacture,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kMyOrders,
                                                              chapter2: TaggingData.kOrderDetails,
                                                              level2: TaggingData.kAccountLevel)
        
        self.viewModel.getBillOrder(completion: { url in
            guard let url = URL(string: url) else { return }
            UIApplication.shared.open(url)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OrderDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.section][indexPath.row]
        switch item {
        case .main:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! MainOrderDetailTableViewCell
            cell.configureCell(mainActionClosure: {
                self.renewOrder()
            }, needMainButton: !self.viewModel.hasOnlyService())
            cell.refLabel.text = viewModel.orderRef()
            cell.dateAndStatusLabel.attributedText = viewModel.orderDateAndStatus()
            cell.priceLabel.text = viewModel.orderPrice()
            return cell
        case .detailShippement:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderDetailImageTableViewCell
            cell.label.text = "Mode de livraison"
            cell.iconImageView.image = self.viewModel.getDeliveryMode()
            cell.delivery(mode: true)
            return cell
        case .detailPrice:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderPriceDetailTableViewCell
            cell.deliveryCostLabel.text = viewModel.deliveryCost()
            cell.totalPriceLabel.text = viewModel.totalWithTax()
            cell.taxLabel.text = viewModel.totalTax()
            cell.priceHTLabel.text = viewModel.subTotalPrice()
            cell.closureOrderAgain = {
                self.renewOrder()
            }
            return cell
        case .simpleTotal:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderDetailTotalSimpleTableViewCell
            cell.priceLabel.text = viewModel.totalWithTax()
            return cell
        case .address(let delivery):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderAddressTableViewCell
            cell.label.text = delivery ? "Adresse d'expédition" : "Adresse de facturation"
            cell.companyNameLabel.text = viewModel.addressCompanyName(delivery: delivery)
            cell.titleLabel.text = viewModel.addressTitle(delivery: delivery)
            cell.line1Label.text = viewModel.addressLine1(delivery: delivery)
            cell.line2Label.text = viewModel.addressLine2(delivery: delivery)
            cell.countryLabel.text = viewModel.addressCountry(delivery: delivery)
            return cell
        case .entry:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderEntryTableViewCell
            if self.viewModel.isREEX(index: indexPath.row), let reexProduct = viewModel.reexProduct(index: indexPath.row) {
                cell.reexStackView.isHidden = false
                cell.buyAgainView.isHidden = true
                cell.titleLabel.text = reexProduct.name
                cell.priceLabel.attributedText = viewModel.priceLabelForEntry(index: indexPath.row)
                cell.quantityLabel.text = ""
                cell.detailLabel.text = viewModel.reexDetail(index: indexPath.row)
                cell.entryImageView.image = viewModel.reexImage(index: indexPath.row)
            } else {
                cell.reexStackView.isHidden = true
                cell.buyAgainView.isHidden = false
                cell.titleLabel.text = viewModel.nameProductForEntry(index: indexPath.row)
                cell.detailLabel.text = viewModel.descriptionForEntry(index: indexPath.row)
                cell.priceLabel.attributedText = viewModel.priceLabelForEntry(index: indexPath.row)
                cell.quantityLabel.text = viewModel.quantityForEntry(index: indexPath.row)
                
                if self.viewModel.isColissimo(index: indexPath.row) {
                    cell.entryImageView.image = R.image.icon_colissimo()
                }
                else {
                    cell.loadImage(url: viewModel.urlImageForEntry(index: indexPath.row))
                }
                
                cell.buyAgainViewHeighConstraint.constant = self.viewModel.showButtonForEntry(index: indexPath.row) ? 44 : 0
                cell.buyAgainView.isHidden = !self.viewModel.showButtonForEntry(index: indexPath.row)
                cell.buyAgainClosure = {
                    self.viewModel.addProductToCart(index: indexPath.row, completion: { message in
                        if message != nil {
                            let toastConfiguration = Toast(title: message!, titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 2)
                            let toast = ToastView()
                            VibrationHelper.addToCart()
                            toast.drawToast(toast: toastConfiguration)
                        }
                    })
                }
            }
            return cell
        case .detailPayment:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderDetailImageTableViewCell
            cell.label.text = "Mode de paiement"
            cell.iconImageView.image = self.viewModel.getPaymentMode()
            cell.delivery(mode: false)
            return cell
        case .contactUs:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderContactTableViewCell
            cell.delegate = self
            cell.contactUs()
            return cell
        case .returnOrder:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderContactTableViewCell
            cell.returnOrder()
            return cell
        case .download:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderDownloadTableViewCell
            cell.configureCell {
                self.getBillOrder()
            }
            return cell
        }
        //return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.sections[indexPath.section][indexPath.row]
        switch  item {
        case .entry:
            if !self.viewModel.isService(index: indexPath.row) {
                self.viewModel.showProduct(index: indexPath.row) { product in
                    guard let productViewController = R.storyboard.eBoutique.productViewControllerID() else { return }
                    productViewController.productDetailViewModel.product = product
                    productViewController.productDetailViewModel.categoryId = "commande" // TODO
                    self.navigationController?.pushViewController(productViewController, animated: true)
                }
            } else if self.viewModel.isREEX(index: indexPath.row) {
                // PUSH TO Reex Detail Product
                if let viewController = UIStoryboard.init(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "ReexCartDetailViewControllerID") as? ReexCartDetailViewController {
                    viewController.product = self.viewModel.reexProduct(index: indexPath.row)
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sections[indexPath.section][indexPath.row].rowHeight
    }
}

extension OrderDetailViewController: OrderDetailCellDelegate {
    
    func returnOrderTapped() {
        let vc = R.storyboard.order.returnOrderViewController()
        if let order = self.viewModel.detailOrder {
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kReturnOrder,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kMyOrders,
                                                                  chapter2: TaggingData.kOrderDetails,
                                                                  level2: TaggingData.kAccountLevel)
            
            let viewModel = ReturnOrderViewModel(order: order, isClaim: false)
            vc?.viewModel = viewModel
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    func contactUsTapped() {
        let vc = R.storyboard.order.claimOrderViewController()
        if let order = self.viewModel.detailOrder {
            let viewModel = ReturnOrderViewModel(order: order, isClaim: true)
            vc?.viewModel = viewModel
            self.present(vc!, animated: true, completion: nil)
        }
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kContactezNous,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kMyOrders,
                                                              chapter2: TaggingData.kOrderDetails,
                                                              level2: TaggingData.kAccountLevel)
        
//        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! WebViewController
//        vc.webViewType = .contactUsForm
//        vc.url = WebViewURL.contact.rawValue
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


/*
 
 *
 MAINQUESTION --
 TYPE --
 
 *
 LISTE ENTRIES
 
 *
 Mode payment --
 Detail price
 
 *
 no satisty
 
 *
 Contact us --
 
 *
 Address --
 Address --
 download --
 
 */

