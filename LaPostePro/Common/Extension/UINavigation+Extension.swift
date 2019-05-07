//
//  UINavigation+Extension.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 23/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

extension UIViewController {
    // MARK: Setup differente NavigationBar Appearance    
    func setupLogoNavigationBar() {
        self.hideNavigationBarBorder()
        let profileBarButton = self.createBarButtonItem(image: R.image.profile(), action: #selector(UINavigationController.redirectToProfile))
        addRightBarButtonToNavegation()
        let profileBarLabel = self.addProfileLabel(name: "Mon \nCompte")
        let logoView = self.addLogo()
        
        self.navigationItem.setLeftBarButtonItems([profileBarButton, profileBarLabel], animated: false)
        self.navigationItem.titleView = logoView
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    
    func setupLogoNavigationBarModal() {
        self.hideNavigationBarBorder()
        let closeButton = self.createBarButtonItem(image: R.image.ic_close(), value:"", action: #selector(UINavigationController.dismissModal))
        self.navigationItem.setRightBarButtonItems([closeButton], animated: false)
        let logoView = self.addLogo()
        self.navigationItem.titleView = logoView
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    func setupTitleNavigationBarOrder(backEnabled: Bool, title: String)
    {
        self.hideNavigationBarBorder()
        let profileBarButton = self.createBarButtonItem(image: R.image.profile(), action: #selector(UINavigationController.redirectToProfile))
        
        let searchBarButton = self.createBarButtonItem(image: R.image.ic_navbar_search(), action: #selector(UINavigationController.redirectToSearchOrder))
        
        self.navigationItem.setRightBarButtonItems([searchBarButton], animated: false)
        
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        tlabel.text = title
        tlabel.numberOfLines = 1
        tlabel.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        tlabel.backgroundColor = UIColor.clear
        tlabel.textAlignment = .center
        tlabel.textColor = .lpDeepBlue
        tlabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.navigationItem.titleView = tlabel
        
        if backEnabled {
            self.navigationItem.setLeftBarButtonItems([], animated: false)
            self.navigationItem.setHidesBackButton(!backEnabled, animated: false)
            self.navigationController?.navigationBar.tintColor = .lpGrey
            
        } else {
            self.navigationItem.setHidesBackButton(!backEnabled, animated: false)
            self.navigationItem.setLeftBarButtonItems([profileBarButton], animated: false)
        }
    }
    
    
    
    func setupTitleNavigationBarListProduct(backEnabled: Bool, title: String, showCart: Bool = true) {
        self.hideNavigationBarBorder()
        let profileBarButton = self.createBarButtonItem(image: R.image.profile(), action: #selector(UINavigationController.redirectToProfile))
        
        let searchBarButton = self.createBarButtonItem(image: R.image.ic_navbar_search(), action: #selector(UINavigationController.redirectToSearchShop))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = 16.0
        
        if showCart {
            var items:  [UIBarButtonItem] = []
            var index: Int = 0
            if let numberOfProductInCart = CartViewModel.sharedInstance.productTotalCountInCart, numberOfProductInCart > 0 {
                if numberOfProductInCart >= 100 {
                    items = [searchBarButton, searchBarButton]
                    index = 1
                } else {
                    items = [space, searchBarButton]
                    index = 0
                }
            } else {
                items = [space, searchBarButton]
                index = 0
            }
            addRightBarButtonToNavegation(items, at: index)
        }
        
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        tlabel.text = title
        tlabel.numberOfLines = 1
        tlabel.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        tlabel.backgroundColor = UIColor.clear
        tlabel.textAlignment = .center
        tlabel.textColor = .lpDeepBlue
        tlabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.navigationItem.titleView = tlabel
        
        if backEnabled {
            self.navigationItem.setLeftBarButtonItems([], animated: false)
            self.navigationItem.setHidesBackButton(!backEnabled, animated: false)
            self.navigationController?.navigationBar.tintColor = .lpGrey
            
        } else {
            self.navigationItem.setHidesBackButton(!backEnabled, animated: false)
            self.navigationItem.setLeftBarButtonItems([profileBarButton], animated: false)
        }
    }
    
    func setupTitleNavigationBar(backEnabled: Bool, title: String, showCart: Bool = true) {
        self.hideNavigationBarBorder()
        let profileBarButton = self.createBarButtonItem(image: R.image.profile(), action: #selector(UINavigationController.redirectToProfile))
        if showCart {
            addRightBarButtonToNavegation()
        }
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        tlabel.text = title
        tlabel.numberOfLines = 1
        tlabel.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        tlabel.backgroundColor = UIColor.clear
        tlabel.textAlignment = .center
        tlabel.textColor = .lpDeepBlue
        tlabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.navigationItem.titleView = tlabel
        
        if backEnabled {
            self.navigationItem.setLeftBarButtonItems([], animated: false)
            self.navigationItem.setHidesBackButton(!backEnabled, animated: false)
            self.navigationController?.navigationBar.tintColor = .lpGrey
            
        } else {
            self.navigationItem.setHidesBackButton(!backEnabled, animated: false)
            self.navigationItem.setLeftBarButtonItems([profileBarButton], animated: false)
        }
    }
    
    func setupModalNavigationBar(title: String, image: UIImage? = nil, text: String? = nil, leftBarButtom: Bool = true) {
        self.hideNavigationBarBorder()
        
        var closeBarButton = UIBarButtonItem()
        if(image != nil) {
            closeBarButton = self.createBarButtonItem(image: image!, action: #selector(UINavigationController.dismissModal))
        }
        else if (text != nil) {
            closeBarButton = self.createBarButtonItem(image: nil, value: text!, action: #selector(UINavigationController.dismissModal))
        }
        
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        tlabel.text = title
        tlabel.numberOfLines = 1
        tlabel.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        tlabel.backgroundColor = UIColor.clear
        tlabel.textAlignment = .center
        tlabel.textColor = .lpDeepBlue
        tlabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.navigationItem.titleView = tlabel
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        if leftBarButtom {
            self.navigationItem.setLeftBarButtonItems([closeBarButton], animated: false)
        } else {
            self.navigationItem.setRightBarButtonItems([closeBarButton], animated: false)
        }
    }
    
    
    func setupSearchNavigationBar(text: String, delegate: UISearchBarDelegate) {
        self.hideNavigationBarBorder()
        let profileBarButton = self.createBarButtonItem(image: R.image.profile(), action: #selector(UINavigationController.redirectToProfile))
        addRightBarButtonToNavegation()
        let searchBar = self.addSearchBar(text: text, delegate: delegate)
        self.navigationItem.titleView = searchBar
        self.navigationItem.setLeftBarButtonItems([profileBarButton], animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    
    
    func setupSearchNavigationBar(searchBar: UISearchBar) {
        self.hideNavigationBarBorder()
        let profileBarButton = self.createBarButtonItem(image: R.image.profile(), action: #selector(UINavigationController.redirectToProfile))
        addRightBarButtonToNavegation()
        //        let searchBar = self.addSearchBar(text: text, delegate: delegate)
        self.navigationItem.titleView = searchBar
        self.navigationItem.setLeftBarButtonItems([profileBarButton], animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    
    // MARK: Appearance Methods
    private func createBarButtonItem(image: UIImage?, value: String, action: Selector) -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.tintImageColor(color: .gray)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        // Add cartButtonCountLabel
        
        let cartButtonCountLabel: UILabel = UILabel()
        cartButtonCountLabel.textAlignment = .center
        cartButtonCountLabel.textColor = .lpPurple
        cartButtonCountLabel.text = String(describing: value)
        cartButtonCountLabel.font = UIFont.boldSystemFont(ofSize: 10)
        cartButtonCountLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(cartButtonCountLabel)
        
        NSLayoutConstraint.activate([
            cartButtonCountLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            cartButtonCountLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 3)
            ])
        
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    func createBarButtonItem(image: UIImage?, action: Selector) -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.tintImageColor(color: .gray)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private func addLogo() -> UIView {
        let logoImg: UIImageView = UIImageView(image: UIImage(named: "logo"))
        logoImg.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return logoImg
    }
    
    @objc private func dismissModal() {
        if (navigationController?.viewControllers.last?.isKind(of: PaymentConfirmationViewController.self))! {
            let mainTabBarViewController =  self.presentingViewController as! MainTabBarViewController
            let navC = mainTabBarViewController.selectedViewController as! UINavigationController
            self.dismiss(animated: true, completion: {
                navC.popToRootViewController(animated: false)
                mainTabBarViewController.selectedIndex = TabBarItem.home.rawValue
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func addProfileLabel(name: String) -> UIBarButtonItem {
        let profileLbl: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        profileLbl.text = name
        profileLbl.textColor = .lpPurple
        profileLbl.font = UIFont.boldSystemFont(ofSize: 15)
        profileLbl.numberOfLines = 2
        profileLbl.isUserInteractionEnabled = true
        profileLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UINavigationController.redirectToProfile)))
        return UIBarButtonItem(customView: profileLbl)
    }
    
    private func addSearchBar(text: String, delegate: UISearchBarDelegate) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = text
        searchBar.isTranslucent = true
        //        searchBar.text = text
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = delegate
        NSLayoutConstraint.activate([
            searchBar.widthAnchor.constraint(equalToConstant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 0)
            ])
        return searchBar
    }
    
    private func hideNavigationBarBorder() {
        //remove line because it make navigation bar transparent. APPPRO-603
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: NavigationBar Actions
    @objc private func redirectToCart() {
        if !(navigationController?.viewControllers.last?.isKind(of: CartViewController.self))!,
            let cartVC = R.storyboard.cart.cartViewControllerID() {
            let navigationController = UINavigationController(rootViewController: cartVC)
            self.present(navigationController, animated: true, completion: nil)
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCart , pageName: nil, chapter1: TaggingData.kHeader, chapter2: nil, level2: TaggingData.kTransverseLevel)
        }
    }
    
    @objc private func redirectToSearchOrder() {
        let navigationViewController = R.storyboard.search.instantiateInitialViewController()!
        let searchViewController = navigationViewController.viewControllers[0] as! SearchViewController
        searchViewController.searchType = .order
        searchViewController.openerViewController = self
        self.present(navigationViewController, animated: true)
    }
    
    @objc private func redirectToSearchShop() {
        let navigationViewController = R.storyboard.search.instantiateInitialViewController()!
        let searchViewController = navigationViewController.viewControllers[0] as! SearchViewController
        searchViewController.searchType = .shop
        searchViewController.openerViewController = self
        self.present(navigationViewController, animated: true)
    }
    
    
    @objc private func redirectToProfile() {
        let accountHomeViewController = R.storyboard.account.accountHomeViewControllerID()!
        let navigationController = UINavigationController(rootViewController: accountHomeViewController)
        self.present(navigationController, animated: true, completion: nil)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kMonCompte , pageName: nil, chapter1: TaggingData.kHeader, chapter2: nil, level2: TaggingData.kTransverseLevel)
    }
    
    func updateCartButtonItem() {
        addRightBarButtonToNavegation()
    }
    
    private func addRightBarButtonToNavegation(_ items: [UIBarButtonItem]? = nil, at index: Int = 0) {
        var numberOfProduct: String = ""
        if let numberOfProductInCart = CartViewModel.sharedInstance.productTotalCountInCart, numberOfProductInCart > 0 {
            if numberOfProductInCart >= 100 {
                numberOfProduct = "99+"
            } else {
                numberOfProduct = String(describing: numberOfProductInCart)
            }
        } else {
            numberOfProduct = ""
        }
        let cartBarButton = self.createBarButtonItem(image: R.image.cart(), value: numberOfProduct,
                                                     action: #selector(UINavigationController.redirectToCart))
        var rightItems: [UIBarButtonItem] = items ?? []
        rightItems.insert(cartBarButton, at: index)
        
        if let rootViewController = self.navigationController?.viewControllers.first,
            rootViewController is CartViewController {
            Logger.shared.debug("it shouldn't to add rightBarButtons in the CartViewController")
        } else {
            self.navigationItem.setRightBarButtonItems(rightItems, animated: false)
        }
    }
    
    func presentRightTransition(_ viewControllerToPresent: UIViewController , onCompletion: @escaping () -> ()) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(viewControllerToPresent, animated: false) {
            onCompletion()
        }
    }
    
    func dismissLeftTransition() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
    
    func gotoHome() {
        guard let mainTabBarViewController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController,
            let navC = mainTabBarViewController.viewControllers?.first as? UINavigationController else {
                return
        }
        mainTabBarViewController.dismiss(animated: true) {
            navC.popToRootViewController(animated: false)
            mainTabBarViewController.selectedIndex = TabBarItem.home.rawValue
        }
    }
}

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
