//
//  BaseViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 11/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

enum WebViewURL: String {
    case infoLiberte = "https://www.laposte.fr/professionnel/informatique-et-libertes"
    case contact = "https://aide.laposte.fr/professionnel/contact/"
    case contact3 = "https://aide.laposte.fr/professionnel/contact/?path=0-1-12"
    case pro = "https://aide.laposte.fr/professionnel/"
    case conditionGeneral = "https://www.laposte.fr/professionnel/conditions-generales"
    case dangereux = "https://www.laposte.fr/courriers-colis/conseils-pratiques/marchandises-dangereuses-interdites"
    case validation = "https://aide.laposte.fr/professionnel/contact/?path=0-1-10"
    case chorus = "https://communaute-chorus-pro.finances.gouv.fr"
}

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHeader), name: NSNotification.Name(rawValue: "update_cart"), object: nil)

        if tabBarController?.selectedIndex == TabBarItem.home.rawValue {
            NotificationCenter.default.addObserver(self, selector: #selector(self.showCartDeepLink), name: NSNotification.Name("laposte.deeplink.showcart"), object: nil)
        }

        if tabBarController?.selectedIndex == TabBarItem.home.rawValue {
            NotificationCenter.default.addObserver(self, selector: #selector(self.showOrdersDeepLink), name: NSNotification.Name("laposte.deeplink.showorders"), object: nil)
        }
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let navigationController: UINavigationController = self.tabBarController!.selectedViewController as! UINavigationController
//        if let homeViewController = navigationController.topViewController as? HomeViewController {
//            //homeViewController.createTableViewDataSource()
//            //homeViewController.tableView.reloadData()
//        }
//    }

    @objc func updateHeader() {
        self.updateCartButtonItem()
    }

    @objc func showCartDeepLink() {
        self.tabBarController?.selectedIndex = TabBarItem.home.rawValue
        if let _ = self.navigationController?.presentedViewController {
            self.dismiss(animated: false) {
                let navigationController = UINavigationController(rootViewController: R.storyboard.cart.cartViewControllerID()!)
                self.present(navigationController, animated: false, completion: nil)
            }
        } else {
            self.navigationController?.popToRootViewController(animated: false)
            let navigationController = UINavigationController(rootViewController: R.storyboard.cart.cartViewControllerID()!)
            self.present(navigationController, animated: true, completion: nil)
        }
    }

    @objc func showCart() {
        self.tabBarController?.selectedIndex = TabBarItem.home.rawValue
        if let _ = self.navigationController?.presentedViewController {
            self.dismiss(animated: false) {
                let navigationController = UINavigationController(rootViewController: R.storyboard.cart.cartViewControllerID()!)
                self.present(navigationController, animated: true, completion: nil)
            }
        } else {
            let navigationController = UINavigationController(rootViewController: R.storyboard.cart.cartViewControllerID()!)
            self.present(navigationController, animated: false, completion: nil)
        }
    }

    @objc func showOrdersDeepLink() {
        self.tabBarController?.selectedIndex = TabBarItem.home.rawValue
        if let _ = self.navigationController?.presentedViewController {
            self.dismiss(animated: false) {
                self.navigationController?.pushViewController(R.storyboard.order.historyOrdersViewController()!, animated: false)
            }
        } else {
            self.navigationController?.popToRootViewController(animated: false)
            self.navigationController?.pushViewController(R.storyboard.order.historyOrdersViewController()!, animated: false)
        }
    }
}

extension BaseViewController: FooterDelegate {
    func callCustomerService() {}

    func needHelpTapped() {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! WebViewController
        vc.webViewType = .needHelp
        vc.url = WebViewURL.pro.rawValue
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
