//
//  MascadiaVerificationViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 09/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class MascadiaVerificationViewModel {
    
    let kMascadia_Param_Ligne1 = "ligne1"
    let kMascadia_Param_Ligne2 = "ligne2"
    let kMascadia_Param_Ligne3 = "ligne3"
    let kMascadia_Param_Ligne4 = "ligne4"
    let kMascadia_Param_Ligne5 = "ligne5"
    let kMascadia_Param_Ligne6 = "ligne6"
    let kMascadia_Param_Ligne7 = "ligne7"
    
    let kMascadia_JsonValue_Verifie = "verifie"
    let kMascadia_JsonValue_CodesEtMessages = "codesEtMessages"
    let kMascadia_JsonValue_General = "general"
    let kMascadia_JsonValue_Feu = "feu"
    
    let kMascadia_Iso_Code_Countries_List: [String] = ["fr", "mc", "gp", "mq", "gf", "re", "yt", "nc", "pf", "tf", "wf"]
    let kMascadia_Countries_List: [String] = ["France", "Monaco", "Guadeloupe", "Martinique", "Guyane", "La Réunion", "Mayotte", "Nouvelle-Calédonie", "Polynésie française", "Terres australes françaises", "Wallis-et-Futuna"]
    let kMascadia_Verification_Countries_List: [String] = ["France", "Monaco", "France (Guadeloupe)", "France (Martinique)", "France (Guyane française)", "France (Réunion)", "France (Mayotte)", "Nouvelle-Calédonie", "Polynésie française", "Terres australes et antarctiques françaises", "France (Wallis-et-Futuna)"]
    
    var mascadiaAddressArray = [AddressMascadia]()
    var formData = UpdateFormModel()
    
    func createMascadiaDictionaryAddress(dataForm: UpdateFormModel) -> [String: String] {
        var mascadiaDictionaryAddress = [String: String]()
        mascadiaDictionaryAddress[kMascadia_Param_Ligne2] = dataForm.appartement
        mascadiaDictionaryAddress[kMascadia_Param_Ligne3] = dataForm.batiment
        mascadiaDictionaryAddress[kMascadia_Param_Ligne4] = dataForm.numLibelle
        mascadiaDictionaryAddress[kMascadia_Param_Ligne5] = dataForm.lieuDit
        mascadiaDictionaryAddress[kMascadia_Param_Ligne6] = String(format: "%@ %@", dataForm.codePostal ?? "", dataForm.localite ?? "")
        mascadiaDictionaryAddress[kMascadia_Param_Ligne7] = self.getMascadiaCountryForCode(dataForm.countryCode ?? "fr") ?? "France"
        return mascadiaDictionaryAddress
    }
    
    func verifyAddress(dataForm: UpdateFormModel, onCompletion: @escaping ([AddressMascadia], Bool) -> Void) {
        AccountNetworkManager().mascadiaVerification(for: createMascadiaDictionaryAddress(dataForm: dataForm)) { (response) in
            let blocAddressResponse = response["blocAdresse"] as! NSDictionary
            let addressArray = blocAddressResponse["adresse"] as! [NSDictionary]
            let mascadiaAddressArray = self.retrieveAddress(addressArray: addressArray)
            let addressStatus = self.getMascadiaResponseStatus(retourDictionary: response)
            onCompletion(mascadiaAddressArray, addressStatus)
        }
    }
    
    func retrieveAddress(addressArray: [NSDictionary]) -> [AddressMascadia] {
        var addressFromMascadiaArray = [AddressMascadia]()
        for address in addressArray {
                let addressMascadia = AddressMascadia(
                    postalCode: ((address[kMascadia_Param_Ligne6] as! [String:String])["codePostal"] ?? ""),
                    locality: (address[kMascadia_Param_Ligne6] as! [String:String])["libelleAcheminement"] ?? "",
                    countryCode: (address[kMascadia_Param_Ligne7] as! [String:String])["codeIso"] ?? "",
                    street: (address[kMascadia_Param_Ligne4] as! [String:String])["value"] ?? "",
                    lieuDit: (address[kMascadia_Param_Ligne5] as! [String:String])["value"] ?? "",
                    building: (address[kMascadia_Param_Ligne3] as! [String:String])["value"] ?? "",
                    apartment: (address[kMascadia_Param_Ligne2] as! [String:String])["value"] ?? "",
                    countryName: (address[kMascadia_Param_Ligne7] as! [String:String])["value"] ?? "")
                addressFromMascadiaArray.append(addressMascadia)
        }
        return addressFromMascadiaArray
    }
    
    private func getMascadiaResponseStatus(retourDictionary: NSDictionary) -> Bool {
        let addressValidationDic = retourDictionary[kMascadia_JsonValue_CodesEtMessages] as! NSDictionary
        let generalFeu = (addressValidationDic[kMascadia_JsonValue_General] as! NSDictionary)[kMascadia_JsonValue_Feu] as! String
        let ligne4Feu = (addressValidationDic[kMascadia_Param_Ligne4] as! NSDictionary)[kMascadia_JsonValue_Feu] as! String
        let ligne6Feu = (addressValidationDic[kMascadia_Param_Ligne6] as! NSDictionary)[kMascadia_JsonValue_Feu] as! String
        
        if (Int(generalFeu) == 0 && Int(ligne4Feu) != -4 && Int(ligne6Feu) != -4) {
            return true
        } else {
            return false
        }
    }
    
    func getAddressToVerify() -> String {
        return String(format: "%@\n%@ %@\n%@", formData.numLibelle ?? "", formData.codePostal ?? "", formData.localite ?? "", getCountryForCode(formData.countryCode ?? "") ?? "France Métropolitaine")
    }
    
    func getCountryForCode(_ isoCode: String) -> String? {
        if let index = kMascadia_Iso_Code_Countries_List.firstIndex(of: isoCode.lowercased()) {
            return kMascadia_Countries_List[index]
        }
        return nil
    }
    
    func getMascadiaCountryForCode(_ isoCode: String) -> String? {
        if let index = kMascadia_Iso_Code_Countries_List.firstIndex(of: isoCode.lowercased()) {
            return kMascadia_Verification_Countries_List[index]
        }
        return nil
    }
    
    func getIsoCodeFromCountry(_ country: String) -> String? {
        if let index = kMascadia_Countries_List.firstIndex(of: country) {
            return kMascadia_Iso_Code_Countries_List[index]
        }
        return nil
    }
}
