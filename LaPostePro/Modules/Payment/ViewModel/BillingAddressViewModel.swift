//
//  BillingAddressViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 20/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class BillingAddressViewModel {
    var countryList = [DataCountry]()
    var indexCity : Int? = nil
    var address: DeliveryAddress?
    
    init() {
        self.countryList = self.createCountryDataForPicker()
    }
    
    private func createCountryDataForPicker() -> [DataCountry] {
        return DataCountry().getCounties()
    }
    
    private func getCountryPickerData() -> [String] {
        return countryList.map { $0.name! }
    }

    private func getCountryIsoCodePickerData() -> [String] {
        return countryList.map { $0.isocode! }
    }
    
    func getCountryName(by index: Int) -> String {
        return getCountryPickerData()[index]
    }
    
    func getCountryIsoCode(by index: Int) -> String {
        return getCountryIsoCodePickerData()[index]
    }
    
    func getAddressAlias() -> String {
        return address?.addressAlias ?? ""
    }
    func getGender() -> Bool? {
        if address?.title != nil && (address?.title?.isEmpty)! {
            return nil
        } else {
            return (address?.titleCode?.lowercased().elementsEqual("mrs")) ?? nil
        }
    }
    
    func getFirstName() -> String {
        return address?.firstName ?? ""
    }
    
    func getLastName() -> String {
        return address?.lastName ?? ""
    }
    
    func getCompanyName() -> String {
        return address?.companyName ?? ""
    }
    
    func getCompanyService() -> String {
        return address?.companyName ?? ""
    }
    
    func getBuilding() -> String {
        return ""
    }
    
    func getStreet() -> String {
        return address?.line1 ?? ""
    }
    
    func getPostalCode() -> String {
        return address?.postalCode ?? ""
    }
    
    func getTown() -> String {
        return address?.town ?? ""
    }
    
    func getCountry() -> String {
        return address?.countryName ?? ""
    }
}
