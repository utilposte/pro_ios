//
//  ColissimoViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 19/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPColissimo
import LPColissimoUI
import LPSharedMCM

class ColissimoViewController: UIViewController {
    
    var containsColissimo: Bool = false
    let colissimoTitle = "Affranchir un Colissimo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = colissimoTitle
        ColissimoManager.sharedManager.delegate = self
        if let accessToken = UserAccount.shared.accessToken {
            ColissimoManager.sharedManager.accessToken = "Bearer " + accessToken
        }
        let url = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost()
        ColissimoAPIClient.sharedInstance.baseUrl = url
        Logger.shared.debug("👀  \(#function) 👀BASE URL \( ColissimoManager.sharedManager.baseUrl )");
        openColissimo(containsColissimo: self.containsColissimo)
        self.createBarButtonItem(self, isHome: true)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
    }
    
    func createBarButtonItem(_ viewController: UIViewController, isHome: Bool = false) {
        let selector = isHome ? #selector(ColissimoViewController.goBack) : #selector(ColissimoViewController.leaveColissimo)
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ic_close"), style: .plain, target: self, action: selector)
        viewController.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func senderFormDidCallAuthentification(){
        //
    }
    
    @IBAction func openColissimo(containsColissimo: Bool) {
        let containsColissimo = CartViewModel.sharedInstance.cartContainColissimo()
        let vc = ColissimoManager.sharedManager.getColissimoHomeViewController(containsColissimo: containsColissimo)
        self.displayContentController(content: vc)
    }
    
    func displayContentController(content: UIViewController) {
        addChildViewController(content)
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
}

extension ColissimoViewController: ColissimoManagerDelegate {
    func step6ViewDidCallPrice() {
        let vc = ColissimoManager.sharedManager.getColissimoSixthStepPriceViewController() as! SixthStepPriceViewController
        vc.title = colissimoTitle
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: true, completion: nil)
        self.createBarButtonItem(vc)
    }
    
    func redirectToCart() {
        CATransaction.setCompletionBlock {
            VibrationHelper.addToCart()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Colissimo.Home.Cart"), object: nil)
        }
        CATransaction.begin()
        self.dismiss(animated: false) { }
        CATransaction.commit()
    }
    
    func customFormalitiesDidCallMoreInfo(url: String) {
        let vc: CLWebViewController = ColissimoManager.sharedManager.getMoreInfoWebView() as! CLWebViewController
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
        self.createBarButtonItem(vc)
    }
    
    func setUpNavigationItem(navigationItem: UINavigationItem) {
        
    }
    
    func didCallFormalities(){
        let vc : CustomFormalitiesViewController = ColissimoManager.sharedManager.getColissimoFormalities() as! CustomFormalitiesViewController
//        vc.data = data
        vc.title = colissimoTitle
        self.navigationController?.pushViewController(vc, animated: false)
        self.createBarButtonItem(vc)
    }
    
    func didCallRecap(){
        let vc : CLRecapViewController = ColissimoManager.sharedManager.getColissimoRecap() as! CLRecapViewController
        vc.title = colissimoTitle
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func homeViewDidCallStep1With() {
        let vc = ColissimoManager.sharedManager.getColissimoStepViewController() as! FirstStepViewController
//        vc.data = tmpdData
        vc.title = colissimoTitle
        self.navigationController?.pushViewController(vc, animated: false)
        self.createBarButtonItem(vc)
    }
    
    func homeViewDidCallDirectlyRecap(containsFormalities: Bool, step: Int) {
        
        let secondViewController = ColissimoManager.sharedManager.getDimensionViewController()
        self.createBarButtonItem(secondViewController)
        let thirdViewController = ColissimoManager.sharedManager.getColissimoThirdStepViewController()
        self.createBarButtonItem(thirdViewController)
        let formalitiesViewController = ColissimoManager.sharedManager.getColissimoFormalities()
        self.createBarButtonItem(formalitiesViewController)
        let fourthViewController = ColissimoManager.sharedManager.getSenderForm(isConnected: true)
        self.createBarButtonItem(fourthViewController)
        let fifthViewController = ColissimoManager.sharedManager.getReceiverForm(isConnected: true)
        self.createBarButtonItem(fifthViewController)
        let sixthViewController = ColissimoManager.sharedManager.getColissimoSixthStepViewController()
        self.createBarButtonItem(sixthViewController)
        let recapViewController = ColissimoManager.sharedManager.getColissimoRecap()
        
        // MARK: CLEAN THIS SHIT ONE DAY
        
        /**** step: Int -> Informations
         * 1 -> First Step (departure, arrival)
         * 2 -> Second Step (dimension)
         * 3 -> Third Step (weight)
         * 4 -> Fourth Step (form sender)
         * 5 -> Fifth Step (form receiver)
         * 6 -> Sixth Step (delivery, deposite)
         ****/
        
        switch step {
        case 1:
            self.navigationController?.pushViewController(secondViewController, animated: false)
            self.navigationController?.pushViewController(thirdViewController, animated: false)
            if containsFormalities {
                self.navigationController?.pushViewController(formalitiesViewController, animated: false)
            }
            self.navigationController?.pushViewController(fourthViewController, animated: false)
            self.navigationController?.pushViewController(fifthViewController, animated: false)
            self.navigationController?.pushViewController(sixthViewController, animated: false)
            self.navigationController?.pushViewController(recapViewController, animated: false)
        case 2:
            self.navigationController?.pushViewController(thirdViewController, animated: false)
            if containsFormalities {
                self.navigationController?.pushViewController(formalitiesViewController, animated: false)
            }
            self.navigationController?.pushViewController(fourthViewController, animated: false)
            self.navigationController?.pushViewController(fifthViewController, animated: false)
            self.navigationController?.pushViewController(sixthViewController, animated: false)
            self.navigationController?.pushViewController(recapViewController, animated: false)
        case 3:
            if containsFormalities {
                self.navigationController?.pushViewController(formalitiesViewController, animated: false)
            }
            self.navigationController?.pushViewController(fourthViewController, animated: false)
            self.navigationController?.pushViewController(fifthViewController, animated: false)
            self.navigationController?.pushViewController(sixthViewController, animated: false)
            self.navigationController?.pushViewController(recapViewController, animated: false)
        case 4:
            self.navigationController?.pushViewController(fourthViewController, animated: false)
            self.navigationController?.pushViewController(fifthViewController, animated: false)
            self.navigationController?.pushViewController(sixthViewController, animated: false)
            self.navigationController?.pushViewController(recapViewController, animated: false)
        case 5:
            self.navigationController?.pushViewController(fifthViewController, animated: false)
            self.navigationController?.pushViewController(sixthViewController, animated: false)
            self.navigationController?.pushViewController(recapViewController, animated: false)
        case 6:
            self.navigationController?.pushViewController(sixthViewController, animated: false)
            self.navigationController?.pushViewController(recapViewController, animated: false)
        default:
            break
        }
        
        self.createBarButtonItem(recapViewController)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true) { }
    }
    
    @objc func leaveColissimo() {
        let alertController: UIAlertController = UIAlertController(title: "Êtes-vous sûr de vouloir quitter le parcours ?", message: nil, dismissActionTitle: "Annuler") { }
        let alertAction: UIAlertAction = UIAlertAction(title: "Oui", style: .default) { (action) in
            self.goBack()
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true) { }
    }
    
    func homeViewDidCallStep2With() {
        let vc : ColissimoDimensionViewController = ColissimoManager.sharedManager.getDimensionViewController() as! ColissimoDimensionViewController
//        vc.data = tmpdData
        vc.title = colissimoTitle
        self.navigationController?.pushViewController(vc, animated: true)
        self.createBarButtonItem(vc)
    }
    
    
    func homeViewDidCallStep3With() {
        let vc = ColissimoManager.sharedManager.getColissimoThirdStepViewController() as! ThirdStepViewController
        vc.title = colissimoTitle
        self.navigationController?.pushViewController(vc, animated: true)
        self.createBarButtonItem(vc)
    }
    
    func didCallSenderForm() {
        let vc : CLSenderViewController = ColissimoManager.sharedManager.getSenderForm(isConnected: true) as! CLSenderViewController
        let address = LPAddressValidationService.configureLPAddress(fromUserAccount: MCMManager.sharedInstance()?.user)
        var userAccountDictionnary: [String: Any] = [:]
        userAccountDictionnary["civility"] = UserAccount.shared.customerInfo?.titleCode
        userAccountDictionnary["firstName"] = UserAccount.shared.customerInfo?.firstName
        userAccountDictionnary["lastName"] = UserAccount.shared.customerInfo?.lastName
        userAccountDictionnary["companyName"] = UserAccount.shared.customerInfo?.companyName
        userAccountDictionnary["street"] = UserAccount.shared.customerInfo?.defaultAddress?.line2
        userAccountDictionnary["postalCode"] = UserAccount.shared.customerInfo?.defaultAddress?.postalCode
        userAccountDictionnary["city"] = UserAccount.shared.customerInfo?.defaultAddress?.town
        userAccountDictionnary["country"] = UserAccount.shared.customerInfo?.defaultAddress?.country?.name
        userAccountDictionnary["phone"] = UserAccount.shared.customerInfo?.phone
        userAccountDictionnary["email"] = UserAccount.shared.customerInfo?.displayUid
        
        vc.address = address
        vc.userAccountDictionnary = userAccountDictionnary
//        vc.data = data
        vc.title = colissimoTitle
        vc.isPro = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.createBarButtonItem(vc)
    }
    
    func didCallReceiverForm(){
        let vc : CLReceiverViewController = ColissimoManager.sharedManager.getReceiverForm(isConnected: true) as! CLReceiverViewController
        vc.title = colissimoTitle
        vc.isPro = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.createBarButtonItem(vc)
    }
    
    func homeViewDidCallStep6With() {
        let vc = ColissimoManager.sharedManager.getColissimoSixthStepViewController() as! SixthStepViewController
        vc.title = colissimoTitle
        self.navigationController?.pushViewController(vc, animated: true)
        self.createBarButtonItem(vc)
    }
    
    func getFooterView() -> UIView {
        let footerView = FooterView().initFooterView()
        footerView.delegate = self
        return footerView
    }
}

extension ColissimoViewController: FooterDelegate {
    func callCustomerService() {}
    
    func needHelpTapped() {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! WebViewController
        vc.webViewType = .needHelp
        vc.url = WebViewURL.pro.rawValue
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
