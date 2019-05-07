//
//  SearchViewModel.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 13/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedLOC
import LPSharedMCM
import LPSharedSUIVI
import RealmSwift
import UIKit

enum SearchSourceType: Int {
    case all = 1
    case follow = 2
    case shop = 3
    case localisator = 4
    case order = 5
    
    var tagPrefix: String {
        switch self {
        case .all:
            return "accueil_"
        case .follow:
            return "suivi_"
        case .shop:
            return "boutique_"
        case .localisator:
            return "localisateur_"
        case .order:
            return "commandes_"
        }
    }
    
    var taggingN2: Int32 {
        switch self {
        case .all:
            return TaggingData.kHomeLevel
        case .follow:
            return TaggingData.kTrackingLevel
        case .shop:
            return TaggingData.kCommerceLevel
        case .localisator:
            return TaggingData.kLocaliseLevel
        case .order:
            return TaggingData.kHomeLevel
        }
    }
}

class SearchViewModel: NSObject {
    var searchType: SearchSourceType
    private var productViewModel: ProductViewModel = ProductViewModel()
    var openerViewController: UIViewController?
    weak var searchViewController: SearchViewController?
    var shipmentCachedList = [CacheShipmentTrack]()
    lazy var loaderManager = LoaderViewManager()
    
    init(type: SearchSourceType) {
        searchType = type
    }
    
    func getSearchHistory(text: String) -> [String] {
        var result = [String]()
        let realm = try! Realm()
        var predicate: NSPredicate?
        if text.isEmpty {
            if self.searchType != .all {
                predicate = NSPredicate(format: "type == \(self.searchType.rawValue)")
            }
        } else {
            if self.searchType != .all {
                predicate = NSPredicate(format: "type == \(self.searchType.rawValue) AND text BEGINSWITH '\(text)'")
            } else {
                predicate = NSPredicate(format: "text BEGINSWITH '\(text)'")
            }
        }
        var resultRealm: Results<SearchElement>
        if predicate != nil {
            resultRealm = realm.objects(SearchElement.self).filter(predicate!)
        } else {
            resultRealm = realm.objects(SearchElement.self)
        }
        let reversed = resultRealm.reversed()
        for search in reversed {
            if result.count == 5 {
                return result
            }
            result.append(search.text)
        }
        return result
    }
    
    func userDidSearchWith(text: String, onCompletion: @escaping ([SearchResult]) -> Void) {
        if text.isEmpty == false {
            saveSearchElement(text: text)
        }
        if searchType == .order {
            onCompletion([SearchResult]())
            return
        }
        
        var searchResults = [SearchResult]()
        if searchType == .all {
            loaderManager.showLoderView()
            let myGroup = DispatchGroup()
            
            // LOCALISATOR
            myGroup.enter()
            getListPostOffice(searchText: text, shortResult: true) { result in
                if !result.list.isEmpty {
                    searchResults.append(result)
                }
                myGroup.leave()
            }
            
            // PRODUCT
            myGroup.enter()
            getListProduct(searchText: text) { searchResult in
                if !searchResult.list.isEmpty {
                    searchResults.append(searchResult)
                }
                myGroup.leave()
            }
            
            // PRODUCT
            myGroup.enter()
            getListShipments(searchText: text) { searchResult in
                if !searchResult.list.isEmpty {
                    searchResults.append(searchResult)
                }
                myGroup.leave()
            }
            
            myGroup.notify(queue: DispatchQueue.main, execute: {
                // All Data Done
                // Notify VC !!!
                self.loaderManager.hideLoaderView()
                onCompletion(searchResults)
            })
        } else if searchType == .localisator {
            loaderManager.showLoderView()
            getListPostOffice(searchText: text, shortResult: false) { result in
                if !result.list.isEmpty {
                    searchResults.append(result)
                }
                self.loaderManager.hideLoaderView()
                onCompletion(searchResults)
                
                // Notify VC !!!
            }
        } else if searchType == .follow {
            loaderManager.showLoderView()
            getListShipments(searchText: text) { result in
                if !result.list.isEmpty {
                    searchResults.append(result)
                }
                self.loaderManager.hideLoaderView()
                onCompletion(searchResults)
                
                // Notify VC !!!
            }
        } else if searchType == .shop {
            onCompletion(searchResults)
        }
    }
    
    func saveSearchElement(text: String) {
        let realm = try! Realm()
        
        try! realm.write {
            if let elementToRemove = realm.objects(SearchElement.self).filter("text = '\(text)'").first {
                realm.delete(elementToRemove)
            }
            let search = SearchElement()
            search.text = text
            search.type = searchType.rawValue
            realm.add(search)
        }
    }
    
    func removeItem(text: String) {
        let realm = try! Realm()
        try! realm.write {
            if let elementToRemove = realm.objects(SearchElement.self).filter("text = '\(text)'").first {
                realm.delete(elementToRemove)
            }
        }
    }
    
    // MARK: - Track
    
    func fetchAllShipments() {
        let realm = try! Realm()
        shipmentCachedList = [CacheShipmentTrack]()
        let shipments = realm.objects(CacheShipmentTrack.self)
        for shipment in shipments {
            shipmentCachedList.append(shipment)
        }
    }
    
