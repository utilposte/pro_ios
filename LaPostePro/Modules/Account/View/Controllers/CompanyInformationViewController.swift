//
//  CompanyInformationViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 05/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import CoreLocation
import MaterialComponents.MaterialTextFields
import UIKit

enum FormType {
    case create
    case update
}

enum FormPart {
    case enterprise
    case address
    case none
}

class CompanyInformationViewController: BaseViewController {
    // Mark: PROPRETIES
    private var pickerDataSource = [Any]()
    private let viewModel = CompanyInformationViewModel()
    
    // MARK: OUTLETS
    
    @IBOutlet var formScrollView: UIScrollView!
    @IBOutlet var formStackView: UIStackView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var pickerToolBarView: UIView!
    @IBOutlet var timeLineActiveStepIndicatorView: UIView!
    @IBOutlet var timeLineCurrentStepIndicatorView: UIView!
    @IBOutlet var timeLineHeightConstraint: NSLayoutConstraint!
    
    // MARK: FORM FIELD
    
    // Comapny fields
    var companyNameField: FormElementView!
    var companyTypeField: FormElementView!
    var companySiretField: FormElementView!
    var customerNumberField: FormElementView!
    var tvaField: FormElementView!
    var rnaNumField: FormElementView!
    
    var chorusView: ChorusView?
    var errorNoChorusView: ErrorNoChorusView?
    
    // Address fields
    var serviceField: FormElementView!
    var buildingField: FormElementView!
    var streetField: FormElementView!
    var placeField: FormElementView!
    var postalCodeField: FormElementView!
    var townField: FormElementView!
    var countryField: FormElementView!
    
    // Footer
    var formFooter: InscriptionFormFooter!
    
    // CGU with validationButton
    var cguView: CguView!
    
    var dataForm: UpdateFormModel?
    var formType: FormType?
    var formPart: FormPart = .none
    
    // MARK: PARAMETERS
    
    var currentPickerViewTextField: MDCTextField!
    var currentCountryIsoCode = "fr"
    var currentAction: FormElementDataPicker?
    var cguChecked = false
    
    // parameters to check if user changed his information to activate validation button in edit mode
    var didDataHasBeenEdited = false
    
    let locationManager = CLLocationManager()
    let geoLocationManager = GeolocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the navigation bar
        self.navigationController?.navigationBar.backItem?.title = "Retour"
        self.navigationController?.navigationBar.tintColor = .black

        self.setupTimeLine()
        // set the delegate of country and company type picker
        self.pickerView.delegate = self
        
