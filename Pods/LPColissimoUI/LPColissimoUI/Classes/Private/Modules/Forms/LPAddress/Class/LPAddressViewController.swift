//
//  LPAddressViewController.swift
//  RefonteFormulaire
//
//  Created by Sofien Azzouz on 11/01/2018.
//  Copyright © 2018 Sofien Azzouz. All rights reserved.
//



@objc public protocol LPAddressDelegate: class {
    @objc func didValidateFormButtonClicked(address : LPAddressEntity)
}
@objc public protocol LPAddressDataSource : class{
    @objc func insertValue(at index: Int)
    @objc func numberOfRowInAddress()->Int
}

public class FormModelView : NSObject{
    var type : FormKeys
    var isMandatory : Bool
    init(type: FormKeys , isMandatory :Bool) {
        self.isMandatory = isMandatory
        self.type = type
    }
    
    @objc public init(type: Int, isMandatory :Bool){
        self.isMandatory = isMandatory
        self.type = FormKeys(rawValue: type)!
    }
    
    func toString(){
        print("👀  \(#function) 👀 type:\(type.rawValue) | isMandatory: \(isMandatory)");
    }
    
}


import LPSharedMCM
import LPColissimo


public class LPAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LPUsePositionButtonCustomCellDelegate, LPValidateCellDelegate, MCMLocationServiceDelegate, LPCivilityCustomCellDelegate, LPInputCellDelegate, LPCountryCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource,  LPTypeCustomCellDelegate, LPSaveAddressCellDelegate {
    
    @objc public var addressDelegate: LPAddressDelegate?
    weak var dataSource  :  LPAddressDataSource?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countriesPickerView: UIView!
    
    @IBOutlet var countriesPicker: UIPickerView!
    private var tableItems: Array<LPBaseCustomCell>?
    
    @objc public var contentArray : Array<FormModelView>!
    //var formContent: Array<FormKeys>?
    
    // NEED TO BE CLEAR AFTER LOT 1
    var emailText: String = ""
    var emailDescText: String = ""
    
    var mascadiaAddresses: Array<Any>?
    var localityAndPostalCodeMascadiaOK = false
    
    var themeColor: UIColor?
    var isCountryEnabled = false
    var countriesArray : [(String , String)]!
    var indexSelectedCountry = 0
    public var isPro = false
    
    var viewPresentationValue = ViewPresentation.isPush
    @objc public var descriptionImageView : UIImage!
    @objc public var descriptionViewName : String!
    @objc public var descriptionViewDescription : String!
    @objc public var isProAddress = true
    @objc public var shouldCapitalize = false
    public var maxInputCount : Int?
    public var postalcodeType :  UIKeyboardType = UIKeyboardType.decimalPad
    var shouldShowMoreInfo: Bool = false    
    
    @IBOutlet weak var viewPresentationImageView: UIImageView!
    @IBOutlet weak var viewPresentationDescriptionLabel: UITextView!
    @IBOutlet weak var viewPresentationNameLabel: UILabel!
    
    @IBOutlet weak var viewControllerDescriptionView: UIView!
    
    @objc public var invalideZipCode = [String]()
    @objc public var trackingDelegate : LPAddressTrackingProtocol!
    @objc public var lpAddress = LPAddressEntity() {
        didSet {
            print("lpAddress didSet")
        }
    }
    @objc public var allowWrongLocality = true
    @objc public var isSaveAddressSelected = false
    @objc public var needCEDEXCheck = true;
    
    var shouldChangeContentListner : (Bool)->Void = {(Bool)->Void in}
    var userAccountDictionnary: [String: Any] = [:]
    
    //    MARK: -
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        
        if self.countriesArray == nil || self.countriesArray.count == 0 {
            countriesArray = self.getCountriesInfo()
            self.selectDefaultCountry()
            
        }
        else if self.lpAddress.countryName.count == 0{
            let country : (String,String) = countriesArray[0]
            self.lpAddress.countryName = country.1
        }
        
        var index = 0
        for country in self.countriesArray {
            print("👀  \(#function) \(country.0) | \(country.1) |iso :\(self.lpAddress.countryIsoCode) 👀");
            if (country.0 as? String)?.lowercased() == self.lpAddress.countryIsoCode.lowercased() {
                indexSelectedCountry = index
                print("👀  \(#function) selectedIndex\(indexSelectedCountry) | name \(self.countriesArray[indexSelectedCountry].1) | iso : \(self.countriesArray[indexSelectedCountry].0) 👀");
                lpAddress.countryName = self.countriesArray[indexSelectedCountry].1
                self.countriesPicker.selectRow(indexSelectedCountry, inComponent: 0, animated: false)
                break
            }
            index += 1
        }
        
        self.countriesPickerView.isHidden = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.allowsSelection = false
        updateAdressFromDictionnary(dict: userAccountDictionnary, adress:lpAddress)
        
        if self.contentArray != nil {
            tableItems = self.createTableViewCells(formContent: self.contentArray!, isPro: self.isPro)
            self.activateValidationButton()
        }
        
        self.activateValidationButton()
        
        //set up tableview header
        setHeaderHeight()
        
