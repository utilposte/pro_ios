//
//  AccountNetworkError.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 20/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class AccountNetworkError {
    
    var type : AccountNetworkErrorManager.AccountNetworkErrorType = .unknown
    var message : String?
    var popinMessage : String?
    var canSubscribe = false
}




class AccountNetworkErrorManager {
    enum ErrorState {
        case generic
        case required
        case invalid
        case format
        case close
        case mismatch
    }
    
    enum AccountNetworkErrorType {
        case unknown
        case companyName(value: ErrorState)
        case firstName(value: ErrorState)
        case lastName(value: ErrorState)
        case phone(value: ErrorState)
        case signature(value: ErrorState)
        case time(value: ErrorState)
        case siret(value: ErrorState)
        case rna(value: ErrorState)
        case postalcode(value: ErrorState)
        case tvaIntra(value: ErrorState)
        case email(value: ErrorState)
        
        var cansSubscribe : Bool {
            switch self {
            case .postalcode(value: .mismatch), .rna(value: .close), .siret(value: .close):
                return true
            default:
                return false
            }
        }
        
        var isFirstPart : Bool {
            switch self {
            case .firstName, .lastName, .phone, .email:
                return true
            default:
                return false
            }
        }
        
        var errorText : String? {
            switch self {
            case .postalcode(value: .mismatch):
                return "Votre société n'est pas implantée dans le département correspondant au SIRET ou RNA fourni."
            case .firstName:
                return "La saisie de votre prénom est incorrecte"
            case .lastName:
                return "La saisie de votre nom est incorrecte"
            case .phone:
                return "La saisie de votre numéro est incorrecte"
            case .email(value: .mismatch):
                return "Votre email existe déjà"
            case .email:
                return "La saisie de votre email est incorrecte"
            case .siret:
                return "Le numéro de SIRET saisi n'est pas valide"
            case .rna:
                return "Le numéro de RNA saisi n'est pas valide"
            case .companyName:
                return "Votre saisie est incorrecte"
            case .tvaIntra:
               return "Veuillez le saisir au format « FR + 2 caractères + N° SIREN (9 chiffres) »"
            default:
                return "Une erreur est survenue : Erreur Inconnu"
            }
        }
    }
    
    func getListOfErrorsfrom(_ errorWS : ErrorWS) -> [AccountNetworkError] {
        var result = [AccountNetworkError]()
        if let errors = errorWS.errors as? [ErrorDetailWS] {
            for error in errors {
                let networkError = AccountNetworkError()
                networkError.type = getTypeFrom(error: error)
                networkError.canSubscribe = networkError.type.cansSubscribe
                switch networkError.type {
                case .rna(value: .close):
                    networkError.message = "Votre association semble être en cours de cessation d'activité"
                    if let _ebkCustomerProWsDTO = errorWS.ebkCustomerProWsDTO, let date = getDateFrom(ebkCustoerProWsDTO: _ebkCustomerProWsDTO) {
                        networkError.message = networkError.message!+" depuis le \(date)"
                    }
                    break
                    
                case .siret(value: .close):
                    networkError.message = "Votre société semble être en cours de cessation d'activité"
                    if let _ebkCustomerProWsDTO = errorWS.ebkCustomerProWsDTO, let date = getDateFrom(ebkCustoerProWsDTO: _ebkCustomerProWsDTO) {
                        networkError.message = networkError.message!+" depuis le \(date)"
                    }
                    break
                default :
                    networkError.message = networkError.type.errorText
                }
                result.append(networkError)
            }
        }
        return result
    }
    
