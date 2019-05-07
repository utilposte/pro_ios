//
//  ClaimOrderViewController.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 11/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ClaimOrderViewController: BaseViewController {

    var viewModel : ReturnOrderViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    var productCells = [ClaimOrderProductCell]()
    var claimOrderRows = [[ClaimOrderRow]]()
    var canValidate     = false
    var currentProduct : ReturnOrderModel? {
        didSet {
            canValidate = (currentProduct != nil)
            if let cell = self.tableView.cellForRow(at: NSIndexPath(row: 0, section: 2) as IndexPath) as? ReturnOrderValidationCell {
                cell.setUpCell(canValidate: canValidate)
            }
        }
    }
    
    enum ClaimOrderRow {
        case header
        case subHeader
        case product
        case footer

        var cellIdentifier : String {
            switch self {
            case .header:
                return R.reuseIdentifier.claimOrderHeaderCell.identifier
            case .subHeader:
                return R.reuseIdentifier.claimOrderSubHeaderCell.identifier
            case .product:
                return R.reuseIdentifier.claimOrderProductCell.identifier
            case .footer :
                return R.reuseIdentifier.claimOrderFooterCell.identifier

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.loaderManager.showLoderView()
        viewModel?.configureData(callback: { (result) in
            self.viewModel?.loaderManager.hideLoaderView()
            if result.count > 0 {
//                self.waitingView.isHidden = true
                self.initData(products: result)
            }
            else {
                self.dismiss(animated: true, completion: {
                    if let messageView = TopMessageView.instanceFromNib() as? TopMessageView {
                        messageView.setView(title: "Service indisponible", message: "Veuillez réessayer ultérieurement.", type: .error)
                        let originY =  UIApplication.shared.statusBarFrame.size.height + (self.presentingViewController?.navigationController?.navigationBar.frame.height ?? 0)
                        let window = UIApplication.shared.windows.first
                        messageView.showInView(window!, fromY: originY)
//                        messageView.perform(#selector(TopMessageView.closeView), with: nil, afterDelay: 3.0)
                    }
                })
                // Back With Error
            }
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kContactUs,
                                                             chapter1: TaggingData.kMyOrders,
                                                             chapter2: nil,
                                                             level2: TaggingData.kAccountLevel)
        
    }
    
    func initData(products : [ReturnOrderModel]) {
        productCells = [ClaimOrderProductCell]()
        claimOrderRows = [[ClaimOrderRow]]()
        claimOrderRows.append([ClaimOrderRow]())
        claimOrderRows[0].append(.header)
        claimOrderRows[0].append(.subHeader)
        claimOrderRows.append([ClaimOrderRow]())
        for product in  products {
            if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.claimOrderProductCell.identifier) as? ClaimOrderProductCell {
                cell.returnOrder = product
                cell.isOneProduct = (products.count == 1)
                productCells.append(cell)
                claimOrderRows[1].append(.product)
            }
        }
        claimOrderRows.append([ClaimOrderRow]())
        claimOrderRows[2].append(.footer)
        tableView.reloadData()
//        setValidateButton()
    }
    
    func hidePicker() {
        for cell in productCells {
            cell.hidePickerView()
        }
    }
    
    @IBAction func dissmissClicked(_ sender: Any) {
        hidePicker()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callClaimButtonClicked() {
        hidePicker()
        self.view.endEditing(true)
        guard let productToReturn = currentProduct else {
            return
        }
        let productsToReturn = [productToReturn]
        viewModel?.callClaimOrder(products: productsToReturn, callback: { (errorProducts, success) in
            if success {
                if let parentViewController = self.presentingViewController as? UINavigationController {
                    self.dismiss(animated: true, completion: {
                        if let messageView = TopMessageView.instanceFromNib() as? TopMessageView {
                            
                            let message = self.viewModel?.getClaimSuccessAttributedStringForMessageView(primaryFont: messageView.messageLabel.font, secondaryFont: messageView.titleLabel.font) ?? NSAttributedString()
                            
                            messageView.setView(message: message, type: .success)
                            let originY =  UIApplication.shared.statusBarFrame.size.height + parentViewController.navigationBar.frame.height
                            messageView.showInView(parentViewController.view, fromY: originY)
                        }
                    })
                }
            }
            else {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func setUpHeaderView(_ view : UIView?) {
        UIView.transition(with: self.tableView, duration: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.tableView.tableHeaderView = view
        }) { (success) in }
    }
}

extension ClaimOrderViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return claimOrderRows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return claimOrderRows[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = claimOrderRows[indexPath.section][indexPath.row]
        switch item {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath)
            return cell
        case .subHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath)
            return cell
        case .product:
            let cell = productCells[indexPath.row]
            cell.delegate = self
            cell.setUpCell()
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

extension ClaimOrderViewController : ClaimOrderProductCellDelegate {
    func updateCell(_ cell: ClaimOrderProductCell, action: Selector) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        cell.perform(action)
        tableView.endUpdates()
    }
    
    func updateReturnOrder(_ returnOrder: ReturnOrderModel) {
        // Desactivate all other Cells
        currentProduct = viewModel?.validatePorduct(returnOrder)
        for cell in productCells {
            if cell.returnOrder.refLabel != returnOrder.refLabel {
                cell.returnOrder.isSelected = false
                cell.setUpCell()
            }
        }
    }
}
