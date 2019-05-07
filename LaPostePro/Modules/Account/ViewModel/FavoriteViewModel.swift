//
//  FavoriteViewModel.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 28/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM
import Alamofire
import LPSharedLOC
import MapKit
import SwiftyJSON
import RealmSwift

//struct WishlistResponse: Codable {
//    var products: [ProductResponse]?
//}

struct WishlistResponse: Codable {
    var products: [Product]?
}

struct ProductResponse: Codable {
    var assurance: Bool?
    var auteur: String?
    var availableForPickup: Bool?
    var categories: [CodeLabelReponse]?
    var code: String?
    var dateEmissionLegale: String?
    var delaiEnvoi: CodeLabelReponse?
    var description: String?
    var descriptionSynthetique: String?
    var destinationEnvoi: CodeLabelReponse?
    var famille: CodeLabelReponse?
    var fenetre: Bool?
    var formatAvecDents: String?
    var mentionsLegales: String?
    var modulo: Bool?
    var name: String?
    var nbTPparFeuille: Int?
    var nbTimbreParPresentation: Int?
    var netPrice: Price?
    var numberOfReviews: Int?
    var numerosuivi: Bool?
    var packaging: CodeLabelReponse?
    var poidsMaxEnvoi: Int?
    var price: Price?
//    var priceRange: AnyObject?
    var purchasable: Bool?
    var stock: StockResponse
    var summary: String?
    var taxClass: String?
    var techniqueImpression: CodeLabelReponse?
    var typeCollage: CodeLabelReponse?
    var typeEnveloppe: CodeLabelReponse?
    var url: String?
    var valeurPermanente: Bool?
    var zoneValidite: String?
}

struct CodeLabelReponse: Codable {
    var code: String?
    var label: String?
}

struct StockResponse: Codable {
    var stockLevelStatus: String?
    var stockLevel: Int?
}

class FavoriteViewModel: NSObject {
    
//    var productsWishlist: WishlistResponse?
//    var tmpProductWishList: [Product]?
    var productsWishlist: [Product]?
    let sharedManager :LOCSharedManager = (LOCSharedManager.sharedManager() as? LOCSharedManager)!
    let hybServiceWrapper = (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper)
    
    func getProductWishlist(completion: ((Bool) -> ())?) {
        // CREATE HTTP HEADER
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        
        let headers :[String: String?] = [
            "Authorization": authorization,
            "Content-Type": "application/json"
        ]
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/users/"
        //guard let email = UserAccount.shared.customerInfo?.displayUid else { Logger.shared.debug("Error"); return }
        guard let email = keychainService.get(key: keychainService.emailkey) else { Logger.shared.debug("Error"); return }
        let urlString2 = urlString + email + Constants.wishlist + "?fields=FULL"
        
        let url = URL(string: urlString2)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        
        Alamofire.request(request)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    do {
                        let productFavorite = ProductFavorite()
                        productFavorite.deleteAll()
                        let wishlistResponse = try JSONDecoder().decode(WishlistResponse.self, from: response.data!)
                        self.productsWishlist = wishlistResponse.products
                        if let wishlist = wishlistResponse.products {
                            for product in wishlist {
                                if let codeProduct = product.id {
                                    do {
                                        let realm = try Realm()
                                        
                                        let product = ProductFavorite()
                                        product.productCode = codeProduct
                                        
                                        try realm.write {
                                            realm.add(product)
                                        }
                                    } catch _ as NSError {
                                    }
                                }
                            }
                        }
                        completion!(true)
                    } catch(let error) {
                        Logger.shared.debug(error.localizedDescription)
                        completion!(false)
                    }
                    
                case .failure:
                    completion!(false)
                }
        }
    }
    
    func deleteProductWishlist(product: String, completion: ((Bool) -> ())?) {
        // CREATE HTTP HEADER
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        
        let headers :[String: String?] = [
            "Authorization": authorization,
            "Content-Type": "application/json"
        ]
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/users/"
        guard let email = UserAccount.shared.customerInfo?.displayUid else { Logger.shared.debug("Error"); return }
        let urlString2 = urlString + email + Constants.wishlist + "?productCode=\(product)"
        
        let url = URL(string: urlString2)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    completion!(true)
                case .failure:
                    Logger.shared.debug("Fail")
                    if (response.response?.statusCode)! >= 200 && (response.response?.statusCode)! <= 299 {
                        completion!(true)
                    } else {
                        completion!(false)
                    }
                }
        }
    }
    
    func getAreaImage(office: PostalOffice) -> MKMapSnapshotter {
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        let location2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: office.latitude)!, longitude: CLLocationDegrees(exactly: office.longitude)!)
        
        let region = MKCoordinateRegionMakeWithDistance(location2D, 1000, 1000)
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: 140, height: 140)
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        return MKMapSnapshotter(options: mapSnapshotOptions)
    }
    
    func getImageFromType(_ typeString : String?) -> UIImage {
        guard let type = typeString else {
            return R.image.ic_pin_bp()!
        }
        if type == "A2P" {
            return R.image.ic_pin_shop()!
        }
        else if type == "CDI" {
            return R.image.ic_pin_pickup()!
        } else if type == "Box" {
            return R.image.ic_pin_letterbox()!
        }
        return R.image.ic_pin_bp()!
    }
    
    func getPointType(type: String) -> String {
        switch type.lowercased() {
        case "bp":
            return "BUREAU DE POSTE"
        case "a2p":
            return "RETRAIT"
        case "cdi":
            return "DEPOT"
        case "box":
            return "BOITE A LETTRES"
        default:
            return "BUREAU DE POSTE"
        }
    }
    
    func convertPostalOfficeToLocPostalOffice(office: PostalOffice) -> LOCPostalOffice {
        let postalOffice = LOCPostalOffice()
        
        postalOffice.name = office.name
        postalOffice.adresse = office.adresse
        postalOffice.codePostal = office.codePostal
        postalOffice.codeSite = office.codeSite
        postalOffice.libelleSite = office.libelleSite
        postalOffice.complementAdresse = office.complementAdresse
        postalOffice.lieuDit = office.lieuDit
        postalOffice.localite = office.localite
        postalOffice.type = office.type
        postalOffice.libelleType = office.libelleType
        postalOffice.url = office.url
        // START STATUT
        let statut = LOCPostalOfficeStatus()
        
        statut.dateCalcul = office.dateCalcul
        statut.dateChangement = office.dateChangement
        statut.heure = office.heure
        statut.statut = office.statut
        
        postalOffice.statut = statut
        // END STATUT
        
        postalOffice.latitude = office.latitude
        postalOffice.longitude = office.longitude
        
        postalOffice.services = [String]()
        postalOffice.accessibilite = [String]()
        postalOffice.horaires = [String]()
        postalOffice.horaireRetraitDepot = [String]()
        
        if !office.services.isEmpty {
            for service in office.services {
                postalOffice.services.append(service)
            }
        }
        
        if !office.accessibilite.isEmpty {
            for accessibilite in office.accessibilite {
                postalOffice.accessibilite.append(accessibilite)
            }
        }
        
        if !office.horaires.isEmpty {
            for horaire in office.horaires {
                postalOffice.horaires.append(horaire)
            }
        }
        
        
        if !office.horaireRetraitDepot.isEmpty {
            for horaireRetraitDepot in office.horaireRetraitDepot {
                postalOffice.horaireRetraitDepot.append(horaireRetraitDepot)
            }
        }
        
        return postalOffice
    }
    
}
