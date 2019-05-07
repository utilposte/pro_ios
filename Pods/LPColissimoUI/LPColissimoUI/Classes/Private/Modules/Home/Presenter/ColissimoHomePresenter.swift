//
//  ColissimoHomePresenter.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 18/10/2018.
//

import UIKit
import LPColissimo

class ColissimoHomePresenter: NSObject {
    weak var view: ColissimoHomeDelegate?
    var guides = [HomeGuideViewModel]()
    var advantages = [HomeAdvantageViewModel]()
    var services = ColissimoHomeServices()
    var initData : DataContainer?
    
    init(_ view: ColissimoHomeDelegate) {
        self.view = view
    }
    
    
    public func getDataForView(success:@escaping (DataContainer)->Void, failure: @escaping (Error)->Void) {
        guides = services.getTutorialGuideData()
        advantages = services.getAdvantagesData()
        
        ColissimoManager.sharedManager.getInitData(success: { (result) in
            let encoder = JSONEncoder()
            
            ColissimoData.shared.arrivalCountry = ColissimoData.shared.arrivalCountry ?? result.defaultArrivalCountry
            ColissimoData.shared.departureCountry = ColissimoData.shared.departureCountry ?? result.defaultDepartureCountry
            
            ColissimoData.shared.selectedReceiverAddress = result.arrivalCountries.filter({ country -> Bool in
                return country.isocode! == ColissimoData.shared.arrivalCountry
            }).first
            
            ColissimoData.shared.selectedSenderAddress = result.departuresCountries.filter({ country -> Bool in
                return country.isocode! == ColissimoData.shared.departureCountry
            }).first
            
            if let encoded = try? encoder.encode(result.internationalInsurances) {
                UserDefaults.standard.set(encoded, forKey: "InternationalInsurances")
            }
            
            ColissimoData.shared.weight = ColissimoData.shared.weight ?? result.defaultPrice.weight
            ColissimoData.shared.price = ColissimoData.shared.priceHT ?? result.defaultPrice.totalHT
            
            if let encoded = try? encoder.encode(result.nationalInsurances) {
                UserDefaults.standard.set(encoded, forKey: "NationalInsurances")
            }
            
            ColissimoData.shared.defaultCompensationByWeight = result.defaultCompensationByWeight
            
            self.initData = result
            self.view?.setUpDefaultValues()
            
            success(result)
        }) { (error) in
            // TODO: GetError Message
            failure(error)
        }
        
        self.view?.setGuideS(guides: guides)
        
        let images = services.getImagesForPager()
        self.view?.setPageViewCollectionImages(images: images)
        
    }
    
    
    func getDataForView() {
        guides = services.getTutorialGuideData()
        advantages = services.getAdvantagesData()
        
        ColissimoManager.sharedManager.getInitData(success: { (result) in
            ColissimoData.shared.weight = result.defaultPrice.weight
            ColissimoData.shared.price = result.defaultPrice.totalHT
            ColissimoData.shared.priceHT = result.defaultPrice.prixHT
            ColissimoData.shared.defaultCompensationByWeight = result.defaultCompensationByWeight
            
            ColissimoData.shared.arrivalCountry = result.defaultArrivalCountry
            ColissimoData.shared.departureCountry = result.defaultDepartureCountry
            
            ColissimoData.shared.selectedReceiverAddress = result.arrivalCountries.filter({ country -> Bool in
                return country.isocode! == ColissimoData.shared.arrivalCountry
            }).first
            
            ColissimoData.shared.selectedSenderAddress = result.departuresCountries.filter({ country -> Bool in
                return country.isocode! == ColissimoData.shared.departureCountry
            }).first
            
            self.initData = result
            self.view?.setUpDefaultValues()
        }) { (error) in
            // TODO: GetError Message
        }
        
        self.view?.setGuideS(guides: guides)
        
        let images = services.getImagesForPager()
        self.view?.setPageViewCollectionImages(images: images)
    }
    
    func getTextForDepartureCountry() -> String {
        var result = ""
        guard let departureCountry = ColissimoData.shared.departureCountry else {
            print("⛔️⛔️⛔️ Colissimo.shared.departureCountry is nil ⛔️⛔️⛔️")
            return result
        }
        
        if let countries = initData?.departuresCountries {
            result = ColissimoObjectMapper.getCountryFromIsoCode(countries, isoCode: departureCountry)?.name ?? ""
        }
        return result
    }
    
