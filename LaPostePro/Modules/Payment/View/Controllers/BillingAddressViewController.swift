//
//  BillingAddressViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 20/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import LPSharedMCM

class BillingAddressViewController: BaseViewController {
    //OUTLET
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var pickerViewToolBar: UIView!
    
    //PROPRETIES
    var companyInfoTitle: FormTitleView!
    var addressAliasElement: FormElementView!
    var genderElement: GenderView!
    var fullNameElement: FullNameView!
    var companyName: FormElementView!
    var serviceElement: FormElementView!
    var addressTitle: FormTitleView!
    var useLocationView: UsePosition!
    var buildingField: FormElementView!
    var streetField: FormElementView!
    var placeField: FormElementView!
    var postalCodeField: FormElementView!
    var townField: FormElementView!
    var countryField: FormElementView!
    var validationButtonElement: FormValidationButton!
    let viewModel = BillingAddressViewModel()
    lazy var loaderManager = LoaderViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.setupTitleNavigationBar(backEnabled: true, title: "Adresse de facturation")
        self.setupTitleNavigationBar(backEnabled: true, title: "Adresse de facturation", showCart: false)
        addHeader()
        //addCompanyInformationTitle()
        //addAddressAliasElement()
        addGenderElement()
        addFullNameElement()
        addCompanyNameElement()
        addServiceElement()
        addAddressTitle()
        addUsePositionElement()
        addBuildingElement()
        addStreetElement()
        addPlaceElement()
        addPostalCodeElement()
        addLocalityElement()
        addCountryElement()
        addValidationButton()
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kAddDelivreyAddress,
                                                             chapter1: TaggingData.kTunnel,
                                                             chapter2: nil,
                                                             level2: TaggingData.kCommerceLevel)
    }
    
    @IBAction func pickerViewToolBarValidationButtonClicked(_ sender: Any) {
        pickerViewToolBar.isHidden = true
        countryPickerView.isHidden = true
        countryField.setText(text: viewModel.getCountryName(by: countryPickerView.selectedRow(inComponent: 0)))
        self.viewModel.address?.isocode = viewModel.getCountryIsoCode(by: countryPickerView.selectedRow(inComponent: 0))
    }
    
    @IBAction func pickerViewToolBarCancelButtonClicked(_ sender: Any) {
        pickerViewToolBar.isHidden = true
        countryPickerView.isHidden = true
    }
    
}

extension BillingAddressViewController {
    private func addHeader() {
        if let header = Bundle.main.loadNibNamed("FormHeader", owner: nil, options: nil)?.first as? FormHeader {
            header.setup(with: "Modifier l'adresse de facturation", and: "Les champs suivis d’une * sont obligatoires")
            formStackView.addArrangedSubview(header)
        }
    }

    private func addCompanyInformationTitle() {
        companyInfoTitle = FormTitleView(title: "Informations de l’entreprise")
        formStackView.addArrangedSubview(companyInfoTitle)
    }

