//
//  SVConstants.swift
//  laposte
//
//  Created by Sofien Azzouz on 11/01/2018.
//  Copyright © 2017 laposte. All rights reserved.
//

let BORDER_GREY_COLOR = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.00)
let BACKGROUND_GREY_COLOR = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.00)

@objc enum FormKeys: Int {
    case AddressKind = 0
    case Civility  = 1
    case CompanyName = 2
    case ServiceNameReciever = 3
    case ServiceNameSender = 4
    case FirstName = 5
    case LastName = 6
    case Email = 7
    case Tel = 8
    case ComplementaryAddress = 9
    case Steet = 10
    case PostalCode = 11
    case Locality = 12
    case Country = 13
    case EmailHeader = 14
    case Welcome = 15
    
    case CurrentPositionButton = 16
    case SaveAddress = 17
    case ValidateButton = 18
}

@objc enum ViewPresentation: Int {
    case isPush = 0
    case isModal
    case isModalWithViewDescription
}

let kShowMascadiaFromAddressInput = "ShowMascadiaFromAddressInput"
let kUnwindFromMascadiaVC = "unwindFromMascadiaVC"
let kUnwindFromAddressCreateAndEditVC = "unwindFromAddressCreateAndEditVC"
let kPresentAddressSuggestionFromAddressInput = "PresentAddressSuggestionFromAddressInput"

class Constant: NSObject {
    static let sharedInstance = Constant()
    
    let sacadiaDecisionLabelForNoPropositions = "Votre adresse n'est pas conforme, veuillez la modifier"
    
    
    func formKeyValue(formKey: FormKeys) -> String {
        switch formKey {
        case .AddressKind: return "type"
        case .Civility: return "titleCode"
        case .CompanyName: return "company"
        case .ServiceNameReciever: return "service"
        case .ServiceNameSender: return "service"
        case .FirstName: return "firstName"
        case .LastName: return "lastName"
        case .Email: return "email"
        case .Tel: return "tel"
        case .ComplementaryAddress: return "line2"
        case .Steet: return "line1"
        case .PostalCode: return "postalCode"
        case .Locality: return "town"
        case .Country: return "country.isocode"
        case .CurrentPositionButton: return "currentPositionButton"
        case .SaveAddress: return "saveAddress"
        case .ValidateButton: return "validateButton"
        case .EmailHeader: return "EmailHeader"
        case .Welcome : return "Welcome"
        }
    }
}