    func getTextForArrivalCountry() -> String {
        var result = ""
        guard let arrivalCountry = ColissimoData.shared.arrivalCountry else {
            print("⛔️⛔️⛔️ Colissimo.shared.arrivalCountry is nil ⛔️⛔️⛔️")
            return result
        }
        
        if let countries = initData?.arrivalCountries {
            result = ColissimoObjectMapper.getCountryFromIsoCode(countries, isoCode: arrivalCountry)?.name ?? ""
        }
        return result
    }
    
    func getTextsForWeight() -> (String,String) {
        var result = ""
        var formattedResult = ""
        
        let weight = ColissimoData.shared.weight ?? 0
        
        result = ColissimoObjectMapper.weightInKilos(weight: weight)
        formattedResult = ColissimoObjectMapper.weightInGrames(weight: weight)
        
        return (result,formattedResult)
    }
    
    func getTextForPrice() -> String {
        var result = ""
        let price = ColissimoData.shared.price ?? 0
        result = ColissimoObjectMapper.priceString(price: price)
        return result
    }
    // MARK: - HOME ViewController
    
    func generateGuideCellsIn(_ tablelView : UITableView) {
        var guideCells = [UITableViewCell]()
        for guide in self.guides {
            if let cell = tablelView.dequeueReusableCell(withIdentifier: "ColissimoHomeGuideCell") as? ColissimoHomeGuideCell {
                cell.setUpCellWith(guide: guide)
                guideCells.append(cell)
                
            }
            if guide.isExpanded == true {
                for guideDetail in guide.details {
                    if guideDetail.isExpandable == true {
                        if let cell = tablelView.dequeueReusableCell(withIdentifier: "ColissimoHomeGuideDetailHeaderCell") as? ColissimoHomeGuideDetailHeaderCell {
                            cell.setUpCellWith(guide: guideDetail)
                            guideCells.append(cell)
                        }
                        if guideDetail.isExpanded == true{
                            if let cell = tablelView.dequeueReusableCell(withIdentifier: "ColissimoHomeGuideDetailCell") as? ColissimoHomeGuideDetailCell {
                                cell.setUpCellWith(guide: guideDetail)
                                guideCells.append(cell)
                            }
                        }
                    }
                    else {
                        if let cell = tablelView.dequeueReusableCell(withIdentifier: "ColissimoHomeGuideDetailCell") as? ColissimoHomeGuideDetailCell {
                            cell.setUpCellWith(guide: guideDetail)
                            guideCells.append(cell)
                        }
                    }
                }
            }
        }
        // Add Button cell
        if let cell = tablelView.dequeueReusableCell(withIdentifier: "ColissimoHomeAddButtonCell") as? ColissimoHomeAddButtonCell {
            cell.backgroundColor = UIColor.white
            guideCells.append(cell)
        }
        
        self.view?.setGuideCells(cells: guideCells)
    }
    
    func generateAdvantageCellsIn(_ tablelView : UITableView) {
        var advantageCells = [UITableViewCell]()
        // Add Button cell
        if let cell = tablelView.dequeueReusableCell(withIdentifier: "ColissimoHomeAdvantageHeaderCell") as? ColissimoHomeAdvantageHeaderCell {
            advantageCells.append(cell)
        }
        
        for advantage in self.advantages {
            if let cell = tablelView.dequeueReusableCell(withIdentifier: "ColissimoHomeAdvantagesCell") as? ColissimoHomeAdvantagesCell {
                cell.configureCell(avantage: advantage)
                advantageCells.append(cell)
            }
        }
        // Add Button cell
        if let cell = tablelView.dequeueReusableCell(withIdentifier: "ColissimoHomeAddButtonCell") as? ColissimoHomeAddButtonCell {
            cell.backgroundColor = UIColor(red: 249/255, green: 245/255, blue: 241/255, alpha: 1)
            advantageCells.append(cell)
        }
        
        self.view?.setAdvantageCells(cells: advantageCells)
    }
    
    
    func didSelectCell(tableView: UITableView, indexPath: IndexPath) {
        var tmpGuides = self.guides
        if let cell = tableView.cellForRow(at: indexPath) as? ColissimoHomeGuideCell {
            
            for i in 0...tmpGuides.count-1 {
                var tmpGuide = tmpGuides[i]
                if cell.guide?.idGuide == tmpGuide.idGuide {
                    tmpGuide.isExpanded = !tmpGuide.isExpanded
                    tmpGuides[i] = tmpGuide
                    self.guides = tmpGuides
                    self.generateGuideCellsIn(tableView)
                    break
                }
            }
        }
        if let cell = tableView.cellForRow(at: indexPath) as? ColissimoHomeGuideDetailHeaderCell {
            for i in 0...tmpGuides.count-1 {
                var tmpGuide = tmpGuides[i]
                for y in 0...tmpGuide.details.count-1 {
                    var tmpGuideDetail = tmpGuide.details[y]
                    if cell.guide?.idGuide == tmpGuideDetail.idGuide {
                        tmpGuideDetail.isExpanded = !tmpGuideDetail.isExpanded
                        tmpGuide.details[y] = tmpGuideDetail
                        tmpGuides[i] = tmpGuide
                        self.guides = tmpGuides
                        self.generateGuideCellsIn(tableView)
                        break
                    }
                }
            }
        }
    }
    
    
    // MARK: - PICKER ViewController
    func getCountriesWithType(type : PickerType) -> [CLCountry] {
        if let data = initData {
            switch type {
            case .arrival:
                return data.arrivalCountries
                
            case .departure:
                return data.departuresCountries
            default:
                return [CLCountry]()
            }
        }
        return [CLCountry]()
    }
    
