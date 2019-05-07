//
//  CLReceiverViewController.swift
//  LPColissimoUI
//
//  Created by LaPoste on 26/11/2018.
//

import UIKit

public class CLReceiverViewController: UIViewController {
    
    @IBOutlet weak var headerView: CLHeaderView!
    @IBOutlet weak var floatingView: FloatingView!
    
    var isConnected : Bool = false
    @objc public func setConnected (value : Bool){
        self.isConnected = value
    }
    
    public var address : LPAddressEntity!
    @objc public func setAddress(value : LPAddressEntity){
        self.address = value
    }
    
    public var isPro : Bool = false
    //Callaback to modify the navigation's containerView  with this View after Connection
    public var willAppearCallback : ()->Void = {()-> Void in}
    
    @IBOutlet weak var contentView: UIView!
    
    var contentArray : Array<FormModelView>!
    
    var lpAddressVC : LPAddressViewController!
    
    func setupDataSource(isPro : Bool){
        let isInternational = address.countryIsoCode == "fr" ? false : true
        if isPro {
            self.contentArray = Array<FormModelView>()
            
            self.contentArray.append(FormModelView(type: .AddressKind, isMandatory: false))
            self.contentArray.append(FormModelView(type: .Civility, isMandatory: false))
            self.contentArray.append(FormModelView(type: .FirstName, isMandatory: false))
            self.contentArray.append(FormModelView(type: .LastName, isMandatory: false))
            
            self.contentArray.append(FormModelView(type: .CompanyName, isMandatory: true))
            
            self.contentArray.append(FormModelView(type: .Steet, isMandatory: true))
            self.contentArray.append(FormModelView(type: .ComplementaryAddress, isMandatory: false))
            self.contentArray.append(FormModelView(type: .PostalCode, isMandatory: true))
            self.contentArray.append(FormModelView(type: .Locality, isMandatory: true))
            self.contentArray.append(FormModelView(type: .Country, isMandatory: true))
            
            let formCountries = FormalityCountry.shared.countries.first { country -> Bool in
                return country.departure_country_id == ColissimoData.shared.departureCountry && country.arrival_country_id == ColissimoData.shared.arrivalCountry
            }
            self.contentArray.append(FormModelView(type: .Tel, isMandatory: isInternational))
            self.contentArray.append(FormModelView(type: .EmailHeader, isMandatory: false))
            self.contentArray.append(FormModelView(type: .Email, isMandatory: false))
            self.contentArray.append(FormModelView(type: .ValidateButton, isMandatory: false))
        } else {
            self.contentArray = Array<FormModelView>()
            
            self.contentArray.append(FormModelView(type: .AddressKind, isMandatory: false))
            self.contentArray.append(FormModelView(type: .Civility, isMandatory: false))
            self.contentArray.append(FormModelView(type: .FirstName, isMandatory: true))
            self.contentArray.append(FormModelView(type: .LastName, isMandatory: true))
            
            self.contentArray.append(FormModelView(type: .Steet, isMandatory: true))
            self.contentArray.append(FormModelView(type: .ComplementaryAddress, isMandatory: false))
            self.contentArray.append(FormModelView(type: .PostalCode, isMandatory: true))
            self.contentArray.append(FormModelView(type: .Locality, isMandatory: true))
            self.contentArray.append(FormModelView(type: .Country, isMandatory: true))
            
            self.contentArray.append(FormModelView(type: .Tel, isMandatory: isInternational))
            self.contentArray.append(FormModelView(type: .EmailHeader, isMandatory: false))
            self.contentArray.append(FormModelView(type: .Email, isMandatory: false))
            self.contentArray.append(FormModelView(type: .ValidateButton, isMandatory: false))
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.lpAddressVC =  ColissimoManager.sharedManager.getGenericForm() as? LPAddressViewController
        
        if address != nil{
            self.lpAddressVC.lpAddress = address
        }else{
            self.address = LPAddressEntity()
            if let arrivalCountry = ColissimoData.shared.arrivalCountry {
                self.address.countryIsoCode = arrivalCountry
            }
            self.lpAddressVC.lpAddress = self.address
        }
        self.headerView.setup(title: "Indiquez le destinataire", icon: "ic_step_5.png", step: 5)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
    }
    
    func setup(){
        if let receiverAddress = ColissimoData.shared.receiverAddress {
            self.lpAddressVC.lpAddress = receiverAddress
        } else {
            ColissimoData.shared.receiverAddress = address
            self.lpAddressVC.lpAddress = ColissimoData.shared.receiverAddress ?? LPAddressEntity.init()
        }
        
        var countries : [(String,String)] = [(String,String)]()
        for country  in ColissimoManager.sharedManager.arrivalCountries{
            countries.append((country.isocode, country.name))
        }
        lpAddressVC.countriesArray = countries
        lpAddressVC.maxInputCount = 9
        lpAddressVC.postalcodeType = UIKeyboardType.default
        print("👀  \(#function) 👀\(countries)");
        
        self.lpAddressVC.isProAddress = isPro
        self.setupDataSource(isPro: isPro)
        self.lpAddressVC.contentArray = self.contentArray        
        
        lpAddressVC.shouldChangeContentListner = {(isPro) in
            self.setupDataSource(isPro: isPro)
            self.lpAddressVC.reloadWithData(content: self.contentArray)
        }
        
        self.lpAddressVC.initModuleWithParams(themeColor: UIColor.lpGreen, formContent: self.contentArray,isCountryEnabled: false)
        lpAddressVC.shouldShowMoreInfo = true
        
        lpAddressVC.addressDelegate = self
        lpAddressVC.allowWrongLocality = false
        lpAddressVC.emailText = "Pour notifier votre destinataire du suivi de son colis, précisez son adresse e-mail"
        lpAddressVC.emailDescText = "Il recevra des notifications par e-mail aux étapes clés du parcours de votre colis."
        
        let presentMode : CLViewPresentation = push
        lpAddressVC.setPresentationMode(value: Int(presentMode.rawValue))
        self.displayContentController(content: lpAddressVC)
        
        //self.lpAddressVC.initModuleWithParams(themeColor: UIColor.lpGreen, formContent: self.contentArray,isCountryEnabled: false)
        //initModuleWithParamsAndCountry( themeColor: UIColor.lpGreen, formContent: array,isCountryEnabled: false)
        //self.lpAddressVC.addressDelegate = self
        //self.displayContentController(content: self.lpAddressVC)
        self.floatingView.progress = 0.7
        floatingView.animate()
        if let price = ColissimoData.shared.price {
            self.floatingView.productImageNamed = ColissimoData.shared.dimension.image
            self.floatingView.price = price
        }
    }
    
    override public func viewDidLayoutSubviews() {
        self.floatingView.layoutSubviews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.setup()
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE5CoordonneesDestinataire,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
        
        self.willAppearCallback()
    }
    
    func displayContentController(content: UIViewController) {
        addChildViewController(content)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(content.view)
        
        let array = [content.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0), content.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0), content.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0), content.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(array)
    }
    
    @IBAction func connectButtonAction(_ sender: Any) {
        if let delgate = ColissimoManager.sharedManager.delegate {
            delgate.senderFormDidCallAuthentification()
        }
    }
}

extension CLReceiverViewController : LPAddressDelegate {
    public func didValidateFormButtonClicked(address : LPAddressEntity){
        
        if (address.companyName != "") {// Is profesional
            // ATInternet
//            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAjouterNouveauColis,
//                                                                  pageName: TaggingData.kE7Recapitulatif,
//                                                                  chapter1: TaggingData.kChapter1,
//                                                                  chapter2: TaggingData.kChapter2,
//                                                                  level2: TaggingData.kColissimoLevel)
        }

        
//        DispatchQueue.main.sync {
            self.address = address
            ColissimoData.shared.receiverAddress = address
        
        if CLRouter.shared.areEqual() {
            ColissimoManager.sharedManager.delegate?.homeViewDidCallDirectlyRecap(containsFormalities: ColissimoData.shared.containsFormalities(), step: 6)
        } else {
            ColissimoManager.sharedManager.delegate?.homeViewDidCallStep6With()
        }
//        }
    }
}
