//
//  DeliveryAddress.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 19/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import RealmSwift
import LPSharedMCM

class DeliveryAddress {
    
    var addressExists: Bool = false
    
    var companyName: String?
    var isocode: String?
    var firstName: String?
    var formattedAddress: String?
    var deliveryAddressID: String?
    var lastName: String?
    var line1: String?
    var line2: String?
    var postalCode: String?
    var shippingAddress: Bool = false
    var title: String?
    var titleCode: String?
    var town: String?
    var countryName: String?
    var gender: String?
    var addressAlias: String?
    var phone: String?
    
    var visibleInAddressBook: Bool = false
    // added to fix billing address need
    
    class func deliveryAddressToHybAdress(_ deliveryAddress: HYBAddress) -> DeliveryAddress {

        let newDeliveryAddress = DeliveryAddress()
        newDeliveryAddress.companyName = deliveryAddress.companyName
        newDeliveryAddress.deliveryAddressID = deliveryAddress.id
        newDeliveryAddress.isocode = deliveryAddress.country.isocode
        newDeliveryAddress.countryName = deliveryAddress.country.name
        newDeliveryAddress.firstName = deliveryAddress.firstName
        newDeliveryAddress.formattedAddress = deliveryAddress.formattedAddress
        newDeliveryAddress.lastName = deliveryAddress.lastName
        newDeliveryAddress.line1 = deliveryAddress.line1
        newDeliveryAddress.line2 = deliveryAddress.line2
        newDeliveryAddress.postalCode = deliveryAddress.postalCode
        newDeliveryAddress.shippingAddress = deliveryAddress.shippingAddress
        newDeliveryAddress.title = deliveryAddress.title
        newDeliveryAddress.titleCode = deliveryAddress.titleCode
        newDeliveryAddress.town = deliveryAddress.town
        newDeliveryAddress.visibleInAddressBook = deliveryAddress.visibleInAddressBook
        newDeliveryAddress.phone = deliveryAddress.phone
        return newDeliveryAddress
    }
    
    
    func hybAddress() -> HYBAddress {
        let address : HYBAddress = HYBAddress()
        address.companyName = self.companyName ?? ""    
        address.id = self.deliveryAddressID ?? ""
        address.country = HYBCountry()
        address.country.isocode = self.isocode ?? ""
        address.country.name = self.countryName ?? ""
        address.firstName = self.firstName ?? ""
        address.lastName = self.lastName ?? ""
        address.line1 = self.line1 ?? ""
        address.line2 = self.line2 ?? ""
        address.postalCode = self.postalCode ?? ""
        address.title = self.title ?? ""
        address.titleCode = self.titleCode ?? ""
        address.town = self.town ?? ""
        address.formattedAddress = self.formattedAddress ?? ""
        address.visibleInAddressBook = self.visibleInAddressBook
        address.shippingAddress = self.shippingAddress
        address.phone = self.phone ?? ""
        return address
    }
    
    func isEmptyAddress() -> Bool {
        if self.line1 == nil || self.line1 == "" {
            return true
        }
        if self.postalCode == nil || self.postalCode == "" {
            return true
        }
        if self.countryName == nil || self.countryName == "" {
            return true
        }
        return false
    }
    
}


//
//
//class DeliveryAddress: Object {
//
//    var addressExists: Bool = false
//
//    @objc dynamic var companyName: String?
//    @objc dynamic var isocode: String?
//    @objc dynamic var name: String?
//    @objc dynamic var firstName: String?
//    @objc dynamic var formattedAddress: String?
//    @objc dynamic var deliveryAddressID: String?
//    @objc dynamic var lastName: String?
//    @objc dynamic var line1: String?
//    @objc dynamic var postalCode: String?
//    @objc dynamic var shippingAddress: Bool = false
//    @objc dynamic var title: String?
//    @objc dynamic var titleCode: String?
//    @objc dynamic var town: String?
//    @objc dynamic var visibleInAddressBook: Bool = false
//    // added to fix billing address need
//    @objc dynamic var country = ""
//    @objc dynamic var gender = ""
//    @objc dynamic var addressAlias = ""
//
//    internal func addAddressToRealm(deliveryAddress: HYBAddress) {
//        let realm = try! Realm()
//        let deliveryAddresses = realm.objects(DeliveryAddress.self)
//
//        let newDeliveryAddress = DeliveryAddress()
//        newDeliveryAddress.companyName = deliveryAddress.companyName
//        newDeliveryAddress.deliveryAddressID = deliveryAddress.id
//        newDeliveryAddress.isocode = deliveryAddress.country.isocode
//        newDeliveryAddress.name = deliveryAddress.country.name
//        newDeliveryAddress.firstName = deliveryAddress.firstName
//        newDeliveryAddress.formattedAddress = deliveryAddress.formattedAddress
//        newDeliveryAddress.lastName = deliveryAddress.lastName
//        newDeliveryAddress.line1 = deliveryAddress.line1
//        newDeliveryAddress.postalCode = deliveryAddress.postalCode
//        newDeliveryAddress.shippingAddress = deliveryAddress.shippingAddress
//        newDeliveryAddress.title = deliveryAddress.title
//        newDeliveryAddress.titleCode = deliveryAddress.titleCode
//        newDeliveryAddress.town = deliveryAddress.town
//        newDeliveryAddress.visibleInAddressBook = deliveryAddress.visibleInAddressBook
//
//        for address in deliveryAddresses {
//            if address.deliveryAddressID == newDeliveryAddress.deliveryAddressID {
//                self.addressExists = true
//            }
//        }
//
//        if self.addressExists == false {
//            try! Realm.write {
//                realm.add(newDeliveryAddress)
//            }
//        }
//    }
//
//
//
//}