    func dismissPickerView() {
        self.view?.dismissPickerView()
    }
    
    func selectCountryWithType(country : CLCountry, type : PickerType) {
        if type == .departure {
            ColissimoData.shared.departureCountry = country.isocode
            ColissimoData.shared.selectedSenderAddress = country
            self.view?.setDepartureCountry(country: country.name)
            self.callGetPrice()
        }
        else if type == .arrival {
            ColissimoData.shared.arrivalCountry = country.isocode
            ColissimoData.shared.selectedReceiverAddress = country
            self.view?.setArrivalCountry(country: country.name)
            self.callGetPrice()
        }
    }
    
    // MARK: - Price
    func calculatePrice(weight : String) -> Bool {
        var isValid = true
        var stringWeight = weight.replacingOccurrences(of: ",", with: ".")
        stringWeight = stringWeight.replacingOccurrences(of: " Kg", with: "")
        guard let weightValue = Double(stringWeight) else {
            ColissimoData.shared.weight = initData?.defaultPrice.weight ?? 0.25
            let error = LocalizedColissimoUI(key: "k_home_error_default_value")
            self.view?.showErrorView(error)
            callGetPrice()
            return false
        }
        let country = ColissimoObjectMapper.getCountryFromIsoCode(initData?.arrivalCountries ?? [CLCountry](), isoCode: ColissimoData.shared.arrivalCountry ?? "")
        
        if weightValue <= 0 {
            ColissimoData.shared.weight = initData?.defaultPrice.weight ?? 0.25
            let error = LocalizedColissimoUI(key: "k_home_error_default_value")
            self.view?.showErrorView(error)
            isValid = false
        }
        else if weightValue > country?.poidsmax ?? 30 {
            ColissimoData.shared.weight = country?.poidsmax ?? 30
            let error = LocalizedColissimoUI(key: "k_home_error_max_value")
            self.view?.showErrorView(error)
            isValid = false
        }
        else {
            ColissimoData.shared.weight = weightValue
        }
        
        callGetPrice()
        return isValid
    }
    
    func callGetPrice() {
        guard let departureCountry = ColissimoData.shared.departureCountry, let arrivalCountry = ColissimoData.shared.arrivalCountry, let weight = ColissimoData.shared.weight, let surcout = ColissimoData.shared.isSurcout else {
            print("⛔️⛔️⛔️ callGetPrice contains nil ⛔️⛔️⛔️")
            return
        }
        
        let apiClient = ColissimoAPIClient.sharedInstance
        apiClient.getPrice(fromIsoCode: departureCountry, toIsoCode: arrivalCountry, weight: weight, deposit: "BUREAU_POSTE", insuredValue: 0.0, withSignature: false, indemnitePlus: false, withSurcout: surcout, success: { (price) in
            ColissimoData.shared.price = price.totalHT
            ColissimoData.shared.priceHT = price.prixHT
            self.view?.priceDidChange(price: self.getTextForPrice())
        }) { (error) in
            print("ERROR \(error.localizedDescription)")
            // Error Message
        }
    }
}
