//
//  TrackManager.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 01/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import Alamofire

public class TrackManager {

    public static let shared = TrackManager()
    
    private init() { }
    
    public var host : String = ""
    
    public func setHost(_ host: String) {
        self.host = host
    }
    
    public func getShipmentFor(trackCode: String, completion:((Bool, ResponseTrack?) -> ())?) {
        Alamofire.request(self.host + "/particulier/proxy/outils/suivre-vos-envois/" + trackCode).responseJSON { response in
            if let json = response.result.value {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let reqJSONStr = String(data: jsonData, encoding: .utf8)
                    let data = reqJSONStr?.data(using: .utf8)
                    let jsonDecoder = JSONDecoder()
                    let rootFollow = try jsonDecoder.decode(RootTrack.self, from:data!) as RootTrack
                    if let responseFollow = rootFollow.response {
                        if let returnCode = rootFollow.response?.returnCode {
                            if (returnCode >= 200 && returnCode < 300) {
                                completion?(true,responseFollow)
                                return
                            }
                        }
                        completion?(false,responseFollow)
                        return
                    }
                }   catch let error {
                    print(error)
                    completion?(false,nil)
                    return
                }
            }
            completion?(false,nil)
            return
        }
    }
}
