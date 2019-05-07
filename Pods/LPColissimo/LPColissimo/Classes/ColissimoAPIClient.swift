//
//  ColissimoAPIClient.swift
//  laposte
//
//  Created by SPASOV DIMITROV Vladimir on 25/7/18.
//  Copyright © 2018 SPASOV DIMITROV Vladimir. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import LPSharedMCM


public class ColissimoAPIClient {
    
    public static let sharedInstance = ColissimoAPIClient()
    public var accessToken : String = ""
    public var baseUrl : String = "https://dpart2.boutique.dcos.buildbnum.fr"
    {
        didSet{
            print("👀  \(#function) 👀baseUrl->\(baseUrl)");
        }
    }
    
    @discardableResult
    // TODO: Once Alamofire 5 is out remove the CodableAlamofire library and use the responseJSONDecodable method
    private func performRequest<T:Decodable>(route:ColissimoAPIRouter, decoder: JSONDecoder = JSONDecoder(), success: ((T)->Void)?, failure:@escaping (Error)->Void) -> DataRequest {
        let req = Alamofire.request(route,
                                    method: route.method,
                                    parameters: route.parameters,
                                    encoding: route.parameterEncoding,
                                    headers: route.headers)
            .debugLog()
            .responseDecodableObject { (response: DataResponse<T>) in

                 let result = response.result
                //            print("FB: response.result: \(result)")
                
                guard let httpResponse = response.response else {
                    let myError = NSError(domain:"Error", code: 123, userInfo: [:])
                    //                failure(myError)
                    return
                }
                let status = httpResponse.statusCode
                // print("FB: status: \(status)")
                if result.isFailure{
                    if let error:NSError = response.error as! NSError {
                        failure(error)
                    } else{
                        // IT'S NOT AN ERROR BUT STILL NOT AN HTTP 2XX
                        // LET'S TREAT IT AS AN ERROR ANYWAY
                        let myError = NSError(domain:"", code: status, userInfo: nil)
                        failure(myError)
                    }
                }
                else{
                    // SUCCESS,
                    switch( status){
                    case 208:
                        // NO DEVUELVE SHIPMENT OBJECT
                        let value: T = result.value!
                        // print("FB: shipment: \(value)")
                        success!(value)
                    case 200 ..< 299:
                        let value: T = result.value!
                        // print("FB: shipment: \(value)")
                        success!(value)
                    default:
                        // LET'S TREAT IT AS AN ERROR ANYWAY
                        let myError = NSError(domain:"", code: status, userInfo: nil)
                        // print("FB: value: \(result.value)")
                        // print("FB: description: \(result.description)")
                        // print("FB: error: \(result.error)")
                        failure(myError)
                    }
                }
                return
        }
//        _ = req.request!.allHTTPHeaderFields!
//        // print("FB: Req: \(req)")
//        // print("FB: Req Headers: \(reqHeaders)")
//        if let bodyData = req.request!.httpBody{
//            _ = String(data: bodyData, encoding: .utf8)!
//            // print("FB: Req Body: \(reqBody)")
//        }
        return req
    }
    
    public func getInitData(success:@escaping (DataContainer)->Void, failure: @escaping (Error)->Void) {
        performRequest(route: ColissimoAPIRouter.initColissimo(), success: success, failure: failure)
    }
    
    public func getPrice(fromIsoCode: String, toIsoCode: String, weight: Double, deposit: String?, insuredValue: Double?, withSignature: Bool?, indemnitePlus: Bool?, withSurcout: Bool?, success:@escaping (CLPrice)->Void, failure: @escaping (Error)->Void) {
        performRequest(route: ColissimoAPIRouter.getPrice(fromIsoCode: fromIsoCode, toIsoCode: toIsoCode, weight: weight, deposit: deposit, insuredValue: insuredValue, withSignature: withSignature, indemnitePlus: indemnitePlus, withSurcout: withSurcout), success: success, failure: failure)
    }
    
    public func getDepotMode(weigth: Double, typeColis: String, fromIsoCode: String, toIsoCode: String, postalCode: String, locality: String, line2: String, success:@escaping (CLDepotModeResponse)->Void, failure: @escaping (Error)->Void) {
        performRequest(route: ColissimoAPIRouter.getDepotMode(weigth: weigth, typeColis: typeColis, fromIsoCode: fromIsoCode, toIsoCode: toIsoCode, postalCode: postalCode, locality: locality, line2: line2), success: success, failure: failure)
    }
    
    public func getDeliveryMode(weigth: Double, transportPrice: Double, toIsoCode: String, withSignature: Bool, success:@escaping (CLDeliveryModeResponse)->Void, failure: @escaping (Error)->Void) {
        performRequest(route: ColissimoAPIRouter.getDeliveryMode(weigth: weigth, transportPrice: transportPrice, toIsoCode: toIsoCode, withSignature: withSignature), success: success, failure: failure)
    }
    
}

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

extension URLRequest {
    func log() {
        //         print("\(httpMethod ?? "") \(self)")
        //         print("BODY \n \(httpBody?.toString())")
        //         print(self.value(forHTTPHeaderField: "Accept"))
        //         print(self.value(forHTTPHeaderField: "Authorization"))
    }
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        #endif
        return self
    }
}