    private func addAddressAliasElement() {
        let addressAliasStruct = FormElementStruct.init(placeholder: "Nom de l’adresse", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        addressAliasElement = FormElementView.init(addressAliasStruct)
        addressAliasElement.setText(text: viewModel.getAddressAlias())
        formStackView.addArrangedSubview(addressAliasElement)
    }

    private func addGenderElement() {
        genderElement = GenderView(frame: CGRect.zero)
        genderElement.setupGenderStackView()
        genderElement.setGender(isMale: viewModel.getGender())
        genderElement.delegate = self
        formStackView.addArrangedSubview(genderElement)
    }
    
    private func addFullNameElement() {
        if let fullNameView = Bundle.main.loadNibNamed("FullNameView", owner: nil, options: nil)?.first as? FullNameView {
            self.fullNameElement = fullNameView
            self.fullNameElement.setupView()
            self.fullNameElement.delegate = self
            self.fullNameElement.setLastNameText(lastName: viewModel.getLastName())
            self.fullNameElement.setFirstNameText(firstName: viewModel.getFirstName())
            formStackView.addArrangedSubview(self.fullNameElement)
        }
    }
    
    private func addCompanyNameElement() {
        let companyNameStruct = FormElementStruct.init(placeholder: "Raison Sociale", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        companyName = FormElementView(companyNameStruct)
        companyName.setText(text: viewModel.getCompanyName())
        companyName.delegate = self
        formStackView.addArrangedSubview(companyName)
    }
    
    private func addServiceElement() {
        let serviceStruct = FormElementStruct.init(placeholder: "Service", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        serviceElement = FormElementView.init(serviceStruct)
        serviceElement.setText(text: viewModel.getCompanyService())
        serviceElement.delegate = self
        formStackView.addArrangedSubview(serviceElement)
    }
    
    private func addAddressTitle() {
        addressTitle = FormTitleView(title: "Adresse de l’entreprise")
        formStackView.addArrangedSubview(addressTitle)
    }
    
    private func addUsePositionElement() {
        if let usePositionView = Bundle.main.loadNibNamed("UsePosition", owner: nil, options: nil)?.first as? UsePosition {
            usePositionView.setup()
            usePositionView.delegate = self
            formStackView.addArrangedSubview(usePositionView)
        }
    }
    
    private func addBuildingElement() {
        let buildingStruct = FormElementStruct.init(placeholder: "Bâtiment, Immeuble", helperText: "", errorText: "", isRequired: false, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        buildingField = FormElementView.init(buildingStruct)
        buildingField.delegate = self
        buildingField.setText(text: viewModel.getBuilding())
        formStackView.addArrangedSubview(buildingField)
    }

    private func addStreetElement() {
        let streetStruct = FormElementStruct.init(placeholder: "N et libellé de la voie", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        streetField = FormElementView.init(streetStruct)
        streetField.setText(text: viewModel.getStreet())
        streetField.delegate = self
        formStackView.addArrangedSubview(streetField)
    }
    
    private func addPlaceElement() {
        let placeStruct = FormElementStruct.init(placeholder: "Lieu-dit ou BP", helperText: "", errorText: "", isRequired: false, isDisplayed: false, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        placeField = FormElementView.init(placeStruct)
        //placeField.setText(text: viewModel.g)
        placeField.delegate = self
        formStackView.addArrangedSubview(placeField)
    }
    private func addPostalCodeElement() {
        let postalCodeStruct = FormElementStruct.init(placeholder: "Code Postal", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .postalCode)
        postalCodeField = FormElementView.init(postalCodeStruct)
        postalCodeField.setText(text: viewModel.getPostalCode())
        postalCodeField.delegate = self
        formStackView.addArrangedSubview(postalCodeField)
    }

    private func addLocalityElement() {
        let localityStruct = FormElementStruct.init(placeholder: "Localité", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        townField = FormElementView.init(localityStruct)
        townField.setText(text: viewModel.getTown())
        townField.delegate = self
        formStackView.addArrangedSubview(townField)
    }
    
    private func addCountryElement() {
        let countryStruct = FormElementStruct.init(placeholder: "Pays", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .picker(type: .country(countryList: viewModel.countryList)), isSecured: false, defaultValue: Constants.defaultCountryForInscription, shouldSeePassword: false, elementType: .none)
        countryField = FormElementView.init(countryStruct)
        countryField.setText(text: viewModel.getCountry())
        countryField.delegate = self
        formStackView.addArrangedSubview(countryField)
    }
    
    private func addValidationButton() {
        if let validationButton = Bundle.main.loadNibNamed("FormValidationButton", owner: nil, options: nil)?.first as? FormValidationButton {
            self.validationButtonElement = validationButton
            self.validationButtonElement.setup()
            validationButton.delegate = self
            formStackView.addArrangedSubview(validationButtonElement)
        }
    }
    private func editValidationButtonState() {
        if checkFormValidity() {
            validationButtonElement.enableButton()
        } else {
            validationButtonElement.disableButton()
        }
    }
}


extension BillingAddressViewController: FormElementViewDelegate, FullNameViewDelegate, GenderViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func textFieldDidEndEditing(textfield: UITextField, textType: FormElementInputTextType) {
         editValidationButtonState()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.countryList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getCountryName(by: row)
    }
    func genderSelected() {
//        self.viewModel.address?.gender = genderElement.isMaleUser()
        editValidationButtonState()
    }
    
    func textFieldEndEditing() {
        editValidationButtonState()
    }

    func textfieldDidTapped(textfield: MDCTextField, action: FormElementDataPicker) {
        UIView.animate(withDuration: 0.2) {
            self.countryPickerView.reloadAllComponents()
            self.countryPickerView.isHidden = false
            self.pickerViewToolBar.isHidden = false
        }
    }
}

extension BillingAddressViewController : UsePositionDelegate, MCMLocationServiceDelegate {
    
    func usePositionToGetAddress() {
        MCMLocationService.sharedInstance()?.delegate = self
        MCMLocationService.sharedInstance()?.startUpdatingLocation()
    }

    func latestLocation(_ newLocation: CLLocation!, withError error: Error!) {
        
        loaderManager.showLoderView()
        MCMLocationService.reverseGeoCodeLocation(newLocation.coordinate) { (placeMarks) in
            MCMLocationService.sharedInstance()?.stopUpdatingLocation()
            self.loaderManager.hideLoaderView()
            if (placeMarks != nil && placeMarks!.count > 0) {
                //             CLPlacemark* placemark = placemarks.firstObject;
                let placeMark = placeMarks?.first as! CLPlacemark
                
                let hybrisAddress = MCMLocationService.mapApplePlaceMark(toHybrisAddress: placeMark)
                self.streetField.setText(text: hybrisAddress?.line1 ?? "")
                self.viewModel.address?.line1 = hybrisAddress?.line1 ?? ""
                    
                self.postalCodeField.setText(text: hybrisAddress?.postalCode ?? "")
                self.viewModel.address?.postalCode = hybrisAddress?.postalCode ?? ""
                self.townField.setText(text: hybrisAddress?.town ?? "")
                self.viewModel.address?.town = hybrisAddress?.town ?? ""
                self.countryField.setText(text: hybrisAddress?.country.name ?? "")
                self.viewModel.address?.countryName = hybrisAddress?.country.name ?? ""
                self.viewModel.address?.isocode = hybrisAddress?.country.isocode ?? ""
            }
            
        }
    }
    
}

extension BillingAddressViewController: ValidationButtonDelegate {
    func validationButtonClicked() {
        let billingAddress = DeliveryAddress()
        billingAddress.companyName = companyName.getText()
        billingAddress.firstName = fullNameElement.getFirstNameText()
        billingAddress.lastName = fullNameElement.getLastNameText()
        billingAddress.line1 = streetField.getText()
        billingAddress.postalCode = postalCodeField.getText()
        billingAddress.town = townField.getText()
        billingAddress.isocode = self.viewModel.address?.isocode
        billingAddress.countryName = countryField.getText()
        if (genderElement.isGenderSelected()) {
            billingAddress.titleCode =  genderElement.isMaleUser() ? "mr" : "mrs"
        }
        
        let count = self.navigationController?.viewControllers.count ?? 1
        if count > 1 {
            if let shippementCartViewController = self.navigationController?.viewControllers[count - 2] as? ShippingCartViewController {
                shippementCartViewController.viewModel.billingAddress = billingAddress
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func checkFormValidity() -> Bool {
        for element in formStackView.arrangedSubviews {
            if element.isKind(of: FormElementView.self) {
                if (element as! FormElementView).isRequired() {
                    if (element as! FormElementView).getText().isEmpty {
                        return false
                    }
                }
            }
        }
        return true
    }
}
