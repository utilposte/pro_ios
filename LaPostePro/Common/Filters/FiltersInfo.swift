//
//  FiltersInfo.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 26/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

enum filters: String {
    case FILTER_LISTPRODUCTREGIONS = "listProductRegions"
    case FILTER_LISTTHEMATIQUES = "listThematiques"
    case FILTER_POIDSMAXENVOIENVELOPPE = "poidsMaxEnvoiEnveloppe"
    case FILTER_POIDSMAXENVOITIMBRE = "poidsMaxEnvoiTimbre"
    case FILTER_TYPEPRODUIT = "typeProduit"
    case FILTER_DELAIENVOI = "delaiEnvoi"
    case FILTER_DESTINATIONENVOI = "destinationEnvoi"
    case FILTER_VALEURPERMANENTE = "valeurPermanente"
    case FILTER_TYPECOLLAGE = "typeCollage"
    case FILTER_PACKAGING = "packaging"
    case FILTER_NBTIMBREPARPRESENTATION = "nbTimbreParPresentation"
    case FILTER_DATEANNEEEMISSIONLEGALES = "dateAnneeEmissionLegale"
    case FILTER_ACCUSERECEPTION = "accuseReception"
    case FILTER_ASSURANCE = "assurance"
    case FILTER_BULLE = "bulle"
    case FILTER_DESTINATIONENVOI2 = "destinationEnvoi2"
    case FILTER_FAMILLE = "famille"
    case FILTER_FENETRE = "fenetre"
    case FILTER_MARCHANDISECOURRIER = "marchandiseCourrier"
    case FILTER_NUMEROSSUIVI = "numerosuivi"
    case FILTER_PRICE = "price"
    case FILTER_TECHNIQUEIMPRESSION = "techniqueImpression"
    case FILTER_TYPEENVELOPPE = "typeEnveloppe"
    case FILTER_AUTEUR = "auteur"
    case FILTER_LASTDAYSFORPRODUCT = "lastDaysForProduct"
    case FILTER_ALLCATEGORIES = "allCategories"
    case FILTER_CATEGORYPATH = "categoryPath"
    
    case FILTER_CHILD_FALSE = "false"
    case FILTER_CHILD_TRUE = "true"

    var realName: String {
        switch self {
        case .FILTER_LISTPRODUCTREGIONS:
            return "Région"
        case .FILTER_LISTTHEMATIQUES:
            return "Thématique"
        case .FILTER_POIDSMAXENVOIENVELOPPE:
            return "Poids max de l'envoi"
        case .FILTER_POIDSMAXENVOITIMBRE:
            return "Poids max de l'envoi"
        case .FILTER_TYPEPRODUIT:
            return "Type de produit"
        case .FILTER_DELAIENVOI:
            return "Nature de l'envoi"
        case .FILTER_DESTINATIONENVOI:
            return "Destination de l'envoi"
        case .FILTER_VALEURPERMANENTE:
            return "Valeur permanente"
        case .FILTER_TYPECOLLAGE:
            return "Type de collage"
        case .FILTER_PACKAGING:
            return "Packaging"
        case .FILTER_NBTIMBREPARPRESENTATION:
            return "Nombre de timbres dans le produit"
        case .FILTER_DATEANNEEEMISSIONLEGALES:
            return "Année d'émission"
        case .FILTER_ACCUSERECEPTION:
            return "Accusé de réception"
        case .FILTER_ASSURANCE:
            return "Assurance"
        case .FILTER_BULLE:
            return "Bulle"
        case .FILTER_DESTINATIONENVOI2:
            return "Destination de l'envoi"
        case .FILTER_FAMILLE:
            return "Famille"
        case .FILTER_FENETRE:
            return "Fenetre"
        case .FILTER_MARCHANDISECOURRIER:
            return "Marchandise / courrier"
        case .FILTER_NUMEROSSUIVI:
            return "Numéro suivi"
        case .FILTER_PRICE:
            return "Prix"
        case .FILTER_TECHNIQUEIMPRESSION:
            return "Technique impression"
        case .FILTER_TYPEENVELOPPE:
            return "Type d'enveloppe"
        case .FILTER_AUTEUR:
            return "Auteur"
        case .FILTER_LASTDAYSFORPRODUCT:
            return "Derniers jours"
        case .FILTER_ALLCATEGORIES:
            return "Toutes catégories"
        case .FILTER_CATEGORYPATH:
            return "Accès catégorie"
        case .FILTER_CHILD_FALSE:
            return "Non"
        case .FILTER_CHILD_TRUE:
            return "Oui"
        }
    }
}
