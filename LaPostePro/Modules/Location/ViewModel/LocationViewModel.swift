//
//  LocationMapViewModel.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedLOC
import MapKit
import RealmSwift
import UIKit

class LocationViewModel: NSObject {
    var selectedLocation: CLLocation?
    var selectedType = SelectedType.postOffice {
        didSet {
            print ("***debug LocationMapView selectedType -> \(selectedType)")
        }
    }
    var searchType = SearchType.location
    
    var pointTypeSelectedValue = 0
    var hourSelectedValue = 0
    var daySeletedValue = 0
    
    let sharedManager: LOCSharedManager = (LOCSharedManager.sharedManager() as? LOCSharedManager)!
    
    var postOfficeList = [LOCPostalOffice]()
    var retreiveList = [LOCPostalOffice]()
    var depotList = [LOCPostalOffice]()
    var postBoxList = [LOCPostBox]()
    
    lazy var loaderManager = LoaderViewManager()
    
    func getListPostOffice(latitude: Double, longitude: Double, onCompletion: @escaping ([LOCPostalOffice]) -> Void) {
        if !postOfficeList.isEmpty {
            onCompletion(postOfficeList)
            return
        }
        loaderManager.showLoderView()
        sharedManager.getPostOfficeListNearby(latitude, longitude: longitude) { result in
            if let listPostOffice = result as? [LOCPostalOffice] {
                self.postOfficeList = listPostOffice
            } else {
                self.postOfficeList = [LOCPostalOffice]()
            }
            onCompletion(self.postOfficeList)
            self.loaderManager.hideLoaderView()
        }
    }
    
    func getListPostOffice(searchText: String, onCompletion: @escaping ([LOCPostalOffice]) -> Void) {
        self.postOfficeList = [LOCPostalOffice]()
        loaderManager.showLoderView()
        sharedManager.getPostOfficeList(byText: searchText, with: { result in
            if let listPostOffice = result as? [LOCPostalOffice] {
                self.postOfficeList = listPostOffice
            } else {
                self.postOfficeList = [LOCPostalOffice]()
            }
            onCompletion(self.postOfficeList)
            self.loaderManager.hideLoaderView()
        })
    }
    
    func getListDepot(latitude: Double, longitude: Double, onCompletion: @escaping ([LOCPostalOffice]) -> Void) {
        loaderManager.showLoderView()
        sharedManager.getRetraitDepotList(true, nearbyList: latitude, longitude: longitude) { result in
            if let listPostOffice = result as? [LOCPostalOffice] {
                self.depotList = listPostOffice
            } else {
                self.depotList = [LOCPostalOffice]()
            }
            onCompletion(self.depotList)
            self.loaderManager.hideLoaderView()
        }
    }
    
    func getListDepot(searchText: String, onCompletion: @escaping ([LOCPostalOffice]) -> Void) {
        self.depotList = [LOCPostalOffice]()
        loaderManager.showLoderView()
        sharedManager.getRetraitDepotList(true, byText: searchText, with: { result in
            if let listPostOffice = result as? [LOCPostalOffice] {
                self.depotList = listPostOffice
            } else {
                self.depotList = [LOCPostalOffice]()
            }
            onCompletion(self.depotList)
            self.loaderManager.hideLoaderView()
        })
    }
    
    func getListRetreive(latitude: Double, longitude: Double, onCompletion: @escaping ([LOCPostalOffice]) -> Void) {
        loaderManager.showLoderView()
        sharedManager.getRetraitDepotList(false, nearbyList: latitude, longitude: longitude) { result in
            if let listPostOffice = result as? [LOCPostalOffice] {
                self.retreiveList = listPostOffice
            } else {
                self.retreiveList = [LOCPostalOffice]()
            }
            onCompletion(self.retreiveList)
            self.loaderManager.hideLoaderView()
        }
    }
    