    func getTypeFrom(error : ErrorDetailWS) -> AccountNetworkErrorType {
        var type = AccountNetworkErrorType.unknown
        switch error.codeError {
        case "company.companyName.format", "register.pro.companyName.required":
            type = .companyName(value: .generic)
        case "register.pro.firstName.required", "register.firstName.invalid":
            type = .firstName(value: .generic)
        case "register.pro.lastName.required" , "register.lastName.invalid":
            type = .lastName(value: .generic)
        case "register.phone.required" :
            type = .phone(value: .required)
        case "register.pro.signature.required":
            type = .signature(value: .required)
        case "register.pro.time.required":
            type = .time(value: .required)
        case "register.pro.error.fiche.client.association.ferme":
            type = .rna(value: .close)
        case "register.pro.error.fiche.client.activite.fin", "register.pro.error.fiche.client.activite.fermeture":
            type = .siret(value: .close)
        case "register.pro.error.rna.for.association", "rna.invalid":
            type = .rna(value: .generic)
        case "register.pro.error.siret.invalid", "register.pro.error.siret.required":
            type = .siret(value: .generic)
        case "register.pro.error.address.codePostal.not.matching":
            type = .postalcode(value: .mismatch)
        case "register.pro.error.tvaIntra.format.fr", "register.pro.error.tvaIntra.invalid", "register.pro.error.tvaIntra.required", "register.pro.error.tvaIntra.espace", "register.pro.error.tvaIntra.format":
            type = .tvaIntra(value : .generic)
        case "register.pro.email.required", "email.invalid":
            type = .email(value: .generic)
        case "EXISTING_EMAIL":
            type = .email(value: .mismatch)
        default:
            type = .unknown
        }
        return type
    }
    
    func getDateFrom(ebkCustoerProWsDTO : EbkCustomerProWsDTO) -> String?{
        let originFormatter = DateFormatter()
        originFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
        let resultFormatter  = DateFormatter()
        resultFormatter.dateFormat = "dd-MM-yyyy"
        if let dateString = ebkCustoerProWsDTO.dateFinActivite {
            // SIRET
            if let currentDate = originFormatter.date(from: dateString) {
                return resultFormatter.string(from: currentDate.adding(day: 1))
            }
        }
        if let dateString = ebkCustoerProWsDTO.dateFermeture {
            // SIRET
            if let currentDate = originFormatter.date(from: dateString) {
                return resultFormatter.string(from: currentDate.adding(day: 1))
            }
        }
        else if let dateString = ebkCustoerProWsDTO.dateInactivation {
            // RNA
            if let currentDate = originFormatter.date(from: dateString) {
                return resultFormatter.string(from: currentDate)
            }
        }
        return nil
    }
}

/*
{
    "errors": [
    {
    "codeError": "register.pro.error.address.numLibelle.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.rna",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.companytype.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.rna.for.association",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.codePostal.length.38",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.codePostal.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.codePostal.lrel.empty",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.mascadia.localite",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.mascadia.default",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.mascadia.proposition",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.sna6.length",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.sna1.length",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.concatCiviliteMmeNomPrenomMaxCharacter",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.fiche.client.association.ferme",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.fiche.client.activite.fin",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.fiche.client.activite.fermeture",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.siret.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.siret.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.tvaIntra.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.tvaIntra.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.tvaIntra.espace",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.tvaIntra.format",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.tvaIntra.format.fr",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.chorus.servicecode.mustBeEmpty",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.chorus.servicecode.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.chorus.servicecode.notExist",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.function.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.error.address.codePostal.not.matching",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.time.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.signature.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.pays.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "address.localite.format",
    "type": "registerProUser.error"
    },
    {
    "codeError": "address.lieuDit.format",
    "type": "registerProUser.error"
    },
    {
    "codeError": "address.batiment.format",
    "type": "registerProUser.error"
    },
    {
    "codeError": "address.numLibelle.format",
    "type": "registerProUser.error"
    },
    {
    "codeError": "address.appartement.format",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.coclico.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.companytype.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "company.companyName.format",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.companyName.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.phone.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.lastName.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.lastName.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.firstName.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.firstName.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.email.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "email.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.title.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.codePostal.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "rna.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.acceptConditions.required",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pwd.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "register.pro.signature.invalid",
    "type": "registerProUser.error"
    },
    {
    "codeError": "CCU_SERVICE_ERROR",
    "type": "registerProUser.error"
    },
    {
    "codeError": "EXISTING_EMAIL",
    "type": "registerProUser.error"
    },
    {
    "codeError": "INTERNAL_SERVER_ERROR",
    "type": "registerProUser.error"
    }
    ]
}
*/
