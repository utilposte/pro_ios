//
//  ColissimoAPIRouter.swift
//  Alamofire
//
//  Created by SPASOV DIMITROV Vladimir on 22/10/18.
//

import Alamofire

enum  ColissimoAPIRouter {
    
    case initColissimo()
    case getPrice(fromIsoCode: String, toIsoCode: String, weight: Double, deposit: String?, insuredValue: Double?, withSignature: Bool?, indemnitePlus: Bool?, withSurcout: Bool?)
    case getDepotMode(weigth: Double, typeColis: String, fromIsoCode: String, toIsoCode: String, postalCode: String, locality: String, line2: String)
    case getDeliveryMode(weigth: Double, transportPrice: Double, toIsoCode: String, withSignature: Bool)
    
    
    // MARK: - HTTPMethod
    var method: Alamofire.HTTPMethod {
        switch self {
        case .initColissimo:
            return .get
        case .getPrice:
            return .post
        case .getDepotMode:
            return .get
        case .getDeliveryMode:
            return .get
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .initColissimo:
            return nil
        case .getPrice(let fromIsoCode, let toIsoCode, let weight, let deposit, let insuredValue, let withSignature, let indemnitePlus, let withSurcout):
            let parameters = [
                "fromIsoCountry": fromIsoCode,
                "toIsoCountry": toIsoCode,
                "poid": weight,
                "choixDepot": deposit ?? "",
                "insuredValue": insuredValue ?? 0.0,
                "avecSignature": withSignature ?? false,
                "indemnitePlus": indemnitePlus ?? false,
                "withSurcout": withSurcout ?? false
                ] as [String : Any]
            return parameters
        case .getDepotMode:
            return nil
        case .getDeliveryMode:
            return nil
        }
    }
    
    var parameterEncoding: URLEncoding {
        switch self {
        case .initColissimo, .getDepotMode, .getDeliveryMode:
            return URLEncoding.methodDependent
        case .getPrice(let fromIsoCode, let toIsoCode, let weight, let deposit, let insuredValue, let withSignature, let indemnitePlus, let withSurcout):
            return URLEncoding.httpBody
        }
    }
    
    var headers: HTTPHeaders{
        switch self {
            
        case .initColissimo, .getDepotMode, .getDeliveryMode:
            return [HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue,
             HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
             HTTPHeaderField.authentication.rawValue: ColissimoAPIClient.sharedInstance.accessToken]
        case .getPrice(let fromIsoCode, let toIsoCode, let weight, let deposit, let insuredValue, let withSignature, let indemnitePlus, let withSurcout):
            return [HTTPHeaderField.contentType.rawValue: ContentType.urlEncoded.rawValue]
        }
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
}

enum Colissimo {
    static let colisimoWS = "/eboutiquecommercewebservices/v2/eboutiquePro/ColissimoWs/"
}



extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: []) )as? [String: Any]
    }
}

extension ColissimoAPIRouter: URLConvertible {
    func asURL() throws -> URL {
        let baseUrl = try ColissimoAPIClient.sharedInstance.baseUrl
        var endpoint : String
        switch self {
        case .initColissimo:
            endpoint = "\(Colissimo.colisimoWS)getInitData"
            
        case .getPrice(let fromIsoCode, let toIsoCode, let weight, let deposit, let insuredValue, let withSignature, let indemnitePlus, let withSurcout):
            endpoint = "\(Colissimo.colisimoWS)getRecapPrice"
            
        case .getDepotMode(let weigth, let typeColis, let fromIsoCode, let toIsoCode, let postalCode, let locality, let line2):
            endpoint = "\(Colissimo.colisimoWS)getEligibiliteBal?poids=\(weigth)&typeColis=\(typeColis)&fromIsoCode=\(fromIsoCode)&toIsoCode=\(toIsoCode)&postalCode=\(postalCode)&localite=\(locality)&line2=\(line2)"
            
        case .getDeliveryMode(let weigth, let transportPrice, let toIsoCode, let withSignature):
            endpoint = "\(Colissimo.colisimoWS)getLivraisonModeForColissimo?poids=\(weigth)&netTransportPrice=\(transportPrice)&toIsoCode=\(toIsoCode)&livraisonAvecSignature=\(withSignature)"
        }
        guard let url = try URL(string: baseUrl + endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            throw NSError()
        }
        return url
    }
}