        // ask for permission
        // use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        // create form
        if self.formType == .create {
            self.createDefaultField()
            
            self.navigationItem.title = "Création de compte"
            
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kActivity,
                                                                 chapter1: TaggingData.kRegister,
                                                                 chapter2: nil,
                                                                 level2: TaggingData.kAccountLevel)
            
        } else if self.formType == .update {
            timeLineHeightConstraint.constant = 0
            self.setInactiveNavigationBarButton()
            self.updateField()
            self.navigationItem.title = "Modifier le profil"
            
            if self.formPart == .address {
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kEditAddress,
                                                                     chapter1: TaggingData.kYourProfile,
                                                                     chapter2: TaggingData.kEntreprise,
                                                                     level2: TaggingData.kAccountLevel)
            } else if self.formPart == .enterprise {
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kEditInformations,
                                                                     chapter1: TaggingData.kYourProfile,
                                                                     chapter2: TaggingData.kEntreprise,
                                                                     level2: TaggingData.kAccountLevel)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setActiveNavigationBarButton() {
        let valideBarButton = UIBarButtonItem(title: "Confirmer", style: .plain, target: self, action: #selector(CompanyInformationViewController.updateForm))
        valideBarButton.tintColor = .lpPurple
        self.navigationItem.rightBarButtonItem = valideBarButton
    }
    
    private func setInactiveNavigationBarButton() {
        let valideBarButton = UIBarButtonItem(title: "Confirmer", style: .plain, target: self, action: nil)
        valideBarButton.tintColor = .lpGrey
        self.navigationItem.rightBarButtonItem = valideBarButton
    }
    
    private func setupTimeLine() {
        self.timeLineActiveStepIndicatorView.cornerRadius = self.timeLineActiveStepIndicatorView.frame.width / 2
        
        self.timeLineCurrentStepIndicatorView.layer.borderWidth = 2
        self.timeLineCurrentStepIndicatorView.layer.borderColor = UIColor.lpPurple.cgColor
        self.timeLineCurrentStepIndicatorView.cornerRadius = self.timeLineCurrentStepIndicatorView.frame.width / 2
    }
    
    private func createDefaultField() {
        if let headerView = Bundle.main.loadNibNamed("FormHeader", owner: nil, options: nil)?.first as? FormHeader {
            formStackView.addArrangedSubview(headerView)
        }
        
        //title view
        let companyTitle = FormTitleView(title: "Mon entreprise")
        formStackView.addArrangedSubview(companyTitle)
        
        // Company name field
        let companyNameStruct = FormElementStruct(placeholder: "Saisissez la raison sociale", helperText: "", errorText: "La raison sociale est obligatoire", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .raisonSocial)
        companyNameField = FormElementView(companyNameStruct)
        companyNameField.delegate = self
        formStackView.addArrangedSubview(companyNameField)
        
        // Company type field
        let companyTypeStruct = FormElementStruct(placeholder: "Sélectionnez le type de société", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .picker(type: .company(companyTypeList: viewModel.companyTypeList)), isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        companyTypeField = FormElementView(companyTypeStruct)
        companyTypeField.delegate = self
        formStackView.addArrangedSubview(companyTypeField)
        
        // Siret Field
        let siretStruct = FormElementStruct(placeholder: "SIRET", helperText: "", errorText: "", isRequired: true, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .siret)
        companySiretField = FormElementView(siretStruct)
        companySiretField.delegate = self
        formStackView.addArrangedSubview(companySiretField)
        
        // NoChorusView
        if let errorNoChorusView = ErrorNoChorusView.getErrorNoChorusView() {
            self.errorNoChorusView = errorNoChorusView
            self.errorNoChorusView?.isHidden = true
            formStackView.addArrangedSubview(errorNoChorusView)
        }
        
        // Chorus View
        if let chorusView = Bundle.main.loadNibNamed("ChorusView", owner: self, options: nil)?.first as? ChorusView {
            self.chorusView = chorusView
            self.chorusView?.isHidden = true
            self.chorusView?.delegate = self
            formStackView.addArrangedSubview(chorusView)
        }
        
        // Customer number field
        let customerStruct = FormElementStruct(placeholder: "N° Client", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .customerId)
        customerNumberField = FormElementView(customerStruct)
        customerNumberField.delegate = self
        formStackView.addArrangedSubview(customerNumberField)
        
        // TVA field
        let tvaStruct = FormElementStruct(placeholder: "TVA intra communautaire", helperText: "", errorText: "", isRequired: true, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        tvaField = FormElementView(tvaStruct)
        tvaField.delegate = self
        formStackView.addArrangedSubview(tvaField)
        
        // N° RNA field
        let rnaStruct = FormElementStruct(placeholder: "N° RNA", helperText: "", errorText: "", isRequired: true, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        rnaNumField = FormElementView(rnaStruct)
        rnaNumField.delegate = self
        formStackView.addArrangedSubview(rnaNumField)
        
        //title view for address
        let addressTitle = FormTitleView(title: "Adresse postale professionnelle")
        formStackView.addArrangedSubview(addressTitle)
        
        // Use position view
        if let usePositionView = Bundle.main.loadNibNamed("UsePosition", owner: nil, options: nil)?.first as? UsePosition {
            usePositionView.setup()
            usePositionView.delegate = self
            formStackView.addArrangedSubview(usePositionView)
        }
        
        // Service field
        let serviceStruct = FormElementStruct(placeholder: "Service", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        serviceField = FormElementView(serviceStruct)
        serviceField.delegate = self
        formStackView.addArrangedSubview(serviceField)
        
        // Building field
        let buildingStruct = FormElementStruct(placeholder: "Bâtiment, Immeuble", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        buildingField = FormElementView(buildingStruct)
        buildingField.delegate = self
        formStackView.addArrangedSubview(buildingField)
        
        // street field
        let streetStruct = FormElementStruct(placeholder: "N° et libellé de la voie", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        streetField = FormElementView(streetStruct)
        streetField.delegate = self
        formStackView.addArrangedSubview(streetField)
        
        // place field
        let placeStruct = FormElementStruct(placeholder: "Lieu-dit ou BP", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        placeField = FormElementView(placeStruct)
        placeField.delegate = self
        formStackView.addArrangedSubview(placeField)
        
        // Postal code field
        let postalCodeStruct = FormElementStruct(placeholder: "Code Postal", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .postalCode)
        postalCodeField = FormElementView(postalCodeStruct)
        postalCodeField.delegate = self
        formStackView.addArrangedSubview(postalCodeField)
        
        // Locality field
        let localityStruct = FormElementStruct(placeholder: "Localité", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        townField = FormElementView(localityStruct)
        townField.delegate = self
        formStackView.addArrangedSubview(townField)
        
        // Pays field
        let countryStruct = FormElementStruct(placeholder: "Pays", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .picker(type: .country(countryList: viewModel.countryList)), isSecured: false, defaultValue: Constants.defaultCountryForInscription, shouldSeePassword: false, elementType: .none)
        countryField = FormElementView(countryStruct)
        countryField.delegate = self
        formStackView.addArrangedSubview(countryField)
        
        // Footer
        if let inscriptionFormFooter = Bundle.main.loadNibNamed("InscriptionFormFooter", owner: nil, options: nil)?.first as? InscriptionFormFooter {
            self.formFooter = inscriptionFormFooter
            inscriptionFormFooter.setup()
            inscriptionFormFooter.delegate = self
            formStackView.addArrangedSubview(inscriptionFormFooter)
        }
        
        // CGU
        if let cguView = Bundle.main.loadNibNamed("CguView", owner: nil, options: nil)?.first as? CguView {
            self.cguView = cguView
            cguView.delegate = self
            cguView.setup()
            formStackView.addArrangedSubview(cguView)
            self.activateValidationButton()
        }
        
        // RGPD
        if let rgpdView = Bundle.main.loadNibNamed("RgpdView", owner: nil, options: nil)?.first as? RgpdView {
            rgpdView.setupText()
            formStackView.addArrangedSubview(rgpdView)
        }
    }
    
    private func updateField() {
        if self.formPart == .enterprise {
            if let headerView = Bundle.main.loadNibNamed("FormHeader", owner: nil, options: nil)?.first as? FormHeader {
                formStackView.addArrangedSubview(headerView)
            }
            
            //title view
            let companyTitle = FormTitleView(title: "Modifier mon entreprise")
            formStackView.addArrangedSubview(companyTitle)
        }
        
        // Company name field
        let companyNameStruct = FormElementStruct(placeholder: "Saisissez la raison sociale", helperText: "", errorText: "La raison sociale est obligatoire", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.companyName, shouldSeePassword: false, elementType: .raisonSocial)
        companyNameField = FormElementView(companyNameStruct)
        companyNameField.delegate = self
        formStackView.addArrangedSubview(companyNameField)
        
        // Company type field
        let companyTypeStruct = FormElementStruct(placeholder: "Sélectionnez le type de société", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .picker(type: .company(companyTypeList: viewModel.companyTypeList)), isSecured: false, defaultValue: UserAccount.shared.customerInfo?.companyTypeName, shouldSeePassword: false, elementType: .none)
        companyTypeField = FormElementView(companyTypeStruct)
        companyTypeField.delegate = self
        formStackView.addArrangedSubview(companyTypeField)
        
        // Siret Field
        let siretStruct = FormElementStruct(placeholder: "SIRET", helperText: "", errorText: "", isRequired: true, isDisplayed: false, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.siret, shouldSeePassword: false, elementType: .siret)
        companySiretField = FormElementView(siretStruct)
        companySiretField.delegate = self
        formStackView.addArrangedSubview(companySiretField)
        
        // NoChorusView
        if let errorNoChorusView = ErrorNoChorusView.getErrorNoChorusView() {
            self.errorNoChorusView = errorNoChorusView
            self.errorNoChorusView?.isHidden = true
            formStackView.addArrangedSubview(errorNoChorusView)
        }
        
        // chorus View
        if let chorusView = Bundle.main.loadNibNamed("ChorusView", owner: self, options: nil)?.first as? ChorusView {
            self.chorusView = chorusView
            self.chorusView?.isHidden = true
            self.chorusView?.delegate = self
            formStackView.addArrangedSubview(chorusView)
        }
        
        // Customer number field
        let customerStruct = FormElementStruct(placeholder: "N° Client", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.coclicoClientNumber, shouldSeePassword: false, elementType: .customerId)
        customerNumberField = FormElementView(customerStruct)
        customerNumberField.delegate = self
        formStackView.addArrangedSubview(customerNumberField)
        
        // TVA field
        let tvaStruct = FormElementStruct(placeholder: "TVA intra communautaire", helperText: "", errorText: "", isRequired: true, isDisplayed: false, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.tvaIntra, shouldSeePassword: false, elementType: .none)
        tvaField = FormElementView(tvaStruct)
        tvaField.delegate = self
        formStackView.addArrangedSubview(tvaField)
        
        // N° RNA field
        let rnaStruct = FormElementStruct(placeholder: "N° RNA", helperText: "", errorText: "", isRequired: true, isDisplayed: false, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.rna, shouldSeePassword: false, elementType: .none)
        rnaNumField = FormElementView(rnaStruct)
        rnaNumField.delegate = self
        formStackView.addArrangedSubview(rnaNumField)
        
        if self.formPart == .address {
            //title view for address
            let addressTitle = FormTitleView(title: "Adresse postale professionnelle")
            formStackView.addArrangedSubview(addressTitle)
            
            // Use position view
            if let usePositionView = Bundle.main.loadNibNamed("UsePosition", owner: nil, options: nil)?.first as? UsePosition {
                usePositionView.setup()
                usePositionView.delegate = self
                formStackView.addArrangedSubview(usePositionView)
            }
        }
        
        // Service field
        let serviceStruct = FormElementStruct(placeholder: "Service", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        serviceField = FormElementView(serviceStruct)
        serviceField.delegate = self
        formStackView.addArrangedSubview(serviceField)
        
        // Building field
        let buildingStruct = FormElementStruct(placeholder: "Bâtiment, Immeuble", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        buildingField = FormElementView(buildingStruct)
        buildingField.delegate = self
        formStackView.addArrangedSubview(buildingField)
        
        // street field
        let streetStruct = FormElementStruct(placeholder: "N° et libellé de la voie", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.defaultAddress?.line2, shouldSeePassword: false, elementType: .none)
        streetField = FormElementView(streetStruct)
        streetField.delegate = self
        formStackView.addArrangedSubview(streetField)
        
        // place field
        let placeStruct = FormElementStruct(placeholder: "Lieu-dit ou BP", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        placeField = FormElementView(placeStruct)
        placeField.delegate = self
        formStackView.addArrangedSubview(placeField)
        
        // Postal code field
        let postalCodeStruct = FormElementStruct(placeholder: "Code Postal", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.defaultAddress?.postalCode, shouldSeePassword: false, elementType: (UserAccount.shared.customerInfo?.defaultAddress?.country?.name!.elementsEqual(Constants.defaultCountryForInscription))! ? .postalCode : .internationalPostalCode)
        postalCodeField = FormElementView(postalCodeStruct)
        postalCodeField.delegate = self
        formStackView.addArrangedSubview(postalCodeField)
        
        // Locality field
        let localityStruct = FormElementStruct(placeholder: "Localité", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.defaultAddress?.town, shouldSeePassword: false, elementType: .none)
        townField = FormElementView(localityStruct)
        townField.delegate = self
        formStackView.addArrangedSubview(townField)
        
        // Pays field
        let countryStruct = FormElementStruct(placeholder: "Pays", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .picker(type: .country(countryList: viewModel.countryList)), isSecured: false, defaultValue: UserAccount.shared.customerInfo?.defaultAddress?.country?.name, shouldSeePassword: false, elementType: .none)
        countryField = FormElementView(countryStruct)
        countryField.delegate = self
        formStackView.addArrangedSubview(countryField)
        
//        //Footer
//        if let inscriptionFormFooter = Bundle.main.loadNibNamed("InscriptionFormFooter", owner: nil, options: nil)?.first as? InscriptionFormFooter {
//            self.formFooter = inscriptionFormFooter
//            inscriptionFormFooter.setup()
//            inscriptionFormFooter.delegate = self
//            formStackView.addArrangedSubview(inscriptionFormFooter)
//        }
        
        // CGU
        if let cguView = Bundle.main.loadNibNamed("CguView", owner: nil, options: nil)?.first as? CguView {
            self.cguView = cguView
            cguView.delegate = self
            cguView.setup()
            formStackView.addArrangedSubview(cguView)
            self.activateValidationButton()
        }
        
        if self.formPart == .address {
            self.showAddress()
        } else if self.formPart == .enterprise {
            self.showEnterprise()
            if !companySiretField.getText().isEmpty, companyTypeField.getText().elementsEqual(Constants.publicSectorCompanyTypeKey) {
                self.checkChorus(with: companySiretField.getText())
            }
            // Apply roles
            self.currentAction = .country(countryList: viewModel.countryList)
            createForm(with: UserAccount.shared.customerInfo?.defaultAddress?.country?.name ?? "")
            self.currentAction = .company(companyTypeList: viewModel.companyTypeList)
            createForm(with: UserAccount.shared.customerInfo?.companyTypeName ?? "")
        }
        // Fix APPPRO-1215
        checkActivateFields()
    }
    
    func checkActivateFields() {
        let noCertified = (UserAccount.shared.customerInfo?.certifiedEtatCode != "certified")
        companySiretField.isUserInteractionEnabled = noCertified
        tvaField.isUserInteractionEnabled = noCertified
        rnaNumField.isUserInteractionEnabled = noCertified
        customerNumberField.isUserInteractionEnabled = false
    }
    
    private func showAddress() {
        serviceField.isHidden = false
        buildingField.isHidden = false
        streetField.isHidden = false
        placeField.isHidden = false
        postalCodeField.isHidden = false
        townField.isHidden = false
        countryField.isHidden = false
        
        companyNameField.isHidden = true
        companyTypeField.isHidden = true
        companySiretField.isHidden = true
        customerNumberField.isHidden = true
        tvaField.isHidden = true
        rnaNumField.isHidden = true
        cguView.isHidden = true
    }
    
    private func showEnterprise() {
        serviceField.isHidden = true
        buildingField.isHidden = true
        streetField.isHidden = true
        placeField.isHidden = true
        postalCodeField.isHidden = true
        townField.isHidden = true
        countryField.isHidden = true
        cguView.isHidden = true
        
        companyNameField.isHidden = false
        companyTypeField.isHidden = false
        companySiretField.isHidden = true
        customerNumberField.isHidden = true
        tvaField.isHidden = true
        rnaNumField.isHidden = true
    }
    
    @IBAction func pickerViewCancelButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.pickerToolBarView.isHidden = true
            self.pickerView?.isHidden = true
        }
    }
    
    @IBAction func pickerViewValidateButtonClicked(_ sender: Any?) {
        if currentPickerViewTextField != nil {
            currentPickerViewTextField.text = self.currentAction?.value[pickerView.selectedRow(inComponent: 0)]
        }
        
        if self.currentPickerViewTextField == self.countryField.textfield {
            if let isocode = self.viewModel.countryList[pickerView.selectedRow(inComponent: 0)].isocode {
                self.currentCountryIsoCode = isocode
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.pickerToolBarView.isHidden = true
            self.pickerView?.isHidden = true
        }
        createForm(with: self.currentAction?.value[pickerView.selectedRow(inComponent: 0)] ?? "")
        activateValidationButton()
    }
    
    private func createForm(with data: String) {
        switch currentAction {
        case .country?:
            createForm(withCountry: data)
        case .company?:
            createForm(WithCompanyType: data)
        case .chorus?:
            self.chorusView?.setText(serviceText: data)
        default:
            break
        }
    }
}

extension CompanyInformationViewController: FormElementViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func textFieldDidEndEditing(textfield: UITextField, textType: FormElementInputTextType) {
        pickerViewCancelButtonClicked(self)
        if viewModel.getCompagnyCode(companyType: companyTypeField.getText()) == "publicSector" {
            if textType == .siret, textfield.text?.count == 14 {
                checkChorus(with: textfield.text!)
            }
        }
        activateValidationButton()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataSource[row] as? String
    }
    
    func textfieldDidTapped(textfield: MDCTextField, action: FormElementDataPicker) {
        self.view.endEditing(true)
        self.currentAction = action
        self.currentPickerViewTextField = textfield
        self.pickerDataSource = action.value
        self.pickerToolBarView.isHidden = false
        self.pickerView?.isHidden = false
        self.pickerView?.reloadAllComponents()
    }
    
    // MARK: Form rule methods
    
    func createForm(WithCompanyType companyType: String) {
        UIView.animate(withDuration: 0.2, animations: {
            // Siret
            self.companySiretField.isHidden = false
            
            var required = false
            if Constants.requiredSiretCompanyTypeList.contains(companyType) == true {
                if self.viewModel.getFormBuilder(for: self.countryField.getText())?.SIRET_obligatoire?.elementsEqual("OUI") == true {
                    required = true
                }
            }
            self.setSiretField(required: required)
            
            // Customer number field
            self.customerNumberField.isHidden = false
            
            // TVA field
            self.setTVAField(isDisplayed: self.viewModel.getFormBuilder(for: self.countryField.getText())?.TVA_intracommunautaire?.elementsEqual("OUI") ?? true, requiered: self.isTVARequired(companyType: companyType))
            
            // RNA field
            let isAssociation = companyType.elementsEqual(Constants.associationCompanyTypeKey)
            self.rnaNumField.isHidden = !isAssociation
            self.setRnaNumberField(isAssociation: isAssociation, country: self.countryField.getText())
        })
        // CheckChorus
        self.setChorusView(isPublicSector: companyType.elementsEqual(Constants.publicSectorCompanyTypeKey), siretNumber: companySiretField.getText())
    }
    
    private func createForm(withCountry country: String) {
        // Siret Required
        var required = false
        if Constants.requiredSiretCompanyTypeList.contains(self.companyTypeField.getText()) == true {
            if viewModel.getFormBuilder(for: country)?.SIRET_obligatoire?.elementsEqual("OUI") == true {
                required = true
            }
        }
        setSiretField(required: required)
        
        // TVA required
        if !self.companyTypeField.getText().isEmpty {
            setTVAField(isDisplayed: viewModel.getFormBuilder(for: country)?.TVA_intracommunautaire?.elementsEqual("OUI") ?? true, requiered: isTVARequired(companyType: companyNameField.getText().tmpChangeSpecialCharacters()))
        }
        
        // RNA Number
        if !companyTypeField.getText().isEmpty {
            setRnaNumberField(isAssociation: companyTypeField.getText().elementsEqual(Constants.associationCompanyTypeKey), country: country)
        }
        
        // Postal Code
        if !country.elementsEqual(Constants.defaultCountryForInscription) {
            let postalCodeStruct = FormElementStruct(placeholder: "Code Postal", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .internationalPostalCode)
            postalCodeField.initViews(formStruct: postalCodeStruct)
        }
    }
    
    private func activateValidationButton() {
        // TODO: validate check
        if self.formType == .create {
            self.cguView.enableValidation(with: Constants.createAccountButtonText)
            if checkFormValidity(showError: false) {
                self.cguView.enableValidation(with: Constants.createAccountButtonText)
            } else {
                self.cguView.disableValidation(with: Constants.createAccountButtonText)
            }
        } else {
            if didInfoHasBeenUpdated() {
                setActiveNavigationBarButton()
            } else {
                setInactiveNavigationBarButton()
            }
        }
    }
    
    private func isTVARequired(companyType: String) -> Bool {
        return Constants.requiredTVACompanyTypeList.contains(companyType)
    }
    
    func clearErrors() {
        serviceField.noErrorStyle()
        buildingField.noErrorStyle()
        streetField.noErrorStyle()
        placeField.noErrorStyle()
        postalCodeField.noErrorStyle()
        townField.noErrorStyle()
        countryField.noErrorStyle()
        
        companyNameField.noErrorStyle()
        companyTypeField.noErrorStyle()
        companySiretField.noErrorStyle()
        customerNumberField.noErrorStyle()
        tvaField.noErrorStyle()
        rnaNumField.noErrorStyle()
    }
}

// MARK: EDIT FORM FIELD

extension CompanyInformationViewController {
    private func setSiretField(required: Bool) {
        let siretStruct = FormElementStruct(placeholder: "SIRET", helperText: "", errorText: "", isRequired: required, isDisplayed: !companySiretField.isHidden, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .siret)
        companySiretField.initViews(formStruct: siretStruct)
    }
    
    private func setTVAField(isDisplayed: Bool, requiered: Bool) {
        if !isDisplayed {
            tvaField.isHidden = true
            return
        }
        let tvaStruct = FormElementStruct(placeholder: "TVA intra communautaire", helperText: "", errorText: "", isRequired: requiered, isDisplayed: isDisplayed, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        tvaField.initViews(formStruct: tvaStruct)
    }
    
    private func setRnaNumberField(isAssociation: Bool, country: String) {
        let rnaStruct = FormElementStruct(placeholder: "N° RNA", helperText: "", errorText: "", isRequired: country.elementsEqual(Constants.defaultCountryForInscription), isDisplayed: isAssociation, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        rnaNumField.initViews(formStruct: rnaStruct)
    }
    
    private func setChorusView(isPublicSector: Bool, siretNumber: String?) {
        clearChorusViews()
        if isPublicSector == true, siretNumber?.count == 14 {
            self.checkChorus(with: siretNumber ?? "")
        }
    }
}

extension CompanyInformationViewController: inscriptionFormFooterDelegate, CGUDelegate {
    func cguChecked(cguChecked: Bool) {
        self.cguChecked = cguChecked
        activateValidationButton()
    }
    
    func validateForm() {
        if cguChecked {
            // TODO: Check = checkFormValidity
//            let isValid = checkFormValidity(showError: true)
//            if isValid && countryField.getText() == Constants.defaultCountryForInscription {
            // Create address to check with mascadia
            //                let aAddress = createAddressForSarcadiaCheck()
            //                viewModel.checkAddress(address: aAddress)
            self.clearErrors()
            dataForm?.companyName = companyNameField.getText().tmpChangeSpecialCharacters()
            dataForm?.companyTypeCode = viewModel.getCompagnyCode(companyType: companyTypeField.getText())
            if !(chorusView?.isHidden ?? true) {
                dataForm?.serviceCode = viewModel.getChorusCode(serviceName: (chorusView?.getText())!)
            }
            
            dataForm?.localite = townField.getText()
            dataForm?.countryCode = currentCountryIsoCode
            dataForm?.siret = companySiretField.getText()
            dataForm?.coclicoClientNumber = customerNumberField.getText()
            dataForm?.codePostal = postalCodeField.getText()
            dataForm?.tvaIntra = tvaField.getText()
            dataForm?.numLibelle = streetField.getText()
            dataForm?.appartement = serviceField.getText()
            dataForm?.batiment = buildingField.getText()
            dataForm?.rna = rnaNumField.getText()
            
            let generatedData = AccountNetworkManager().generateSignature(dataForm: dataForm!)
            dataForm?.signature = generatedData?.signature
            dataForm?.time = generatedData?.time
            self.viewModel.loaderManager.showLoderView()
            if MascadiaVerificationViewModel().kMascadia_Iso_Code_Countries_List.contains(dataForm?.countryCode ?? "fr") {
                MascadiaVerificationViewModel().verifyAddress(dataForm: dataForm!, onCompletion: { addressList, isGoodAddress in
                    if isGoodAddress {
                        self.register(formData: self.dataForm!)
                    } else {
                        self.viewModel.loaderManager.hideLoaderView()
                        let mascadiaViewController = R.storyboard.account.mascadiaVerificationViewController()!
                        mascadiaViewController.viewModel.mascadiaAddressArray = addressList
                        mascadiaViewController.viewModel.formData = self.dataForm!
                        mascadiaViewController.delegate = self
                        self.present(mascadiaViewController, animated: true, completion: nil)
                    }
                })
            } else {
                register(formData: dataForm!)
            }
        } else {
            showCGUError()
        }
    }
    
    @objc func updateForm() {
        self.clearErrors()
        if !checkFormValidity(showError: true) {
            return
        }
        dataForm?.localite = townField.getText()
        dataForm?.countryCode = countryField.getText()
        dataForm?.codePostal = postalCodeField.getText()
        dataForm?.numLibelle = streetField.getText()
        dataForm?.countryCode = currentCountryIsoCode.lowercased()
        dataForm?.tvaIntra = tvaField.getText()
        dataForm?.siret = companySiretField.getText()
        dataForm?.coclicoClientNumber = customerNumberField.getText()
        dataForm?.companyName = companyNameField.getText().tmpChangeSpecialCharacters()
        dataForm?.companyTypeCode = viewModel.getCompagnyCode(companyType: companyTypeField.getText())
        if dataForm?.companyTypeCode?.elementsEqual("association") ?? false {
            dataForm?.rna = rnaNumField.getText()
        }
        
        if dataForm?.companyTypeCode?.elementsEqual("publicSector") ?? false {
            if !(chorusView?.isHidden ?? true) {
                dataForm?.serviceCode = viewModel.getChorusCode(serviceName: (chorusView?.getText())!)
            }
            else {
                dataForm?.serviceCode = UserAccount.shared.customerInfo?.serviceCode
            }
        }
        
        let generatedData = AccountNetworkManager().generateSignature(dataForm: dataForm!)
        dataForm?.signature = generatedData?.signature
        dataForm?.time = generatedData?.time
        self.viewModel.loaderManager.showLoderView()
//        if (dataForm?.countryCode?.elementsEqual("fr"))!, formPart == .address {
        if MascadiaVerificationViewModel().kMascadia_Iso_Code_Countries_List.contains(dataForm?.countryCode ?? "fr"), formPart == .address {
            MascadiaVerificationViewModel().verifyAddress(dataForm: dataForm!, onCompletion: { addressList, isGoodAddress in
                if isGoodAddress {
                    self.update(self.dataForm!)
                } else {
                    self.viewModel.loaderManager.hideLoaderView()
                    let mascadiaViewController = R.storyboard.account.mascadiaVerificationViewController()!
                    mascadiaViewController.viewModel.mascadiaAddressArray = addressList
                    mascadiaViewController.viewModel.formData = self.dataForm!
                    mascadiaViewController.delegate = self
                    self.present(mascadiaViewController, animated: true, completion: nil)
                }
            })
        } else {
            self.update(dataForm!)
        }
    }
    
    private func register(acceptError: Bool = false, formData: UpdateFormModel) {
        self.viewModel.loaderManager.showLoderView()
        self.viewModel.inscription(acceptError: acceptError, dataForm: formData, onCompletion: { errors in
            self.viewModel.loaderManager.hideLoaderView()
            if errors == nil {
                // Reset Home Frandole's data
                FrandoleViewModel.sharedInstance.list = [Frandole]()
                self.gotoHome()
                // Adjust
                AdjustTaggingManager.sharedManager.trackEventToken(AdjustTaggingManager.kInscriptionToken)
            } else {
                self.showError(isSubscribe: true, formData: formData, errors: errors!)
            }
        })
    }
    
    private func update(acceptError: Bool = false, _ form: UpdateFormModel) {
        let accountNetworkManager = AccountNetworkManager()
        self.viewModel.loaderManager.showLoderView()
        accountNetworkManager.updateCompanyInfo(acceptError: acceptError, userInfo: form) { errors in
            self.viewModel.loaderManager.hideLoaderView()
            if errors == nil {
                self.navigationController?.popViewController(animated: true)
                if self.formPart == .address {
                    // ATInternet
                    ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kConfirmerAdressePostale, pageName: nil, chapter1: TaggingData.kYourProfile, chapter2: TaggingData.kEntreprise, level2: TaggingData.kAccountLevel)
                } else if self.formPart == .enterprise {
                    // ATInternet
                    ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kConfirmerModificationInformations, pageName: nil, chapter1: TaggingData.kYourProfile, chapter2: TaggingData.kEntreprise, level2: TaggingData.kAccountLevel)
                }
            } else {
                self.showError(isSubscribe: false, formData: form, errors: errors!)
            }
        }
    }
    
    func showError(isSubscribe: Bool, formData: UpdateFormModel, errors: [AccountNetworkError]) {
        var canAcceptError = true
        var isFirstPart = false
        var showDefaultError = true
        var popinString = ""
        var firstPartPopinString = ""
        
        for tmpError in errors {
            if tmpError.canSubscribe == false {
                canAcceptError = false
                if tmpError.type.isFirstPart {
                    isFirstPart = true
                    firstPartPopinString = firstPartPopinString + "• " + (tmpError.message ?? "") + "\n"
                }
            } else {
                popinString = popinString + "• " + (tmpError.message ?? "") + "\n"
            }
            
            switch tmpError.type {
            case .rna:
                showDefaultError = false
                self.rnaNumField.setupErrorStyle(errorText: tmpError.message ?? "")
            case .siret:
                showDefaultError = false
                self.companySiretField.setupErrorStyle(errorText: tmpError.message ?? "")
            case .tvaIntra:
                showDefaultError = false
                self.tvaField.setupErrorStyle(errorText: tmpError.message ?? "")
            case .postalcode(value: .mismatch):
                showDefaultError = false
                if formType == .update, formPart == .enterprise {
                    if let siret = formData.siret, !siret.isEmpty {
                        self.companySiretField.setupErrorStyle(errorText: tmpError.message ?? "")
                    } else {
                        self.rnaNumField.setupErrorStyle(errorText: tmpError.message ?? "")
                    }
                } else {
                    self.postalCodeField.setupErrorStyle(errorText: tmpError.message ?? "")
                }
            default:
                break
            }
        }
        
        if canAcceptError {
            popinString = popinString + "\n\n Souhaitez-vous malgré tout \(isSubscribe ? "créer" : "modifier") votre compte ?"
            let alert = UIAlertController(title: nil, message: popinString, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Non", style: .destructive, handler: { _ in })
            let alertAction = UIAlertAction(title: "Oui", style: .default, handler: { _ in
                if isSubscribe {
                    self.register(acceptError: true, formData: formData)
                } else {
                    self.update(acceptError: true, formData)
                }
            })
            alert.addAction(cancelAction)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        else if isFirstPart {
            let alert = UIAlertController(title: "Attention", message: firstPartPopinString, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in })
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        else if showDefaultError {
            let alert = UIAlertController(title: "Attention", message: "Une erreur est survenue : Erreur Inconnu", dismissActionTitle: "OK", dismissActionBlock: {})
            self.present(alert!, animated: true, completion: nil)
        }
    }
    
    func displayOptionalAddressField(hide: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.serviceField.isHidden = hide
            self.buildingField.isHidden = hide
            self.placeField.isHidden = hide
        }
    }
    
    private func checkFormValidity(showError: Bool) -> Bool {
        var allFieldAreValid = true
        if showError == false {
            allFieldAreValid = self.cguChecked
        }
        for fieldView in formStackView.arrangedSubviews {
            if fieldView.isKind(of: FormElementView.self) {
                if (fieldView as! FormElementView).isRequired(), !fieldView.isHidden {
                    if (fieldView as! FormElementView).getText().isEmpty {
                        allFieldAreValid = false
                        if showError {
                            (fieldView as! FormElementView).setupErrorStyle(errorText: (fieldView as! FormElementView).currentFormStruct?.errorText ?? "Veuillez remplir ce champs")
                        }
                    } else {
                        (fieldView as! FormElementView).noErrorStyle()
                    }
                }
            } else if fieldView.isKind(of: ChorusView.self) {
                if !(self.chorusView?.isHidden ?? true), self.viewModel.serviceList?.count ?? 0 > 0 {
                    if (chorusView?.getText().elementsEqual(Constants.chorusButtonDefaultText))! {
                        allFieldAreValid = false
                    }
                }
            }
        }
        return allFieldAreValid
    }
    
    private func showCGUError() {
        let cguNotAcceptedAlert = UIAlertController(title: "Veuillez accepter les Conditions générale", message: "Sans votre accord pour les CGU on est dans l'obligation de ne pas créer le compte", dismissActionTitle: "OK", dismissActionBlock: {})
        self.present(cguNotAcceptedAlert!, animated: true, completion: nil)
    }
    
    private func createAddressForSarcadiaCheck() -> [String: String] {
        var address = [String: String]()
        address[Constants.hybris_address_dict_building_key] = buildingField.getText()
        address[Constants.hybris_address_dict_street_key] = streetField.getText()
        address[Constants.hybris_address_dict_locality_key] = placeField.getText()
        address[Constants.hybris_address_dict_town_key] = townField.getText()
        address[Constants.hybris_address_dict_postal_code_key] = postalCodeField.getText()
        return address
    }
    
    private func didInfoHasBeenUpdated() -> Bool {
        for fieldView in formStackView.arrangedSubviews {
            if fieldView.isKind(of: FormElementView.self) {
                if !fieldView.isHidden {
                    if !(fieldView as! FormElementView).getText().elementsEqual((fieldView as! FormElementView).currentFormStruct?.defaultValue ?? "") {
                        return true
                    }
                }
            } else if fieldView.isKind(of: ChorusView.self) {
                if !(self.chorusView?.isHidden ?? true), self.viewModel.serviceList?.count ?? 0 > 0 {
                    if (chorusView?.getText().elementsEqual(Constants.chorusButtonDefaultText))! {
                        return false
                    }
                }
            }
        }
        return false
    }
}

extension CompanyInformationViewController: CLLocationManagerDelegate, UsePositionDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        getUserAddressFromLocation(location: locValue)
    }
    
    private func getUserAddressFromLocation(location: CLLocationCoordinate2D) {
        geoLocationManager.geocode(latitude: location.latitude, longitude: location.longitude) { placemark, error in
            self.viewModel.loaderManager.hideLoaderView()
            guard let placemark = placemark, error == nil else { return }
            DispatchQueue.main.async {
                //  update UI here
                self.setAddress(placemark: placemark)
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func usePositionToGetAddress() {
        if CLLocationManager.locationServicesEnabled(), CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            self.viewModel.loaderManager.showLoderView()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // TODOs: Change text
            let alertController = UIAlertController(title: nil, message: "Merci de permettre à l’application d’accéder à votre position pour préremplir votre adresse actuelle et faciliter votre saisie.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Paramètres", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            let cancelAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func setAddress(placemark: CLPlacemark) {
        if placemark.subThoroughfare != nil, placemark.thoroughfare != nil {
            self.streetField.setText(text: "\(placemark.subThoroughfare!) \(placemark.thoroughfare!)")
        } else if placemark.subThoroughfare == nil, placemark.thoroughfare != nil {
            self.streetField.setText(text: "\(placemark.thoroughfare!)")
        }
        
        if placemark.locality != nil {
            townField.setText(text: placemark.locality!)
        }
        
        if placemark.postalCode != nil {
            postalCodeField.setText(text: placemark.postalCode!)
        }
        
        if placemark.country != nil {
            if placemark.country!.elementsEqual("France") {
                countryField.setText(text: Constants.defaultCountryForInscription)
            } else {
                countryField.setText(text: placemark.country!)
            }
        }
        activateValidationButton()
    }
}

extension CompanyInformationViewController: ChorusDelegate {
    func serviceListButtonTapped() {
        self.view.endEditing(true)
        guard let serviceList = viewModel.serviceList else {
            return
        }
        let action = FormElementDataPicker.chorus(serviceList: serviceList)
        self.currentAction = action
        self.currentPickerViewTextField = nil
        self.pickerDataSource = action.value
        self.pickerToolBarView.isHidden = false
        self.pickerView?.isHidden = false
        self.pickerView?.reloadAllComponents()
    }
    
    private func checkChorus(with siret: String) {
        self.viewModel.loaderManager.showLoderView()
        AccountNetworkManager().checkChorus(with: siret) { isChorusPartner, serviceList in
            self.viewModel.loaderManager.hideLoaderView()
            self.errorNoChorusView?.isHidden = isChorusPartner
            self.chorusView?.isHidden = !isChorusPartner
            self.chorusView?.setServiceList(serviceList != nil)
            self.viewModel.serviceList = serviceList
            if self.formType == .update {
                if let serviceCode = UserAccount.shared.customerInfo?.serviceCode {
                    self.chorusView?.setText(serviceText: self.viewModel.getChorusName(serviceCode: serviceCode) ?? "")
                }
            }
        }
    }
    
    private func clearChorusViews() {
        self.errorNoChorusView?.isHidden = true
        self.chorusView?.isHidden = true
    }
}

extension CompanyInformationViewController: MascadiaViewControllerDelegate {
    func keepAddress() {
        register(formData: dataForm!)
    }
    
    func chooseAddress(_ address: AddressMascadia) {
        if self.formType == .create {
            register(formData: viewModel.setNewAddress(formData: dataForm!, newAddress: address))
        } else {
            update(viewModel.setNewAddress(formData: dataForm!, newAddress: address))
        }
    }
}
