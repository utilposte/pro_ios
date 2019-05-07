//
//  HistoryOrdersViewController.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 28/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

class HistoryOrdersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel = OrderViewModel()
    var orders : (sections:[String], datas:[[HYBOrderHistory]]) = (sections:[String](), datas:[[HYBOrderHistory]]())
    var noResult = false
    var searchString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleNavigationBarOrder(backEnabled: true, title: "Commandes")
        //self.setupTitleNavigationBar(backEnabled: true, title: "Commandes", showCart: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kHome,
                                                             chapter1: TaggingData.kMyOrders,
                                                             chapter2: nil,
                                                             level2: TaggingData.kAccountLevel)
        
        if searchString != "" {
            self.loadOrders()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadOrders() {
        if searchString != "" {
            self.setupTitleNavigationBarOrder(backEnabled: true, title: "Recherche: \(searchString)")
            self.viewModel.getOrdersSearch(searchString: searchString, completion:
                { orders in
                    if (orders != nil) {
                        self.orders = orders!
                    }
                    if self.orders.sections.count == 0 {
                        self.noResult = true
                    }
                    self.tableView.reloadData()
            })

        }
        else {
            self.viewModel.getOrders(completion: { orders in
                if (orders != nil) {
                    self.orders = orders!
                }
                if self.orders.sections.count == 0 {
                    self.noResult = true
                }
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func goToEBoutique(_ sender: Any) {
        let referenceForTabBarController = self.presentingViewController as! UITabBarController
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: {
            referenceForTabBarController.selectedIndex = TabBarItem.eBoutique.rawValue
        })
    }
    
}

extension HistoryOrdersViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.noResult {
            return 3
        }
        if section >= self.orders.sections.count {
            return 1
        }
        return orders.datas[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.noResult {
            return 1
        }

        if viewModel.finished {
            return orders.datas.count
        }
        return orders.datas.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if noResult {
            if indexPath.row == 0 {
                return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.noOrderCell, for: indexPath)!
            }
            else if (indexPath.row == 1) {
                return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderButtunCell, for: indexPath)!
            }
            else if (indexPath.row == 2) {
                return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderAdsCell, for: indexPath)!
            }
        }

        if indexPath.section >= self.orders.sections.count {
            loadOrders()
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.loaderCell, for: indexPath)!
        }
        

        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderTableViewCell, for: indexPath)
        let order = orders.datas[indexPath.section][indexPath.row]
        cell?.refLabel.text = "Commande n° \(order.code ?? "")"
        cell?.priceLabel.text = order.total.formattedValue
        cell?.dateLabel.text = order.placed.getDate().format("dd LLLL YYYY")
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if noResult {
            return
        }
        let order = orders.datas[indexPath.section][indexPath.row]
        viewModel.getOrderDetail(code: order.code) { order in
            if order != nil {
                let viewController = R.storyboard.order.orderDetailViewController()!
                viewController.viewModel = self.viewModel
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if noResult {
            if indexPath.row == 0 {
                return 365
            }
            else if (indexPath.row == 1) {
                return 70
            }
            else if (indexPath.row == 2) {
                return 160
            }
        }
        return 115
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if noResult {
            return nil
        }
        let view = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.orderSectionTableViewCell.identifier) as! OrderSectionTableViewCell
        if section >= self.orders.sections.count {
            view.monthLabel.text = "Chargment..."
            view.numberLabel.text = ""
            return view
        }
        view.monthLabel.text = self.orders.sections[section]
        
        let numberOrder = self.orders.datas[section].count
        if numberOrder > 1 {
            view.numberLabel.text = "\(numberOrder) commandes"
        }
        else {
            view.numberLabel.text = "\(numberOrder) commande"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if noResult {
            return 0
        }
        return 44
    }
}




