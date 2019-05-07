//
//  CLSenderViewController.swift
//  AFNetworking
//
//  Created by LaPoste on 26/11/2018.
//

import UIKit
@objc protocol CLSenderDataSource{
    @objc optional func isConnected()->Bool
}
public class CLSenderViewController: UIViewController {
    
    var lpAddressVC : LPAddressViewController!
    public var address : LPAddressEntity!
    public var isConnected :  Bool = false
    var contentArray :  Array<FormModelView>!
    public var userAccountDictionnary: [String: Any] = [:]
    
    //    Callaback to modify the navigation's containerView  with this View after Connection
    public var willAppearCallback : ()->Void = {()-> Void in}
    
    public var isPro : Bool = false
    
    @objc public func setAddress(value : LPAddressEntity){
        self.address = value
    }
    
    @objc public func setConnected (value : Bool){
        self.isConnected = value
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: CLHeaderView!
    @IBOutlet weak var floatingView: FloatingView!
    
    @IBOutlet weak var connectionHeightConstraint: NSLayoutConstraint!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
        self.setup()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.willAppearCallback()
        connectionHeightConstraint.constant = isConnected ? 0 : 110

        if let senderAddress = ColissimoData.shared.senderAddress {
            self.lpAddressVC.lpAddress = senderAddress
        } else {
            ColissimoData.shared.senderAddress = address
            self.lpAddressVC.lpAddress = ColissimoData.shared.senderAddress ?? LPAddressEntity.init()
        }
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE4CoordonneesExpediteur,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
    }
    
    func displayContentController(content: UIViewController) {
        
        addChildViewController(content)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(content.view)
        
        let array = [content.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0), content.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0), content.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0), content.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(array)
    }
    
    
    @IBAction func connectionButtonAction(_ sender: Any) {
        if let delgate  =  ColissimoManager.sharedManager.delegate {
            delgate.senderFormDidCallAuthentification()
        }
    }
    
    func setup(){
        lpAddressVC = ColissimoManager.sharedManager.getGenericForm() as? LPAddressViewController
        lpAddressVC.maxInputCount = 5
        lpAddressVC.shouldCapitalize = true
        lpAddressVC.isProAddress = self.isPro
        lpAddressVC.contentArray = self.contentArray
        lpAddressVC.emailText = "Pour Suivre l'envoi de votre colis, précisez votre adresse e-mail"
        lpAddressVC.emailDescText = "Recevez des notifications par e-mail aux étapes clés du parcours de votre colis."
        
        if address != nil{
            if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress {
                let isSelectedAddress = address.countryIsoCode.lowercased() == selectedSenderAddress.isocode.lowercased()
                
                if(!isSelectedAddress){
                    if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress {
                        address.countryName = selectedSenderAddress.name
                        address.countryIsoCode = selectedSenderAddress.isocode//"fr";
                        address.postalCode = "";
                        address.locality = "";
                        address.complementaryAddress = ""
                        address.street = ""
                    }
                }
                lpAddressVC.lpAddress = address
            } else {
                print("⛔️⛔️⛔️ selectedSenderAddress is nil ⛔️⛔️⛔️")
            }
        }
        
        if isPro {
            lpAddressVC.userAccountDictionnary = userAccountDictionnary
        }
        
        lpAddressVC.isPro = self.isPro
        
        self.lpAddressVC.initModuleWithParams(themeColor: UIColor.lpGreen, formContent: self.contentArray,isCountryEnabled: false)
        lpAddressVC.shouldShowMoreInfo = true
        
        lpAddressVC.addressDelegate = self
        lpAddressVC.allowWrongLocality = false
        let presentMode : CLViewPresentation = push
        lpAddressVC.setPresentationMode(value: Int(presentMode.rawValue))
        self.displayContentController(content: lpAddressVC)
        
        self.headerView.setup(title: "Saisissez vos coordonnées", icon: "ic_step_4.png", step: 4)
        self.floatingView.progress = 0.5
        floatingView.animate()
        if let price = ColissimoData.shared.price {
            self.floatingView.productImageNamed = ColissimoData.shared.dimension.image
            self.floatingView.price = price
        }
        
    }
    override public func viewDidLayoutSubviews() {
        self.floatingView.layoutSubviews()
    }
    
    func setupDataSource(){
        self.contentArray = Array<FormModelView>()
        self.contentArray.append(FormModelView(type: .Civility, isMandatory: false))
        self.contentArray.append(FormModelView(type: .FirstName, isMandatory: !isPro))
        self.contentArray.append(FormModelView(type: .LastName, isMandatory: !isPro))
        
        if isPro {
            self.contentArray.append(FormModelView(type: .CompanyName, isMandatory: true))
        }
        
        self.contentArray.append(FormModelView(type: .CurrentPositionButton, isMandatory: false))
        self.contentArray.append(FormModelView(type: .Steet, isMandatory: true))
        self.contentArray.append(FormModelView(type: .ComplementaryAddress, isMandatory: false))
        self.contentArray.append(FormModelView(type: .PostalCode, isMandatory: true))
        self.contentArray.append(FormModelView(type: .Locality, isMandatory: true))
        self.contentArray.append(FormModelView(type: .Country, isMandatory: true))
        
        self.contentArray.append(FormModelView(type: .Tel, isMandatory: false))
        self.contentArray.append(FormModelView(type: .EmailHeader, isMandatory: false))
        self.contentArray.append(FormModelView(type: .Email, isMandatory: false))
        self.contentArray.append(FormModelView(type: .ValidateButton, isMandatory: false))
        
        if isConnected && isPro {
            if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress, let country = self.userAccountDictionnary["country"] as? String {
                if selectedSenderAddress.name == country {
                    self.contentArray.insert(FormModelView(type: .Welcome, isMandatory: false), at: 1)
                }
            }
        }
    }
}

extension CLSenderViewController : LPAddressDelegate {
    
    public func didValidateFormButtonClicked(address : LPAddressEntity){
        ColissimoData.shared.senderAddress = address
        if CLRouter.shared.areEqual() {
            ColissimoManager.sharedManager.delegate?.homeViewDidCallDirectlyRecap(containsFormalities: ColissimoData.shared.containsFormalities(), step: 5)
        } else {
            ColissimoManager.sharedManager.delegate?.didCallReceiverForm()            
        }
    }
}