    func getListRetreive(searchText: String, onCompletion: @escaping ([LOCPostalOffice]) -> Void) {
        self.depotList = [LOCPostalOffice]()
        loaderManager.showLoderView()
        sharedManager.getRetraitDepotList(false, byText: searchText, with: { result in
            if let listPostOffice = result as? [LOCPostalOffice] {
                self.depotList = listPostOffice
            } else {
                self.depotList = [LOCPostalOffice]()
            }
            onCompletion(self.depotList)
            self.loaderManager.hideLoaderView()
        })
    }
    
    func getListPostBox(latitude: Double, longitude: Double, onCompletion: @escaping ([LOCPostBox]) -> Void) {
        if !postBoxList.isEmpty {
            onCompletion(postBoxList)
            return
        }
        loaderManager.showLoderView()
        sharedManager.getPostBoxListNearby(latitude, longitude: longitude) { result in
            if let listPostOffice = result as? [LOCPostBox] {
                self.postBoxList = listPostOffice
            } else {
                self.postBoxList = [LOCPostBox]()
            }
            onCompletion(self.postBoxList)
            self.loaderManager.hideLoaderView()
        }
    }
    
    func getListPostBox(searchText: String, onCompletion: @escaping ([LOCPostBox]) -> Void) {
        self.postBoxList = [LOCPostBox]()
        loaderManager.showLoderView()
        sharedManager.getPostBoxList(searchText, with: { result in
            if let listPostOffice = result as? [LOCPostBox] {
                self.postBoxList = listPostOffice
            } else {
                self.postBoxList = [LOCPostBox]()
            }
            onCompletion(self.postBoxList)
            self.loaderManager.hideLoaderView()
        })
    }
    
    func getList(pointType: String, day: String, hour: String, onCompletetion: @escaping () -> Void) {
        loaderManager.showLoderView()
        var isDepot = true
        switch selectedType {
        case .depot:
            isDepot = true
        default:
            isDepot = false
        }
        if let latittude = self.selectedLocation?.coordinate.latitude,
            let longitude = self.selectedLocation?.coordinate.longitude {
            sharedManager.getRetraitDepotList(isDepot, nearbyList: latittude, longitude: longitude, byDay: day, byHour: hour, byType: pointType) { result in
                if let postalOffices = result as? [LOCPostalOffice] {
                    switch self.selectedType {
                    case .depot:
                        self.depotList = postalOffices
//                  WHY FETCHING POSTOFFICE RESULT IN GETRETRAITDEPOTLIST ?
//                  case .postOffice:
//                      self.postOfficeList = postalOffices
                    case .retrieve:
                        self.retreiveList = postalOffices
                    default:
                        break
                    }
                }
                onCompletetion()
                self.loaderManager.hideLoaderView()
            }
        } else {
            onCompletetion()
            self.loaderManager.hideLoaderView()
        }
    }
    
    func getPostOfficesPro(place: String) {
        let successCompletion: ((PostOfficesPro) -> Void) = { postOffices in
            self.loaderManager.hideLoaderView()
            print(postOffices)
        }
        
        let failureCompetion: (() -> Void) = {
            self.loaderManager.hideLoaderView()
            // TODO : Display an error message
        }
        
        self.loaderManager.showLoderView()
        sharedManager.fetchProPostOffices(place: place, success: successCompletion, failure: failureCompetion)
    }
    
    func getResultList() -> [LOCPostalOffice] {
        switch selectedType {
        case .depot:
            return depotList
        case .retrieve:
            return retreiveList
        default:
            return postOfficeList
        }
    }
    
    // MARK: - Utils
    
    func checkUserLocationpermissions(locationManager: CLLocationManager, onCompletion: @escaping (UIAlertController) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                
            case .denied, .restricted:
                let alertController = UIAlertController(title: nil, message: "Merci de permettre à l'application d'accéder à votre position pour trouver les bureaux de poste autour de vous.", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Paramètres", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                let cancelAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                onCompletion(alertController)
            default:
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            }
        } else {
            let alertController = UIAlertController(title: nil, message: "Merci d'activer la géolocalisation pour que l'application puisse vous trouver les bureaux de poste autour de vous", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Paramètres", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string:UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            let cancelAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            onCompletion(alertController)
        }
    }
    