        //tracking
        if self.trackingDelegate != nil {
            self.trackingDelegate.sendGenericFormViewControllerDisplayed()
        }
        self.setFooterView()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if lpAddress.street.count != 0 {
            self.tableItems?.removeAll()
            print("Form CONTENT COUNT \(String(describing: self.contentArray?.count))")
//            updateAdressFromDictionnary(dict: userAccountDictionnary, adress:lpAddress)
            self.tableItems = self.createTableViewCells(formContent: self.contentArray!, isPro: self.isPro)
            self.tableView.reloadData()
            self.activateValidationButton()
        }
    }
    
    //    MARK: - Custom Init
    func setFooterView() {
        if let footer = ColissimoManager.sharedManager.delegate?.getFooterView() {
            let view: UIView = UIView(frame: footer.bounds)
            view.addSubview(footer)
            self.tableView.tableFooterView = view
        }
    }
    
    func updateAdressFromDictionnary(dict: [String: Any], adress: LPAddressEntity) {
        if let civility = dict["civility"] as? String {
            lpAddress.civility = civility
        }
        if let firstName = dict["firstName"] as? String {
            lpAddress.firstName = firstName
        }
        if let lastName = dict["lastName"] as? String {
            lpAddress.lastName = lastName
        }
        if let companyName = dict["companyName"] as? String {
            lpAddress.companyName = companyName
        }
        if let street = dict["street"] as? String {
            lpAddress.street = street
        }
        if let postalCode = dict["postalCode"] as? String {
            lpAddress.postalCode = postalCode
        }
        if let city = dict["city"] as? String {
            lpAddress.locality = city
        }
        if let country = dict["country"] as? String {
            lpAddress.countryName = country
        }
        if let phone = dict["phone"] as? String {
            lpAddress.phone = phone
        }
        if let email = dict["email"] as? String {
            lpAddress.email = email
        }
    }
    @objc public func setPresentationMode(value : Int){
        viewPresentationValue = ViewPresentation(rawValue: value) ?? .isPush
    }
    
    /*@objc public func test(forms : Array<Int>){
     print("👀  \(#function) 👀 \(forms)");
     initModuleWithParamsAndCountry(themeColor :themeColor,  formContent: forms.map({ FormKeys(rawValue: $0)! }), isCountryEnabled: true)
     }
     
     @objc public func initModuleWithParamsAndCountry(themeColor: UIColor?, formContent: Array<Int>, isCountryEnabled: Bool) {
     initModuleWithParamsAndCountry(themeColor :themeColor,  formContent: formContent.map({ FormKeys(rawValue: $0)! }), isCountryEnabled: isCountryEnabled)
     }
     
     @objc public func objc_initModuleWithParamsAndCountry(themeColor: UIColor?, formContent: Array<Int>, isCountryEnabled: Bool) {
     initModuleWithParamsAndCountry(themeColor :themeColor,  formContent: formContent.map({ FormKeys(rawValue: $0)! }), isCountryEnabled: isCountryEnabled)
     }
     
     public func objc_initModuleWithParamsAndCountryList(themeColor: UIColor?, formContent: Array<Int>, isCountryEnabled: Bool) {
     initModuleWithParamsAndCountry(themeColor :themeColor,  formContent: formContent.map({ FormKeys(rawValue: $0)! }), isCountryEnabled: isCountryEnabled)
     }
     
     public func objc_initModuleWithParams(themeColor: UIColor?, formContent: Array<Int>, isCountryEnabled: Bool) {
     initModuleWithParams(themeColor :themeColor,  formContent: formContent.map({ FormKeys(rawValue: $0)! }))
     }
     
     public func objc_initForDestinationPAPLR(themeColor: UIColor?, formContent: Array<Int>, isCountryEnabled: Bool) {
     shouldShowMoreInfo = true
     print("Form CONTENT COUNT \(String(describing: formContent.count))")
     initModuleWithParams(themeColor :themeColor,  formContent: formContent.map({ FormKeys(rawValue: $0)! }))
     }
     
     func initModuleWithParamsAndCountry(themeColor: UIColor?, formContent: Array<FormKeys>?, isCountryEnabled: Bool) {
     self.isCountryEnabled = isCountryEnabled
     self.initModuleWithParams(themeColor: themeColor, formContent: formContent)
     }
     
     func initModuleWithParams(themeColor: UIColor?, formContent: Array<FormKeys>?) {
     self.themeColor = themeColor
     self.formContent = formContent
     }*/
    
    @objc public func objc_initModuleWithParams(themeColor: UIColor?, formContent: Array<FormModelView>?, isCountryEnabled: Bool) {
        self.themeColor = themeColor
        self.contentArray = formContent
        self.isCountryEnabled = isCountryEnabled
    }
    
    func initModuleWithParams(themeColor: UIColor?, formContent: Array<FormModelView>?,isCountryEnabled: Bool) {
        self.themeColor = themeColor
        self.contentArray = formContent
        self.isCountryEnabled = isCountryEnabled
    }
    
    
    func selectDefaultCountry(){
        if(self.lpAddress.countryIsoCode.isEmpty){
            let index = countriesArray.index(where: { (country) -> Bool in
                country.1  == "France"
            })
            if let selectedIndex = index {
                indexSelectedCountry = selectedIndex
                self.lpAddress.countryName = countriesArray[indexSelectedCountry].1 as! String
                self.countriesPicker.selectRow(indexSelectedCountry, inComponent: 0, animated: false)
            }
        }
    }
    
    
    //    @objc(initModuleWithParamsAndCountry:formContent:isCountryEnabled:)
    
    // MARK: - Navigation
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == kShowMascadiaFromAddressInput) {
            let viewController = segue.destination as! LPMascadiaVerificationViewController
            viewController.lpAddress = self.lpAddress
            viewController.addresses = self.mascadiaAddresses!
            viewController.themeColor = self.themeColor
            viewController.trackingDelegate = self.trackingDelegate
            viewController.addressDelegate = self.addressDelegate
            if allowWrongLocality == true {
                viewController.localityAndPostalCodeMascadiaOK = true
            } else {
                viewController.localityAndPostalCodeMascadiaOK = self.localityAndPostalCodeMascadiaOK
            }
            viewController.descriptionViewName = descriptionViewName
            viewController.descriptionImageView = descriptionImageView
        }
    }
    
    // MARK: - TableView delagtes
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableItems?.count)!
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.tableItems![indexPath.row]
        return cell.cellHeight()
    }
    //     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let cell = self.tableItems![indexPath.row]
    //
    //        return cell.cellHeight()
    //    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableItems![indexPath.row]
        
        return cell
    }
    
    //    MARK: -
    func registerTableViewCells() {
        // Register table cell class from nib
        
        let podBundle = Bundle(for: CustomFormalitiesViewController.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                self.tableView.register(UINib(nibName: "WelcomeCell", bundle: bundle), forCellReuseIdentifier: "WelcomeCell")
                self.tableView.register(UINib(nibName: "EmailHeaderCell", bundle: bundle), forCellReuseIdentifier: "EmailHeaderCell")
                self.tableView.register(UINib(nibName: "LPCivilityCustomCell", bundle: bundle), forCellReuseIdentifier: "LPCivilityCustomCell")
                self.tableView.register(UINib(nibName: "LPInputCustomCell", bundle: bundle), forCellReuseIdentifier: "LPInputCustomCell")
                self.tableView.register(UINib(nibName: "LPUsePositionButtonCustomCell", bundle: bundle), forCellReuseIdentifier: "LPUsePositionButtonCustomCell")
                self.tableView.register(UINib(nibName: "LPValidateCustomCell", bundle: bundle), forCellReuseIdentifier: "LPValidateCustomCell")
                self.tableView.register(UINib(nibName: "LPCountryCustomCell", bundle: bundle), forCellReuseIdentifier: "LPCountryCustomCell")
                self.tableView.register(UINib(nibName: "LPTypeCustomCell", bundle: bundle), forCellReuseIdentifier: "LPTypeCustomCell")
                self.tableView.register(UINib(nibName: "LPSaveAddressCustomCell", bundle: bundle), forCellReuseIdentifier: "LPSaveAddressCustomCell")
            }
        }
        
    }
    
    func createTableViewCells(formContent: Array<FormModelView>, isPro: Bool) -> Array<LPBaseCustomCell> {
        
        var formCellsNames = [LPBaseCustomCell]()
        var textFieldTag = 100
        var index : Int =  0
        for form in formContent {
            textFieldTag += 1
            let data = self.contentArray[index]
            data.toString()
            index += 1
            switch form.type {
            case .Welcome:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCell") as! WelcomeCell
                cell.setup(name: self.lpAddress.firstName)
                formCellsNames.append(cell)
                break
            case .EmailHeader:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmailHeaderCell") as! EmailHeaderCell
                cell.setupCell(main: self.emailText, desc: self.emailDescText)
                formCellsNames.append(cell)
                break
            case .AddressKind:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPTypeCustomCell") as! LPTypeCustomCell
                cell.initCellWithType(isPro: isProAddress)
                cell.delegate = self
                formCellsNames.append(cell)
                break
            case .Civility:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPCivilityCustomCell") as! LPCivilityCustomCell
                if self.isPro {
                    cell.initCellWithGender(gender: self.lpAddress.civility)
                } else {
                    cell.initCellWithGender(gender: self.lpAddress.civility)
                }
                
                cell.delegate = self
                formCellsNames.append(cell)
                break
            case .CompanyName:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                if self.isPro {
                    cell.initCellWithData(fieldMsg: self.lpAddress.companyName, titleMsg: "Raison Sociale", isMandatory: data.isMandatory, formType: .CompanyName, themeColor: themeColor!, textFieldTag: textFieldTag)
                } else {
                    cell.initCellWithData(fieldMsg: self.lpAddress.companyName, titleMsg: "Raison Sociale", isMandatory: data.isMandatory, formType: .CompanyName, themeColor: themeColor!, textFieldTag: textFieldTag)
                }
                
                cell.delegate = self
                formCellsNames.append(cell)
                break
            case .ServiceNameReciever:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                
                cell.initCellWithData(fieldMsg: self.lpAddress.serviceName, titleMsg: "Service ou Nom du destinataire", isMandatory: data.isMandatory, formType: .ServiceNameReciever, themeColor: themeColor!, textFieldTag: textFieldTag)
                cell.delegate = self
                formCellsNames.append(cell)
                break
            case .ServiceNameSender:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                cell.initCellWithData(fieldMsg: self.lpAddress.serviceName, titleMsg: "Service ou Nom de l'expéditeur", isMandatory: data.isMandatory, formType: .ServiceNameSender, themeColor: themeColor!, textFieldTag: textFieldTag)
                cell.delegate = self
                formCellsNames.append(cell)
                
                break
            case .FirstName:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                
                if self.isPro {
                    cell.initCellWithData(fieldMsg: self.lpAddress.firstName, titleMsg: "Prénom", isMandatory: data.isMandatory, formType: .FirstName, themeColor: themeColor!, textFieldTag: textFieldTag)
                } else {
                    cell.initCellWithData(fieldMsg: self.lpAddress.firstName, titleMsg: "Prénom", isMandatory: data.isMandatory, formType: .FirstName, themeColor: themeColor!, textFieldTag: textFieldTag)
                }
                
                cell.delegate = self
                
                formCellsNames.append(cell)
                break
            case .LastName:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                if self.isPro {
                    cell.initCellWithData(fieldMsg: self.lpAddress.lastName, titleMsg: "Nom", isMandatory: data.isMandatory, formType: .LastName, themeColor: themeColor!, textFieldTag: textFieldTag)
                } else {
                    cell.initCellWithData(fieldMsg: self.lpAddress.lastName, titleMsg: "Nom", isMandatory: data.isMandatory, formType: .LastName, themeColor: themeColor!, textFieldTag: textFieldTag)
                }
                cell.delegate = self
                formCellsNames.append(cell)
                break
            case .Email:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                
                if self.isPro {
                    cell.initCellWithData(fieldMsg: self.lpAddress.email, titleMsg: "Email", isMandatory: data.isMandatory, formType: .Email, themeColor: themeColor!, textFieldTag: textFieldTag)
                } else {
                    cell.initCellWithData(fieldMsg: self.lpAddress.email, titleMsg: "Email", isMandatory: data.isMandatory, formType: .Email, themeColor: themeColor!, textFieldTag: textFieldTag)
                }
                
                cell.delegate = self
                formCellsNames.append(cell)
                break
            case .Tel:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                
                if self.isPro {
                    cell.initCellWithData(fieldMsg: self.lpAddress.phone, titleMsg: "Téléphone mobile", isMandatory: data.isMandatory, formType: .Tel, themeColor: themeColor!, textFieldTag: textFieldTag)
                } else {
                    cell.initCellWithData(fieldMsg: self.lpAddress.phone, titleMsg: "Téléphone mobile", isMandatory: data.isMandatory, formType: .Tel, themeColor: themeColor!, textFieldTag: textFieldTag)
                }
                
                cell.delegate = self
                formCellsNames.append(cell)
                break
            case .ComplementaryAddress:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                cell.initCellWithData(fieldMsg: self.lpAddress.complementaryAddress, titleMsg: "Complément d'adresse", isMandatory: data.isMandatory, formType: .ComplementaryAddress, themeColor: themeColor!, textFieldTag: textFieldTag)
                cell.delegate = self
                formCellsNames.append(cell)
                
                break
            case .Steet:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                let isMandatory : Bool = !(lpAddress.locality.range(of:"CEDEX") != nil) || data.isMandatory
                
                if self.isPro {
                    
                    if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress {
                        if selectedSenderAddress.isocode.lowercased() != self.lpAddress.countryIsoCode.lowercased() {
                            self.lpAddress.street = ""
                            cell.initCellWithData(fieldMsg: "", titleMsg: "N° et libellé de la voie", isMandatory: isMandatory, formType: .Steet, themeColor: themeColor!, textFieldTag: textFieldTag)
                        } else {
                            cell.initCellWithData(fieldMsg: self.lpAddress.street, titleMsg: "N° et libellé de la voie", isMandatory: isMandatory, formType: .Steet, themeColor: themeColor!, textFieldTag: textFieldTag)
                        }
                    } else {
                        self.lpAddress.street = ""
                        cell.initCellWithData(fieldMsg: "", titleMsg: "N° et libellé de la voie", isMandatory: isMandatory, formType: .Steet, themeColor: themeColor!, textFieldTag: textFieldTag)
                    }
                } else {
                    cell.initCellWithData(fieldMsg: self.lpAddress.street, titleMsg: "N° et libellé de la voie", isMandatory: isMandatory, formType: .Steet, themeColor: themeColor!, textFieldTag: textFieldTag)
                }
                
                cell.delegate = self
                formCellsNames.append(cell)
                
                break
            case .PostalCode:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell

                cell.isInternational = lpAddress.countryIsoCode == "fr" ? false : true
                
                if self.isPro {
                    if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress {
                        if selectedSenderAddress.isocode.lowercased() != self.lpAddress.countryIsoCode.lowercased() {
                            self.lpAddress.postalCode = ""
                            cell.initCellWithData(fieldMsg: "", titleMsg: "Code postal", isMandatory: data.isMandatory, formType: .PostalCode, themeColor: themeColor!, textFieldTag: textFieldTag)
                        } else {
                            cell.initCellWithData(fieldMsg: self.lpAddress.postalCode, titleMsg: "Code postal", isMandatory: data.isMandatory, formType: .PostalCode, themeColor: themeColor!, textFieldTag: textFieldTag)
                        }
                    } else {
                        self.lpAddress.postalCode = ""
                        cell.initCellWithData(fieldMsg: "", titleMsg: "Code postal", isMandatory: data.isMandatory, formType: .PostalCode, themeColor: themeColor!, textFieldTag: textFieldTag)
                    }
                } else {
                    cell.initCellWithData(fieldMsg: self.lpAddress.postalCode, titleMsg: "Code postal", isMandatory: data.isMandatory, formType: .PostalCode, themeColor: themeColor!, textFieldTag: textFieldTag)
                }
                
                cell.delegate = self
                formCellsNames.append(cell)
                if let maxCount = maxInputCount {
                    cell.maxCount = maxCount
                }
                
                
            
                break
            case .Locality:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPInputCustomCell") as! LPInputCustomCell
                
                if self.isPro {
                    if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress {
                        if selectedSenderAddress.isocode.lowercased() != self.lpAddress.countryIsoCode.lowercased() {
                            self.lpAddress.locality = ""
                            cell.initCellWithData(fieldMsg: "", titleMsg: "Localité", isMandatory: data.isMandatory, formType: .Locality, themeColor: themeColor!, textFieldTag: textFieldTag)
                        } else {
                            cell.initCellWithData(fieldMsg: self.lpAddress.locality, titleMsg: "Localité", isMandatory: data.isMandatory, formType: .Locality, themeColor: themeColor!, textFieldTag: textFieldTag)
                        }
                    } else {
                        self.lpAddress.locality = ""
                        cell.initCellWithData(fieldMsg: "", titleMsg: "Localité", isMandatory: data.isMandatory, formType: .Locality, themeColor: themeColor!, textFieldTag: textFieldTag)
                    }
                } else {
                    cell.initCellWithData(fieldMsg: self.lpAddress.locality, titleMsg: "Localité", isMandatory: data.isMandatory, formType: .Locality, themeColor: themeColor!, textFieldTag: textFieldTag)
                }
                
                cell.delegate = self
                formCellsNames.append(cell)
                
                break
            case .Country:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPCountryCustomCell") as! LPCountryCustomCell
                if self.isPro {
                    if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress {
                        let country = self.lpAddress.countryName
                        if selectedSenderAddress.name != country {
                            self.lpAddress.countryName = selectedSenderAddress.name
                            cell.initCellWithCountryName(countryName: selectedSenderAddress.name, isEnabled: isCountryEnabled)
                        } else {
                            self.lpAddress.countryName = country
                            cell.initCellWithCountryName(countryName: country, isEnabled: isCountryEnabled)
                        }
                    } else {
                        
                    }
                } else {
                    cell.initCellWithCountryName(countryName: self.lpAddress.countryName, isEnabled: isCountryEnabled)
                }
                
                cell.delegate = self
                formCellsNames.append(cell)
                
                break
            case .CurrentPositionButton:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPUsePositionButtonCustomCell") as! LPUsePositionButtonCustomCell
                cell.delegate = self
                formCellsNames.append(cell)
                
                break
            case .SaveAddress:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPSaveAddressCustomCell") as! LPSaveAddressCustomCell
                formCellsNames.append(cell)
                cell.delegate = self
                break
            case .ValidateButton:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LPValidateCustomCell") as! LPValidateCustomCell
                cell.initCellWithColor(color: themeColor)
                formCellsNames.append(cell)
                cell.delegate = self
                break
            }
            
            if let cell  =  formCellsNames[index-1] as? LPInputCustomCell {
                cell.inputTextField.autocapitalizationType = .allCharacters
            }
        }
        
        
        //        if (formCellsNames[index] is LPInputCustomCell){
        //            if shouldCapitalize {
        //                (formCellsNames[index] as! LPInputCustomCell).inputTextField.autocapitalizationType = .allCharacters
        //            }
        //        }
        return formCellsNames
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setHeaderHeight () {
        switch viewPresentationValue {
        case .isPush:
            tableView.tableHeaderView?.isHidden = true
            tableView.tableHeaderView?.frame.size = CGSize(width: 0, height: 20)
            break
        case .isModal:
            self.viewControllerDescriptionView.isHidden = true
            tableView.tableHeaderView?.frame.size = CGSize(width: 0, height: 80)
            break
        case .isModalWithViewDescription:
            setViewPresentationDetail()
            break
        default:
            tableView.tableHeaderView?.isHidden = true
            tableView.tableHeaderView?.frame.size = CGSize(width: 0, height: 0)
        }
    }
    func setViewPresentationDetail() {
        self.viewPresentationImageView.image = descriptionImageView
        self.viewPresentationNameLabel.text = descriptionViewName
        self.viewPresentationDescriptionLabel.text = descriptionViewDescription
        self.viewPresentationDescriptionLabel.textAlignment = .center
    }
    
    func setViewPresentationType (value : ViewPresentation) {
        self.viewPresentationValue = value
    }
    
    // MARK: - LPValidateCellDelegate
    func validateFormButtonClicked() {
        self.tableView.endEditing(true)
        var isValidForm = true
        var i = 0
        for form in contentArray! {
            
            let data = self.contentArray[i]
            let cell = self.tableItems![i]
            i += 1
            var hasError = false
            switch form.type {
            case .CompanyName:
                hasError = self.lpAddress.companyName.count == 0 && data.isMandatory
            case .FirstName:
                hasError = self.lpAddress.firstName.count == 0 && data.isMandatory
                if self.lpAddress.firstName.count != 0 {
                    if self.lpAddress.firstName.count == 1 {
                        cell.showErrorMsg(errorMsg: NSLocalizedString("Ce champ n'est pas au bon format.", comment: ""))
                        isValidForm = false
                    } else {
                        if isValidName(name: self.lpAddress.firstName) {
                            cell.hideErrorMsg()
                        } else{
                            cell.showErrorMsg(errorMsg: NSLocalizedString("Seuls les caractères spéciaux - et ' sont autorisés dans le champ 'Prénom'", comment: ""))
                            isValidForm = false
                        }
                    }
                }
            case .LastName:
                hasError = self.lpAddress.lastName.count == 0 && data.isMandatory
                if self.lpAddress.lastName.count != 0 {
                    if self.lpAddress.lastName.count == 1 {
                        cell.showErrorMsg(errorMsg: NSLocalizedString("Ce champ n'est pas au bon format.", comment: ""))
                        isValidForm = false
                    } else {
                        if isValidName(name: self.lpAddress.lastName) {
                            cell.hideErrorMsg()
                        } else{
                            cell.showErrorMsg(errorMsg: NSLocalizedString("Seuls les caractères spéciaux - et ' sont autorisés dans le champ 'Nom'", comment: ""))
                            isValidForm = false
                        }
                    }
                }
            case .Email:
                hasError = self.lpAddress.email.count  == 0 && data.isMandatory
                if self.lpAddress.email.count != 0 {
                    if   !isValidEmail(text: self.lpAddress.email) {
                        cell.showErrorMsg(errorMsg: NSLocalizedString(" Le format de l'email est incorrect", comment: ""))
                        isValidForm = false
                    } else {
                        cell.hideErrorMsg()
                    }
                }
                
            case .Tel:
                if self.lpAddress.phone.isEmpty && !data.isMandatory{
                    cell.hideErrorMsg()
                    break
                }
                let isInternational = lpAddress.countryIsoCode == "fr" ? false : true
                if self.lpAddress.phone.isValidPhone(isInternational: isInternational) {
                    cell.hideErrorMsg()
                }else{
                    cell.showErrorMsg(errorMsg: NSLocalizedString("Le format du numéro est incorrect", comment: ""))
                    isValidForm = false
                }
                break
            case .Steet:
                if (lpAddress.locality.range(of:"CEDEX") != nil && needCEDEXCheck) {
                    hasError = false
                } else {
                    hasError = self.lpAddress.street.count == 0 && data.isMandatory
                }
            case .PostalCode:
                hasError = self.lpAddress.postalCode.count == 0 && data.isMandatory
                // check the entered zipcode is valid or no only if 'invalideZipCode' is passed as params
                if self.invalideZipCode.count != 0 {
                    for zipCode in self.invalideZipCode {
                        if self.lpAddress.postalCode.hasPrefix(zipCode) {
                            hasError = true
                            break
                        }
                    }
                    if (hasError == true) {
                        cell.showErrorMsg(errorMsg: "Le code postal est interdit")
                        isValidForm = false
                    } else {
                        cell.hideErrorMsg()
                    }
                    continue
                }
            case .Locality:
                hasError = self.lpAddress.locality.count == 0 && data.isMandatory
            case .Country:
                hasError = self.lpAddress.countryName.count == 0 && data.isMandatory
            case .Civility:
                if lpAddress.civility.isEmpty{
                    lpAddress.civility =  "mr"
                }
                
                
            default:
                break
            }
            if (hasError == true) {
                cell.showErrorMsg(errorMsg: "Ce champ est obligatoire.")
                isValidForm = false
            } else if(isValidForm){
                cell.hideErrorMsg()
            }
        }
        
        if self.lpAddress.countryIsoCode.lowercased() == "fr" {
            if isValidForm == true {
                self.checkMascadiaIfNeeded()
            }
        } else {
            if isValidForm {
                if self.addressDelegate != nil {
                    //                    self.lpAddress.toString()
                    self.addressDelegate?.didValidateFormButtonClicked(address: self.lpAddress)
                } else {
                    self.performSegue(withIdentifier: kUnwindFromAddressCreateAndEditVC, sender: nil)
                }
            }else{
                
            }
        }
    }
    
    func civilityChanged(gender: String?) {
        self.lpAddress.civility = gender!
    }
    
    func didChangedAddressType(isPro: Bool?) {
        //print("Form CONTENT COUNT \(String(describing: self.formContent.count))")
        if isPro! {
            isProAddress = true
        } else {
            isProAddress = false
        }
        self.shouldChangeContentListner(isProAddress)
        
    }
    
    func reloadWithData( content: Array<FormModelView>){
        //self.formContent = formContent
        self.contentArray =  content
        //        print("Form CONTENT COUNT \(String(describing: content?.count))")
        self.tableItems?.removeAll()
        self.tableItems = self.createTableViewCells(formContent: content, isPro: self.isPro)
        self.tableView.reloadData()
        activateValidationButton()
        
    }
    /* func didChangedAddressType(isPro: Bool?) {
     print("Form CONTENT COUNT \(String(describing: self.formContent?.count))")
     if isPro! {
     isProAddress = true
     // needCEDEXCheck = true
     self.formContent = [.AddressKind, .CompanyName, .ServiceNameSender, .Steet, .ComplementaryAddress, .PostalCode, .Locality, .Country, .ValidateButton]
     } else {
     isProAddress = false
     //needCEDEXCheck = false
     self.formContent = [.AddressKind, .Civility, .FirstName, .LastName, .Steet, .ComplementaryAddress, .PostalCode, .Locality, .Country, .ValidateButton]
     }
     if shouldShowMoreInfo {
     self.formContent?.insert(.Email, at:(self.formContent?.count)!-1)
     self.formContent?.insert(.Tel, at:(self.formContent?.count)!-1)
     }
     print("Form CONTENT COUNT \(String(describing: self.formContent?.count))")
     self.tableItems?.removeAll()
     self.tableItems = self.createTableViewCells(formContent: self.formContent!)
     self.tableView.reloadData()
     activateValidationButton()
     }*/
    
    func didSelectSaveAddress(isSelected: Bool) {
        if isSelected {
            isSaveAddressSelected = true
        } else {
            isSaveAddressSelected = false
        }
    }
    
    //    MARK: - LPInputCellDelegate
    func inputTextFieldChanged(text: String, formType: FormKeys) {
        switch formType {
        case .CompanyName:
            self.lpAddress.companyName = text
        case .ServiceNameReciever, .ServiceNameSender:
            self.lpAddress.serviceName = text
        case .FirstName:
            self.lpAddress.firstName = text
        case .LastName:
            self.lpAddress.lastName = text
        case .Email:
            self.lpAddress.email = text
        case .Tel:
            self.lpAddress.phone = text
        case .ComplementaryAddress:
            self.lpAddress.complementaryAddress = text
        case .Steet:
            self.lpAddress.street = text
        case .PostalCode:
            self.lpAddress.postalCode = text
            if text.count == 5 {
                if (self.lpAddress.countryIsoCode.lowercased() == "fr") {
                    self.setLocalityFromZipCode(zipCode: text)
                }
            }
        case .Locality:
            self.lpAddress.locality = text
        case .Country:
            self.lpAddress.countryName = text
        default:
            break
        }
        self.activateValidationButton()
    }
    
    func activateValidationButton() {
        
//        var i = 0
        var hasError = false
        for form in contentArray {
//            let data = self.contentArray[i]
//            data.toString()
//            i += 1
            switch form.type {
            case .CompanyName:
                hasError = self.lpAddress.companyName.count == 0 && form.isMandatory
            case .FirstName:
                hasError = self.lpAddress.firstName.count == 0 && form.isMandatory
            case .LastName:
                hasError = self.lpAddress.lastName.count == 0 && form.isMandatory
            case .Email:
                hasError = self.lpAddress.email.count  == 0 && form.isMandatory
            case .Tel:
                hasError = self.lpAddress.phone.count  == 0 && form.isMandatory
            case .Steet:
                if (lpAddress.locality.range(of:"CEDEX") != nil && needCEDEXCheck) {
                    hasError = false
                } else {
                    hasError = self.lpAddress.street.count == 0 && form.isMandatory
                }
            case .PostalCode:
                hasError = self.lpAddress.postalCode.count == 0 && form.isMandatory
            case .Locality:
                hasError = self.lpAddress.locality.count == 0 && form.isMandatory
            case .Country:
                hasError = self.lpAddress.countryName.count == 0 && form.isMandatory
            default:
                break
            }
            if (hasError) {
                break
            }
        }
        let cell = self.tableItems?.last
        //activated button
        if (cell?.isKind(of: LPValidateCustomCell.self))! {
            (cell as! LPValidateCustomCell).activateValidationButton(hasError: hasError)
        }
        
    }
    
    func inputTextFieldReturnClicked(tag: Int) {
        // Try to find next responder
        if let nextTextField = self.view.viewWithTag(tag+1) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - other delegates
    public func latestLocation(_ newLocation: CLLocation!, withError error: Error!) {
        MCMLocationService.sharedInstance().stopUpdatingLocation()
        
        if(error != nil) {
            self.showLocationServicesErrorAlert()
            (MCMLoadingManager.sharedInstance() as AnyObject).hideLoading()
        } else {
            MCMLocationService.reverseGeoCodeLocation(newLocation.coordinate, withCompletion: { (placeMarks) in
                (MCMLoadingManager.sharedInstance() as AnyObject).hideLoading()
                
                print("Done🔨")
                if (placeMarks != nil && placeMarks!.count > 0) {
                    //             CLPlacemark* placemark = placemarks.firstObject;
                    let placeMark = placeMarks?.first as! CLPlacemark
                    
                    let hybrisAddress = MCMLocationService.mapApplePlaceMark(toHybrisAddress: placeMark)
                    let auxUserAccount = MCMAddressToDictionaryMapper.mapHYBAddress(toUserAccount: hybrisAddress)
                    if let street = auxUserAccount?.street {
                        self.lpAddress.street = street
                    }
                    
                    self.lpAddress.postalCode = (auxUserAccount?.postalCode)!
                    self.lpAddress.locality = (auxUserAccount?.town)!
                    if (self.isCountryEnabled == true && self.isCountrieSupported(aCountry: (auxUserAccount?.countryName)!)) {
                        self.lpAddress.countryName = (auxUserAccount?.countryName)!
                        self.lpAddress.countryIsoCode = (auxUserAccount?.countryIsoCode)!
                    }
                    
                    self.tableItems?.removeAll()
                    self.tableItems = self.createTableViewCells(formContent: self.contentArray, isPro: self.isPro)
                    self.tableView.reloadData()
                    self.activateValidationButton()
                }
                
            }
            )
        }
    }
    
    func useMyPositionClicked() {
        (MCMLoadingManager.sharedInstance() as AnyObject).showLoading()
        
        MCMLocationService.sharedInstance().delegate = self
        self.locationServicesChecks()
    }
    
    func countryNameButtonClicked() {
        self.countriesPickerView.isHidden = false
    }
    
    
    func didChooseAddress(address: LPAddressEntity) {
        // by default set France as country
        if address.countryName.count == 0 {
            address.countryName = "France"
        }
        
        if (self.isCountryEnabled == true && self.isCountrieSupported(aCountry: address.countryName) == false) {
            address.countryName = self.lpAddress.countryName
        }
        
        self.saveChoosinAddress(address: address)
        self.lpAddress.countryIsoCode = MCMLocationService.isoCountryCode(fromName: self.lpAddress.countryName)
        
        self.tableItems?.removeAll()
        self.tableItems = self.createTableViewCells(formContent: self.contentArray, isPro: self.isPro)
        self.tableView.reloadData()
        self.activateValidationButton()
    }
    
    func saveChoosinAddress (address : LPAddressEntity) {
        //        self.lpAddress.placeIDForGooglePlaces = address.placeIDForGooglePlaces
        //        self.lpAddress.street = address.street
        //        self.lpAddress.locality = address.locality
        //        self.lpAddress.postalCode = address.postalCode
        //        self.lpAddress.countryName = address.countryName
    }
    
    // actions
    func locationServicesChecks() {
        if MCMLocationService.locationServicesEnabled() == true {
            MCMLocationService.sharedInstance().startUpdatingLocation()
        } else {
            let alert = UIAlertController(title: nil, message: "Autoriser l'application La Poste à accéder à la position de cet appareil ?", preferredStyle: UIAlertControllerStyle.alert)
            let alertAllowAction = UIAlertAction(title:"Autoriser", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            })
            
            let alertDenyAction = UIAlertAction(title:"Refuser", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in
                
            })
            
            alert.addAction(alertAllowAction)
            alert.addAction(alertDenyAction)
            self.present(alert, animated: true, completion: nil)
            
            (MCMLoadingManager.sharedInstance() as AnyObject).hideLoading()
        }
        
    }
    
    func showLocationServicesErrorAlert() {
        let alert = UIAlertController(title: "Woops!", message: "Erreur lors de l'extraction de la position actuelle", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Mascadia
    func checkMascadiaIfNeeded() {
        
        (MCMLoadingManager.sharedInstance() as AnyObject).showLoading()
        
        var street:String
        if (lpAddress.street.count == 0 && lpAddress.locality.range(of:"CEDEX") != nil) {
            street = lpAddress.locality
        } else {
            street = lpAddress.street
        }
        
        let mascadiaAddress = [hybris_address_dict_street_key: street,
                               hybris_address_dict_postal_code_key: self.lpAddress.postalCode,
                               hybris_address_dict_locality_key: self.lpAddress.complementaryAddress,
                               hybris_address_dict_town_key: self.lpAddress.locality]
        
        MCMAddressValidationService.validateAddress(mascadiaAddress, withCompletion: { (addressesArray, validationResult, error) in
            
            (MCMLoadingManager.sharedInstance() as AnyObject).hideLoading()
            
            if( LPAddressValidationService.mascadiaResultHasError(validationResult) == true) {
                // has error
                self.mascadiaAddresses = addressesArray
                self.localityAndPostalCodeMascadiaOK = validationResult!.ligne6Feu == mascadiaCorrectValueForTest
                self.performSegue(withIdentifier: kShowMascadiaFromAddressInput, sender: nil)
            } else {
                // good address
                if self.addressDelegate != nil {
                    self.addressDelegate?.didValidateFormButtonClicked(address: self.lpAddress)
                } else {
                    self.performSegue(withIdentifier: kUnwindFromAddressCreateAndEditVC, sender: nil)
                }
            }
        })
    }
    
    // MARK: - pickerview actions
    @IBAction func countriesPickerDone(_ sender: Any) {
        indexSelectedCountry = self.countriesPicker.selectedRow(inComponent: 0)
        
        self.countriesPickerView.isHidden = true
        pickerViewSelectedCountry(country: countriesArray[indexSelectedCountry].1 as! String)
        //        showOrHideContriesPicker(isShow: false)
        
    }
    
    @IBAction func countriesPickerCancel(_ sender: Any) {
        self.countriesPickerView.isHidden = true
        self.tableView.resignFirstResponder()
        self.countriesPicker.selectRow(indexSelectedCountry, inComponent: 0, animated: false)
        //        setSelectedCountriesPicker()
        //        showOrHideContriesPicker(isShow: false)
    }
    
    func showOrHideContriesPicker(isShow: Bool) {
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            var frame: CGRect = self.countriesPickerView.frame
            if isShow {
                if frame.origin.y != self.view.frame.size.height - frame.size.height {
                    frame.origin.y = self.view.frame.size.height - frame.size.height
                    let blurView = UIView(frame: self.tableView.frame)
                    blurView.tag = 223
                    blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    if self.tableView.viewWithTag(223) != nil {
                        self.tableView.addSubview(blurView)
                    }
                }
            }
            else {
                frame.origin.y = self.view.frame.size.height
            }
            self.countriesPickerView.frame = frame
        }, completion: {(_ finished: Bool) -> Void in
            if finished && !isShow {
                self.tableView.viewWithTag(223)?.removeFromSuperview()
            }
        })
        
    }
    
    
    // MARK: - PickerView delegates
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countriesArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.lpAddress.countryName = countriesArray[row].1 as! String
        self.lpAddress.countryIsoCode = MCMLocationService.isoCountryCode(fromName: self.lpAddress.countryName)
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countriesArray[row].1
    }
    
    func pickerViewSelectedCountry(country: String!) {
        self.lpAddress.countryName = country
        MCMLocationService.isoCountryCode(fromName: self.lpAddress.countryName)
        self.tableItems?.removeAll()
        self.tableItems = self.createTableViewCells(formContent: self.contentArray, isPro: self.isPro)
        self.tableView.reloadData()
        self.activateValidationButton()
    }
    
    // MARK: - Actions
    func setLocalityFromZipCode(zipCode: String) {
        
        MCMAddressValidationService.searchZipCode(zipCode, withCompletion:{(_ addressesArray, validationResult, error) in
            if addressesArray != nil {
                for address in addressesArray! {
                    var addressDic = address as! Dictionary<String,AnyObject>
                    if let ligne6 = addressDic[kJsonValue_Ligne6] {
                        self.tableView.endEditing(true)
                        self.lpAddress.locality = ligne6[kJsonValue_LibelleAcheminement] as! String
                        self.tableItems?.removeAll()
                        self.tableItems = self.createTableViewCells(formContent: self.contentArray, isPro: self.isPro)
                        self.tableView.reloadData()
                        self.activateValidationButton()
                        
                        return
                    }
                }
            }
        })
    }
    
    // MARK: - Utilities
    func isValidEmail(text:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    func isCountrieSupported(aCountry : String) -> Bool {
        for country in self.countriesArray {
            if (country.1).lowercased().range(of:aCountry.lowercased()) != nil {
                return true
            }
        }
        return false
    }
    
    func isValidName(name: String) -> Bool {
        let nameRegEx = "[A-Za-z-'‘’]*"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePredicate.evaluate(with: name)
    }
    
    func isValidPhone(phone:String, isInternational: Bool)->Bool{
        return phone.isValidPhone(isInternational: isInternational)
    }
    
    func getCountriesInfo()->[(String,String)]{
        var countries: [(String,String)] = []
        
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "fr_FR").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append((code,name))
        }
        print("👀  \(#function) 👀 \(countries)");
        return countries
        
    }
}

extension String{
    func isValidPhone(isInternational: Bool)->Bool{
        if isInternational {return true}
        let internalExpression : NSRegularExpression
        let frenchPattern = "^(06|07)[0-9'@s]{8,8}$"
        
        let internationalPattern = "^(\\+[0-9]|00)[0-9'@s]{0,18}$"

        let pattern = isInternational ? internationalPattern : frenchPattern
        do {
            internalExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch  {
            return false
        }
        let matches = internalExpression.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        return matches.count > 0
    }
}
