//
//  ReturnOrderViewController.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 14/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ReturnOrderViewController: BaseViewController {
    
    var viewModel : ReturnOrderViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    var productCells = [ReturnOrderProductCell]()
    var products = [ReturnOrderModel]()
    var returnOrderRows = [[ReturnOrderRow]]()
    var canValidate = false
    
    enum ReturnOrderRow {
        case header
        case product
        case footer
        
        var cellIdentifier : String {
            switch self {
            case .header:
                return R.reuseIdentifier.returnOrderHeaderCell.identifier
            case .product:
                return R.reuseIdentifier.returnOrderProductCell.identifier
            case .footer :
                return R.reuseIdentifier.returnOrderFooterCell.identifier
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = "Retourner la commande"
        viewModel?.configureData(callback: { (result) in
            if result.count > 0 {
                self.products = result
                self.waitingView.isHidden = true
                self.initData()
            }
            else {
                // Back With Error
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kReturnOrder,
                                                             chapter1: TaggingData.kMyOrders,
                                                             chapter2: nil,
                                                             level2: TaggingData.kAccountLevel)
        
    }
    
    func initData() {
        productCells = [ReturnOrderProductCell]()
        returnOrderRows = [[ReturnOrderRow]]()
        returnOrderRows.append([ReturnOrderRow]())
        returnOrderRows[0].append(.header)
        returnOrderRows.append([ReturnOrderRow]())
        for _ in  products {
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.returnOrderProductCell.identifier) as? ReturnOrderProductCell {
                productCells.append(cell)
                returnOrderRows[1].append(.product)
            }
        }
        returnOrderRows.append([ReturnOrderRow]())
        returnOrderRows[2].append(.footer)
        tableView.reloadData()
        setValidateButton()
    }
    
    func hidePicker() {
        for cell in productCells {
            cell.hidePickerView()
        }
    }
    
    func setValidateButton() {
        setUpHeaderView(nil)
        canValidate = false
        for cell in productCells {
            if cell.returnOrder.isSelected {
                canValidate = true
                break
            }
        }
        
        if let cell = self.tableView.cellForRow(at: NSIndexPath(row: 0, section: 2) as IndexPath) as? ReturnOrderValidationCell {
            cell.setUpCell(canValidate: canValidate)
        }
        
    }
    
    @objc func setUpHeaderView(_ view : UIView?) {
        UIView.transition(with: self.tableView, duration: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.tableView.tableHeaderView = view
        }) { (success) in }
    }
    
    @IBAction func validate() {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kValidationRetourCommande,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kMyOrders,
                                                              chapter2: TaggingData.kOrderDetails,
                                                              level2: TaggingData.kAccountLevel)
        
        hidePicker()
        var productsToReturn = [ReturnOrderModel]()
        var hasError = false
        var didScrollToError = false
        for cell in productCells {
            Logger.shared.debug("Verify  Cell")
            let result = cell.validate()
            if let product = result.0 {
                productsToReturn.append(product)
            }
            if result.1 {
                hasError = true
                if didScrollToError == false {
                    didScrollToError = true
                    if let index = productCells.firstIndex(of: cell)
                    {
                        let indexPath = NSIndexPath(row: index, section: 1)
                        tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                    }
                }
                
            }
        }
        if hasError {
            Logger.shared.debug("Error missing data")
//            if let messageView = TopMessageView.instanceFromNib() as? TopMessageView {
//                messageView.setView(title: "Champ obligatoire", message: "Merci de remplir tous les champs", type: .info)
//                self.setUpHeaderView(messageView)
//                self.perform(#selector(setUpHeaderView(_:)), with: nil, afterDelay: 3.0)
//            }
            
            // Error missing data
        } else if productsToReturn.count == 0 {
            // No Product selected (never called after changing validation conditions)
            Logger.shared.debug("No Product selected")
        } else {
            // Call WS
            viewModel?.callClaimOrder(products: productsToReturn, callback: { (errorProducts, success) in
                if success {
                    
                    if let parentViewController = self.presentingViewController as? UINavigationController {
                        self.dismiss(animated: true, completion: {
                            if let messageView = TopMessageView.instanceFromNib() as? TopMessageView {
                                
                                let message = self.viewModel?.getSuccessAttributedStringForMessageView(primaryFont: messageView.messageLabel.font, secondaryFont: messageView.titleLabel.font) ?? NSAttributedString()
                                
                                messageView.setView(message: message, type: .success)
                                let originY =  UIApplication.shared.statusBarFrame.size.height + parentViewController.navigationBar.frame.height
                                messageView.showInView(parentViewController.view, fromY: originY)
                            }
                        })
                    }
                } else {
                    self.tableView.setContentOffset(.zero, animated: true)
                    if let messageView = TopMessageView.instanceFromNib() as? TopMessageView {
                        messageView.setView(title: "Service indisponible", message: "Veuillez réessayer ultérieurement.", type: .error)
                        self.setUpHeaderView(messageView)
                        self.perform(#selector(self.setUpHeaderView(_:)), with: nil, afterDelay: 3.0)
                    }
                    // What to do for errors
                }
            })

        }
    }
    
    func showMessageError() {
        
    }
    
    @IBAction func dissmissClicked(_ sender: Any) {
        hidePicker()
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ReturnOrderViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return returnOrderRows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnOrderRows[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = returnOrderRows[indexPath.section][indexPath.row]
        switch item {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath)
            return cell
            
        case .product:
            
            let cell = productCells[indexPath.row]
            
            let product = self.products[indexPath.row]
            cell.setUpCell(order: product)
            cell.delegate = self
            return cell
            
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as? ReturnOrderValidationCell
            cell?.setUpCell(canValidate: canValidate)
            return cell!
        }
        

    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _cell = cell as? ReturnOrderProductCell {
            _cell.hidePickerView()
        }
    }
}

extension ReturnOrderViewController : ReturnOrderProductCellDelegate {
    
    func updateReturnOrder(_ returnOrder: ReturnOrderModel) {
        if let row = self.products.index(where: {$0.refLabel == returnOrder.refLabel}) {
            products[row] = returnOrder
        }
    }
    
    func updateCell(_ cell: ReturnOrderProductCell, height: CGFloat, isHidden : Bool) {
        if let row = self.products.index(where: {$0.refLabel == cell.returnOrder.refLabel}) {
            products[row] = cell.returnOrder
        }
        tableView.beginUpdates()
        cell.descriptionHeightLayoutConstraint.constant = height
//        cell.descriptionView.isHidden = isHidden
        tableView.endUpdates()
        
        setValidateButton()
    }
}
