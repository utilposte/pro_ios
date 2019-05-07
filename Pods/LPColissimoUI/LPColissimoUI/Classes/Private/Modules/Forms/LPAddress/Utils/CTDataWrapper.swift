//
//  CTDataWrapper.swift
//  laposte
//
//  Created by Issam DAHECH on 04/12/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

import UIKit
//import SwiftyJSON

class CTDataWrapper: NSObject {
    static let sharedInstanse = CTDataWrapper()
    
    let lettreLittleObjectColor = UIColor(hex:"92D050")
    let lettreRecomendedColor    = UIColor(hex:"5B9BD5")
    let colisColor              = UIColor(hex:"F47E3C")
    
    let validationbuttonEnabledColor   = UIColor(red: 255/255, green: 192/255, blue: 1/255, alpha: 1)
    let validationbuttonDisabledColor   = UIColor(red: 255/255, green: 192/255, blue: 1/255, alpha: 0.5)
    var mappingDataDictionnary  = [String: [String:String]]()
    var trackingIdDictionnary = [String : [String:String]]()
    
    override init() {
        if let path = Bundle.main.path(forResource: "CTDataMapingForDisplay", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, Dictionary<String,String>> {
                    mappingDataDictionnary = jsonResult
                }
            } catch {
                // handle error
            }
        }
        if let path = Bundle.main.path(forResource: "MCommerceTrackingKeys", ofType: "plist") {
            trackingIdDictionnary = NSDictionary(contentsOfFile: path) as! [String : [String : String]]
        }
    }
    
    
    func getSetpList(filterList : NSMutableDictionary) -> [CTStep] {
        var arrayList = [CTStep]()
        var aDic :NSDictionary
        for (filterName , filterDictionary) in filterList {
            var filterData = filterDictionary as! [String:Any]
            if filterData[CTConstants.filterTypeDictionaryKey] as! String == CTConstants.filterTextFieldType {
                aDic = ["type":filterData[CTConstants.filterTypeDictionaryKey] as! String,
                        "data":"",
                        "defaultVaue":1,
                        "listChoise":[String]() ]
            } else {
                aDic = ["type":filterData[CTConstants.filterTypeDictionaryKey] as! String,
                        "data":"",
                        "defaultVaue":1,
                        "listChoise":filterData[CTConstants.filterValuesDictionaryKey] as! [String]]
            }
            print(filterName)
            arrayList.append(CTStep(aDic: aDic))
        }
        return arrayList
    }
    
    func getCurrentColor(step1 : Int) -> UIColor {
        switch step1 {
        case 1:
            return lettreLittleObjectColor
        case 2:
            return lettreRecomendedColor
        case 3:
            return colisColor
        default :
            return UIColor.white
        }
    }
    
    func getCellIdentifier(step:CTStep) -> String{
        
        if step.type == CTConstants.filterLocationType {
            return "CTLocationTypeCell"
        }
        else if step.type == CTConstants.filterTwoButtonType {
            return "CTTwoButtonsTypeCell"
        }
        else if step.type == CTConstants.filterFoorTextButtonType {
            return "CTFoorButtonsCell"
        }
        else if step.type == CTConstants.filterSwitchType {
            return "CTSwitchCell"
        }
        else if step.type == CTConstants.filterThreeTextButtonType {
            return "CTThreeButtonsTextCell"
        }
        else if step.type == CTConstants.filterTextFieldType {
            return "CTTextFieldCell"
        }
        else {
            return "CTSwitchCell"
        }
    }
    
    func getCellHeight(step : CTStep) -> CGFloat {
        switch step.type {
        case CTConstants.filterLocationType :
            return 50.0
        case CTConstants.filterSwitchType :
            return 50.0
        case CTConstants.filterTextFieldType :
            return 55.0
        case CTConstants.filterListType :
            return 70.0
        case CTConstants.filterUnknownType:
            return 0
        case CTConstants.filterTwoButtonType:
            return 60.0
        case CTConstants.filterThreeTextButtonType:
            return 60
        case CTConstants.filterFoorTextButtonType:
            return 70
        default:
            return 0
        }
    }
    /*
    func getCountryListForDomTom(shippementNatureIndex : Int) -> [CTCountry] {
        var countryList = [CTCountry]()
        var jsonNatureName = ""
        if let path = Bundle.main.path(forResource: "domtom", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonresult = try JSON(data: data)
                switch shippementNatureIndex {
                case 1:
                    jsonNatureName = "lettres_et_po"
                    break
                case 2:
                    jsonNatureName = "recommande"
                    break
                case 2:
                    jsonNatureName = "colis"
                    break
                default :
                    jsonNatureName = "lettres_et_po"
                }
                let jsonCountryList = jsonresult["Liste_pays"][0][jsonNatureName]
                for (_,subJson):(String, JSON) in jsonCountryList {
                    countryList.append(CTCountry.init(dic: subJson.dictionaryObject!))
                }
            } catch {
                
            }
        }
        return countryList
    }
    
    func getCountryListForInternationnal(shippementNatureIndex : Int) -> [CTCountry] {
        var countryList = [CTCountry]()
        var jsonNatureName = ""
        if let path = Bundle.main.path(forResource: "international", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonresult = try JSON(data: data)
                switch shippementNatureIndex {
                    case 1:
                        jsonNatureName = "lettres_et_po"
                        break
                    case 2:
                         jsonNatureName = "recommande"
                        break
                    case 2:
                        jsonNatureName = "colis"
                        break
                    default :
                        jsonNatureName = "lettres_et_po"
                }
                let jsonCountryList = jsonresult["Liste_pays"][0][jsonNatureName]
                for (_,subJson):(String, JSON) in jsonCountryList {
                    countryList.append(CTCountry.init(dic: subJson.dictionaryObject!))
                }
            } catch {
                
            }
        }
        return countryList
    }
    */
    func getMaxWeightWithShippementType (shippementType : Int) -> String {
        switch shippementType {
        case 1:
            return "30000 grammes maximum"
        case 2:
            return "3000 grammes maximum"
        case 3:
            return "30000 grammes maximum"
        default:
            return "30000 grammes maximum"
        }
    }
    
    func getMappingListForDisplay (stepName : String) -> [String : String] {
        if let aDic = self.mappingDataDictionnary[stepName] {
            return aDic
        } else {
            return [:]
        }
    }
}

