//
//  InitialNetworkingManager.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 06/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

class InitialNetworkingManager {
    
    //get data from server: Country list, company type list, function list
    //data used in account view controller
    func initData(onCompletion: @escaping (Bool) -> Void) {
        Alamofire.request(createUrlForInit()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let responseObject = value as? [String : Any], let responseObjectCountries = responseObject["countries"] as? [Any],let responseObjectFunctions = responseObject["functions"] as? [Any], let responseObjectCompanyTypes = responseObject["companyTypes"] as? [Any] {
                    DataCountry().parseCountries(countryListFromResponse: responseObjectCountries)
                    Function().parseFunctions(functionsFromResponse: responseObjectFunctions)
                    CompanyType().parseCompanyType(companyTypesFromResponse: responseObjectCompanyTypes)
                    onCompletion(true)
                } else {
                    if DataCountry().getCounties().count > 0 && Function().getFunctions().count > 0 && CompanyType().getCompanyTypes().count > 0 {
                        onCompletion(true)
                    }
                    else {
                        onCompletion(false)
                    }
                }
            case .failure(_):
                if DataCountry().getCounties().count > 0 && Function().getFunctions().count > 0 && CompanyType().getCompanyTypes().count > 0 {
                    onCompletion(true)
                }
                else {
                    onCompletion(false)
                }
            }
        }
    }
    
    private func createUrlForInit() -> String {
        let url = String(format: "%@%@/%@%@", "https://", EnvironmentUrlsManager.sharedManager.getHybrisServiceHost(), createWSSuffix() ,Constants.initDataForInscriptionUrl)
        return url
    }
    
    private func createWSSuffix() -> String {
        var wsSuffix = ""
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: Constants.EnvironmentsHybrisPlistFileName, ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            let defaultDictionary = dict[Constants.DefaultPlistDictionary] as! [String : String]
            wsSuffix = String(format: "%@/%@", defaultDictionary[Constants.webServiceKeyForConfiguration]!, defaultDictionary[Constants.boutiqueTypeKeyForConfiguration]!)
        }
        return wsSuffix
    }
}
