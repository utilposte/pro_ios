//
//  CompanyInformationViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 05/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

class CompanyInformationViewModel {
    var countryList = [DataCountry]()
    var companyTypeList = [CompanyType]()
    var companyInformationBuilder = [FormBuilder]()
    var serviceList: [Service]?
    lazy var loaderManager = LoaderViewManager()
    init() {
        countryList = self.createCountryDataForPicker()
        companyTypeList = self.createCompanyTypeDataForPicker()
        companyInformationBuilder = self.createFormBuilder()
    }

    private func createCountryDataForPicker() -> [DataCountry] {
        return DataCountry().getCounties()
    }
    
    private func createCompanyTypeDataForPicker() -> [CompanyType] {
        return CompanyType().getCompanyTypes()
    }
    
    private func createFormBuilder() -> [FormBuilder] {
        return FormBuilder().getFormBuilderList()
    }
    
    func validateAddress() {
        MCMAddressValidationService.validateAddress([:]) { (proposition, result, error) in
            
        }
    }
    func getCGUAttributedText() -> NSMutableAttributedString {
        let attributesForUnderlineText = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                        NSAttributedStringKey.foregroundColor: UIColor.lpDeepBlue,
                        NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let attributesForText = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                                          NSAttributedStringKey.foregroundColor: UIColor.lpDeepBlue] as [NSAttributedStringKey : Any]
        let cguAttributedString = NSMutableAttributedString()
        //first
        var attributedText = NSAttributedString(string: "J'ai lu et j'accepte les ", attributes: attributesForText)
        cguAttributedString.append(attributedText)
        
        //second
        attributedText = NSAttributedString(string: "Conditions Générales Courrier-Colis", attributes: attributesForUnderlineText)
        cguAttributedString.append(attributedText)
        
        //third
        attributedText = NSAttributedString(string: ", les ", attributes: attributesForText)
        cguAttributedString.append(attributedText)
        
        //forth
        attributedText = NSAttributedString(string: "conditions spécific boutique", attributes: attributesForUnderlineText)
        cguAttributedString.append(attributedText)
        
        //fith
        attributedText = NSAttributedString(string: " et les ", attributes: attributesForText)
        cguAttributedString.append(attributedText)
        
        //six
        attributedText = NSAttributedString(string: "conditions générales d'Utilisation du compte La Poste", attributes: attributesForUnderlineText)
        cguAttributedString.append(attributedText)
        
        return cguAttributedString
    }
    
    func getTextForDisplayOptionalFieldLabel(display: Bool) -> NSMutableAttributedString {
        if display {
            return NSMutableAttributedString()
                .custom("Afficher tous les champs", font: UIFont.systemFont(ofSize: 15, weight: .regular), color: .lpDeepBlue)
                .custom(" +", font: UIFont.systemFont(ofSize: 15, weight: .semibold), color: .lpPurple)
        } else {
            return NSMutableAttributedString()
                .custom("Cacher les champs optionnels", font: UIFont.systemFont(ofSize: 15, weight: .regular), color: .lpDeepBlue)
                .custom(" -", font: UIFont.systemFont(ofSize: 15, weight: .semibold), color: .lpPurple)
        }
    }
    
    func checkAddress(address: [String : String]) {
        //let sarcadiaAddress = MCMAddressValidationService.mapAddressFields(toParamFields: address)
        MCMAddressValidationService.validateAddress(address) { (_, _, _) in }
    }
    
    func getFormBuilder(for country: String) -> FormBuilder? {
        let countryName = country.folding(options: .diacriticInsensitive, locale: Locale.init(identifier: "fr_FR")).lowercased()
        return companyInformationBuilder.filter {
            $0.Pays!.folding(options: .diacriticInsensitive, locale: Locale.init(identifier: "fr_FR")).lowercased().elementsEqual(countryName)}.first
    }
    
    func showTva(formBuilder: FormBuilder?) -> Bool {
        return formBuilder?.TVA_intracommunautaire!.elementsEqual("NON") ?? true
    }
    
    func inscription(acceptError : Bool = false, dataForm: UpdateFormModel, onCompletion: @escaping (([AccountNetworkError]?) -> Void)) {
        let email = dataForm.email
        let password = dataForm.pwd
        self.loaderManager.showLoderView()
        AccountNetworkManager().initInscription(acceptError : acceptError, dataForm: dataForm) { (errorType, accessTokenError, expiresIn, refreshToken, tokenType) in
            self.loaderManager.hideLoaderView()
            if errorType == nil {
                let keychainService = KeychainService()
                keychainService.saveUserCredentials(email: email!, password: password!)
                keychainService.saveTokens(accessToken: accessTokenError!, expiresIn: "\(expiresIn!)", refreshToken: refreshToken!, tokenType: tokenType!)
                ConnectionViewModel.setMCMUserCredential(email: email!, accessToken: accessTokenError!, expiresIn: "\(expiresIn!)", refreshToken: refreshToken!, tokenType: tokenType!)
                
            }
            onCompletion(errorType)
        }
    }
    
    func getCompagnyCode(companyType: String) -> String {
        let compagny = companyTypeList.filter { ($0.name?.elementsEqual(companyType))! }
        return compagny.first?.code ?? ""
    }
    
    func getChorusCode(serviceName: String) -> String {
        let chorus = serviceList?.filter { ("\($0.serviceName)").elementsEqual(serviceName)}
        return chorus?.first?.serviceCode ?? ""
    }
    
    func getChorusName(serviceCode: String) -> String? {
        let chorus = serviceList?.filter { ("\($0.serviceCode)").elementsEqual(serviceCode)}
        return chorus?.first?.serviceName
    }

    func setNewAddress(formData: UpdateFormModel, newAddress: AddressMascadia) -> UpdateFormModel {
        var data = formData
        data.appartement = newAddress.apartment
        data.batiment = newAddress.building
        data.numLibelle = newAddress.street
        data.lieuDit = newAddress.lieuDit
        data.codePostal = newAddress.postalCode
        data.localite = newAddress.locality
//        data.countryCode = newAddress.countryCode?.lowercased()
        
        return data
    }
    
    func checkEmailAddress(_ email: String, onCompletion: @escaping (Bool) -> Void) {
        AccountNetworkManager().checkEmailBeforeInscription(email: email) { (emailExist) in
            onCompletion(emailExist)
        }
    }
}