    func checkUserLocationpermissions(locationManager: CLLocationManager) -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            case .denied, .restricted, .notDetermined:
                return false
            }
        }
        return false
    }
    
    func clearData() {
        postOfficeList = [LOCPostalOffice]()
        retreiveList = [LOCPostalOffice]()
        depotList = [LOCPostalOffice]()
        postBoxList = [LOCPostBox]()
    }
    
    func getImageFromType(_ typeString: String?) -> UIImage {
        guard let type = typeString else {
            return R.image.ic_pin_bp()!
        }
        if type == "A2P" {
            return R.image.ic_pin_shop()!
        } else if type == "CDI" {
            return R.image.ic_pin_pickup()!
        } else if type == "Box" {
            return R.image.ic_pin_letterbox()!
        }
        return R.image.ic_pin_bp()!
    }
    
    func getSelectedImageFromType(_ typeString: String?) -> UIImage {
        guard let type = typeString else {
            return R.image.ic_pin_bp_focus()!
        }
        if type == "A2P" {
            return R.image.ic_pin_shop_focus()!
        } else if type == "CDI" {
            return R.image.ic_pin_pickup_focus()!
        }
        return R.image.ic_pin_bp()!
    }
    
    func regionForAnnotations(annotations: [Annotation]) -> MKCoordinateRegion? {
        if annotations.isEmpty { return nil }
        var topLeftCoord = CLLocationCoordinate2DMake(-90, 180)
        
        var bottomRightCoord = CLLocationCoordinate2DMake(90, -180)
        
        for annotation in annotations {
            let tempLoc: CLLocation? = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, (tempLoc?.coordinate.latitude)!)
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, (tempLoc?.coordinate.longitude)!)
            
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, (tempLoc?.coordinate.latitude)!)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, (tempLoc?.coordinate.longitude)!)
        }
        
        var centerCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(0, 0)
        
        centerCoordinate?.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        centerCoordinate?.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        
        var region = MKCoordinateRegion()
        region.center.latitude = (centerCoordinate?.latitude)!
        region.center.longitude = (centerCoordinate?.longitude)!
        
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2
        
        return region
    }
    
    func getPostOfficeDetails(codeSite: String, onCompletion: @escaping (LOCPostalOffice?) -> Void) {
        sharedManager.getPostOfficeDetail(byKey: codeSite) { postalOffice in
            if postalOffice != nil {
                onCompletion(postalOffice!)
            } else {
                onCompletion(nil)
            }
        }
    }
    
    func getWorkingHours(for array: [Any], date: Date) -> ([Any]?, [Any]?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        for dictioanry in array {
            let dateDicionary = dictioanry as? [String: AnyObject]
            let dateToShow = dateDicionary!["date"] as! String
            if dateString == dateToShow {
                let hoursArray = dateDicionary!["horaires"] as! [String]
                var hoursLimits: [Any]?
                var openingHours: [Any]?
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
                
                if hoursArray.count > 1 {
                    openingHours = [[dateFormatter.string(from: date).capitalized, "\(hoursArray.first!)\n\(hoursArray.last!)"]]
                } else if hoursArray.count == 1 {
                    openingHours = [[dateFormatter.string(from: date).capitalized, hoursArray.first!]]
                }
                if let hoursDictionary = dateDicionary!["heures_limites"] as? [String: AnyObject] {
                    hoursLimits = hoursDictionary.map { $0.value }
                }
                return (openingHours, hoursLimits as? [NSArray])
            }
        }
        return (nil, nil)
    }
    
    func getLastDayDate(in datesArray: [Any]) -> Date {
        if !datesArray.isEmpty {
            let lastItem = datesArray.last as? [String: AnyObject]
            let lastDate = lastItem!["date"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: lastDate) ?? Date()
        }
        return Date()
    }
    
    func getAreaImage(index: Int) -> MKMapSnapshotter {
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        let region = MKCoordinateRegionMakeWithDistance(getPointPosition(index: index), 1000, 1000)
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
    
    func getPointPosition(index: Int) -> CLLocationCoordinate2D {
        var lat: Double?
        var lng: Double?
        if isCellDidExist(index: index) {
            switch selectedType {
            case .postOffice:
                lat = postOfficeList[index].latitude
                lng = postOfficeList[index].longitude
            case .depot:
                lat = depotList[index].latitude
                lng = depotList[index].longitude
            case .retrieve:
                lat = retreiveList[index].latitude
                lng = retreiveList[index].longitude
            case .postBox:
                lat = postBoxList[index].latitude
                lng = postBoxList[index].longitude
            }
        } else {
            lat = 0
            lng = 0
        }
        return CLLocationCoordinate2DMake(lat!, lng!)
    }
    
    func getListCount() -> Int {
        switch selectedType {
        case .postOffice:
            return postOfficeList.count
        case .depot:
            return depotList.count
        case .retrieve:
            return retreiveList.count
        case .postBox:
            return postBoxList.count
        }
    }
    
    func getPostalOffice(index: Int) -> LOCPostalOffice? {
        switch selectedType {
        case .postOffice:
            return postOfficeList[index]
        case .depot:
            return depotList[index]
        case .retrieve:
            return retreiveList[index]
        case .postBox:
            return nil
        }
    }
    
    func getPostalBox(index: Int) -> LOCPostBox? {
        switch selectedType {
        case .postBox:
            return postBoxList[index]
        default:
            return nil
        }
    }
    
    func getPointType(index: Int) -> String? {
        if isCellDidExist(index: index) {
            switch selectedType {
            case .postOffice:
                return postOfficeList[index].type
            case .depot:
                return depotList[index].type
            case .retrieve:
                return retreiveList[index].type
            case .postBox:
                return "Box"
            }
        } else {
            return "BUREAU DE POSTE"
        }
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
            return "BOÎTE À LETTRES"
        default:
            return "BUREAU DE POSTE"
        }
    }
    
    func getPointName(index: Int) -> String {
        if isCellDidExist(index: index) {
            switch selectedType {
            case .postOffice:
                return postOfficeList[index].name
            case .depot:
                return depotList[index].name
            case .retrieve:
                return retreiveList[index].name
            case .postBox:
                return "Boîte à lettres"
            }
        } else {
            return ""
        }
    }
    
    func getPointStreet(index: Int) -> String {
        if isCellDidExist(index: index) {
            switch selectedType {
            case .postOffice:
                return postOfficeList[index].adresse
            case .depot:
                return depotList[index].adresse
            case .retrieve:
                return retreiveList[index].adresse
            case .postBox:
                return postBoxList[index].va_no_voie + " " + postBoxList[index].lb_voie_ext
            }
        } else {
            return ""
        }
    }
    
    func getPointTown(index: Int) -> String {
        if isCellDidExist(index: index) {
            switch selectedType {
            case .postOffice:
                return postOfficeList[index].codePostal + " " + postOfficeList[index].localite
            case .depot:
                return depotList[index].codePostal + " " + depotList[index].localite
            case .retrieve:
                return retreiveList[index].codePostal + " " + retreiveList[index].localite
            case .postBox:
                return postBoxList[index].co_postal + " " + postBoxList[index].lb_com
            }
        } else {
            return ""
        }
    }
    
    func getPointStatus(index: Int) -> String {
        if isCellDidExist(index: index) {
            switch selectedType {
            case .postOffice:
                return postOfficeList[index].statut.statut
            case .depot:
                return depotList[index].statut.statut
            case .retrieve:
                return retreiveList[index].statut.statut
            case .postBox:
                return "OUVERT"
            }
        } else {
            return ""
        }
    }
    
    func getDsiponibility(index: Int) -> Bool {
        if isCellDidExist(index: index) {
            switch selectedType {
            case .postOffice:
                return postOfficeList[index].statut.statut.lowercased() == "ouvert"
            case .depot:
                return depotList[index].statut.statut.lowercased() == "ouvert"
            case .retrieve:
                return retreiveList[index].statut.statut.lowercased() == "ouvert"
            case .postBox:
                return true
            }
        } else {
            return false
        }
    }
    
    func isCellDidExist(index: Int) -> Bool {
        switch selectedType {
        case .postOffice:
            return index < postOfficeList.count
        case .depot:
            return index < depotList.count
        case .retrieve:
            return index < retreiveList.count
        case .postBox:
            return index < postBoxList.count
        }
    }
    
    func retrievePointTypeFilter(value: String) -> Int {
        if value.elementsEqual("") {
            return 0
        } else if value.elementsEqual("office") {
            return 1
        } else {
            return 2
        }
    }
    
    func retrieveDayFilter(value: String) -> Int {
        if value.elementsEqual("") {
            return 0
        } else {
            return (Int(value) ?? 0)
        }
    }
    
    func retrieveHourFilter(value: String) -> Int {
        if value.elementsEqual("") {
            return 0
        } else {
            return (Int(value) ?? 0) + 1
        }
    }
    
    func setHourFilterIndex(with filterValue: String) {
        hourSelectedValue = retrieveHourFilter(value: filterValue)
    }
    
    func setDayFilterIndex(with filterValue: String) {
        daySeletedValue = retrieveDayFilter(value: filterValue)
    }
    
    func setPointTypeFilterIndex(with filterValue: String) {
        pointTypeSelectedValue = retrievePointTypeFilter(value: filterValue)
    }
    
    func isResultFiltred() -> Bool {
        if hourSelectedValue == 0, daySeletedValue == 0, pointTypeSelectedValue == 0 {
            return false
        } else {
            return true
        }
    }
    
    func hideOpenTimeIndication() -> Bool {
        if selectedType == .postBox {
            return true
        }
        return false
    }
    
    func showItinerairy(postalOfficeCoordinate: CLLocationCoordinate2D, addressDict: [String: Any], routeString: String) -> UIAlertController {
        let position = "\(postalOfficeCoordinate.latitude),\(postalOfficeCoordinate.longitude)"
        let alertController = UIAlertController(title: "Itinéraire", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: { _ in
        })
        let openPlansAction = UIAlertAction(title: "Ouvrir Plans", style: .default, handler: { _ in
            let placeMark = MKPlacemark(coordinate: postalOfficeCoordinate, addressDictionary: addressDict)
            let destination = MKMapItem(placemark: placeMark)
            if destination.responds(to: #selector(MKMapItem.openInMaps(launchOptions:))) {
                destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            } else {
                let currentLocation = "Current%20Location"
                let routeString = "\("http://maps.apple.com/maps/")saddr=\(currentLocation)&daddr=\(position)"
                if let aString = URL(string: routeString) {
                    UIApplication.shared.open(aString, options: [:], completionHandler: nil)
                }
            }
        })
        alertController.addAction(openPlansAction)
        if let aString = URL(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(aString) {
                let openMapsAction = UIAlertAction(title: "Ouvrir Google Maps", style: .default, handler: { _ in
                    if let aString = URL(string: routeString) {
                        UIApplication.shared.open(aString, options: [:], completionHandler: nil) // openURL(aString)
                    }
                })
                alertController.addAction(openMapsAction)
            }
        }
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func typeTagWith(_ typeString: String?) -> String {
        guard let type = typeString else {
            return TaggingData.kPostOffice
        }
        switch type.lowercased() {
        case "bp":
            return TaggingData.kPostOffice
        case "a2p":
            return TaggingData.kWithdrawalPoint
        case "cdi":
            return TaggingData.kDepositPoint
        case "box":
            return TaggingData.kBal
        default:
            return TaggingData.kPostOffice
        }
    }
}