    func getListShipments(searchText: String, onCompletion: @escaping (SearchResult) -> Void) {
        fetchAllShipments()
        var needToSearchNumber = true
        var resultCells = [UITableViewCell]()
        for shipment in shipmentCachedList {
            if shipment.code?.lowercased().contains(searchText.lowercased()) == true {
                if let cell = SearchShipmentCell.configureCellWith(shipment: shipment) {
                    resultCells.append(cell)
                }
            }
            if shipment.code?.lowercased() == searchText.lowercased() {
                needToSearchNumber = false
            }
        }
        if needToSearchNumber == true {
            TrackManager.shared.setHost("https://www.laposte.fr")
            TrackManager.shared.getShipmentFor(trackCode: searchText, completion: { success, responseFollow in
                if success, let shipment = responseFollow {
                    _ = CacheShipmentTrack.save(responseTrack: shipment)
                    if let cell = SearchShipmentCell.configureCellWith(shipment: shipment) {
                        resultCells.append(cell)
                    }
                }
                let result = self.getResultFollowFrom(resultCells)
                onCompletion(result)
            })
        } else {
            let result = getResultFollowFrom(resultCells)
            onCompletion(result)
        }
    }
    
    func getResultFollowFrom(_ resultCells: [UITableViewCell]) -> SearchResult {
        var result = SearchResult()
        if !resultCells.isEmpty {
            result.title = "Suivi de colis (\(resultCells.count))"
            result.list = resultCells
        }
        
        result.showAllClosure = {
            if let home = self.openerViewController as? HomeViewController {
                self.searchViewController?.dismiss(animated: true, completion: {
                    home.openSearchFollow()
                })
            }
        }
        return result
    }
    
    // MARK: - Location
    
    func getListPostOffice(searchText: String, shortResult: Bool, onCompletion: @escaping (SearchResult) -> Void) {
        let sharedManager: LOCSharedManager = (LOCSharedManager.sharedManager() as? LOCSharedManager)!
        var i = 0
        var resutCount = 0
        var postOfficeList = [LOCPostalOffice]()
        var resultCells = [UITableViewCell]()
        sharedManager.getPostOfficeList(byText: searchText, with: { result in
            if let listPostOffice = result as? [LOCPostalOffice] {
                postOfficeList = listPostOffice
            } else {
                postOfficeList = [LOCPostalOffice]()
            }
            for postOffice in postOfficeList {
                if let cell = SearchResultLocalisatorCell.configureCellWith(item: postOffice) {
                    if i < 3 || !shortResult {
                        resultCells.append(cell)
                    }
                    resutCount += 1
                    i += 1
                }
            }
            
            var result = SearchResult()
            if !resultCells.isEmpty {
                if resutCount > 1 {
                    result.title = "Bureaux de poste (\(resutCount))"
                } else {
                    result.title = "Bureau de postes (\(resutCount))"
                }
                
                if let home = self.openerViewController as? HomeViewController {
                    result.showAllClosure = {
                        self.searchViewController?.dismiss(animated: true, completion: {
                            home.openSearchLocator(str: searchText)
                        })
                    }
                }
//                result.title = "Bureau de poste (\(resultCells.count))"
                result.list = resultCells
            }
            onCompletion(result)
        })
    }
    
    // MARK: - Product
    
    func getListProduct(searchText: String, onCompletion: @escaping (SearchResult) -> Void) {
        let query = searchText
        productViewModel.reset()
        productViewModel.getProductList(query: query) { success, _ in
            if success {
                var searchResult = SearchResult()
                let count = self.productViewModel.productTotalCount
                if count > 1 {
                    searchResult.title = "Produits (\(count))"
                } else {
                    searchResult.title = "Produit (\(count))"
                }
                searchResult.list = self.generatesCells()
                
                searchResult.showAllClosure = {
                    if let home = self.openerViewController as? HomeViewController {
                        self.searchViewController?.dismiss(animated: true, completion: {
                            home.openSearch(str: searchText)
                        })
                    }
                }
                onCompletion(searchResult)
            } else {
                onCompletion(SearchResult())
            }
        }
    }
    
    func hybProductFor(index: Int, completion: @escaping (HYBProduct) -> Void) {
        if let code = self.productViewModel.productList[index].code {
            productViewModel.getProduct(withID: code, completion: completion)
        } else {
            loaderManager.hideLoaderView()
        }
    }
    
    private func generatesCells() -> [UITableViewCell] {
        var i = 0
        var cells = [UITableViewCell]()
        
        while i < 3 {
            if i <= (productViewModel.productTotalCount - 1) {
                let product = productViewModel.getProductForCell(indexOfCell: IndexPath(row: i, section: 0))
                let cell = SearchProductCell.getCell()
                cell?.delegate = searchViewController
                if cell != nil {
                    cell!.configureCellWithProduct(product: product, productViewModel: productViewModel)
                    cells.append(cell!)
                }
                i += 1
            } else {
                i = 3
            }
        }
        return cells
    }
    
    func imageFromType() -> UIImage? {
        var image = R.image.img_search_global()
        
        switch searchType {
        case .localisator:
            image = R.image.img_search_map()
        case .follow:
            image = R.image.img_search_tracking()
        case .shop:
            image = R.image.img_search_shop()
        case .order:
            image = R.image.img_serach_order()
        default:
            image = R.image.img_search_global()
        }
        
        return image
    }
}
