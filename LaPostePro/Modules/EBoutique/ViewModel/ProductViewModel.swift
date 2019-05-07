//
//  ProductViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 24/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM
import Alamofire
import AlamofireImage

class ProductViewModel: NSObject {
    // MARK: product list
    var productList = [HYBProduct]()

    var allProductsLoaded = false
    var calledOnce = false
    var productTotalCount = 0
    let hybServiceWrapper = (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper)

    override init() {
        hybServiceWrapper.backEndService.resetPagination()
    }
    
    func reset() {
        self.calledOnce = false
        self.allProductsLoaded = false
        self.productList = [HYBProduct]()
        self.hybServiceWrapper.backEndService.resetPagination()
    }
    

    func getProductList(query: String, completion: (@escaping (Bool, [HYBSort]?) -> Void)) {
        if (self.allProductsLoaded) {
            self.hybServiceWrapper.backEndService.resetPagination()
        } else {
            if !calledOnce {
                self.calledOnce = true
                (MCMProductManager.sharedManager() as! MCMProductManager).getProductsAndDetails(byQuery: query) { (productList, _, error, productsTotalCount, facets, sorts) in
                    

//                    Logger.shared.debug("PRODUCT TOTAL COUNT ============== \(productsTotalCount)")
                    if productsTotalCount == 20 {
                        self.allProductsLoaded = true
                    }
                    //test if no response
                    if self.hybServiceWrapper.backEndService.currentPage == 0 && productList != nil && (productList?.isEmpty)! {
                        // TODOs: Problems
                    } else if self.hybServiceWrapper.backEndService.currentPage > 0 && productList != nil && (productList?.isEmpty)! {
                        self.allProductsLoaded = true
                        //completion(false, nil)
                    } else if productList != nil && (productList?.count)! < Int(self.hybServiceWrapper.backEndService.pageSize) {
                        self.allProductsLoaded = true
                        self.productTotalCount = productsTotalCount?.intValue ?? 0
                        //completion(true, sorts as? [HYBSort])
                    }
                    if error != nil && productList == nil {
                        completion(false, nil)
                    } else {
                        self.hybServiceWrapper.backEndService.nextPage()
                        self.productList.append(contentsOf: (productList as! [HYBProduct]))
                        
                        // get sorts
                    
                        // SAVE FACETS IN SINGLETON
                        if let facets = facets, CurrentFacet.shared.conditions.isEmpty {
                            var sectionItemsTemp = [ConditionChoice]()
                            _ = (facets as! [HYBFacet]).map({ facet in
                                _ = facet.values.map({ value in
                                    let listValue = value as! [HYBFacetValue]
                                    for v in listValue
                                    {
                                        sectionItemsTemp.append(ConditionChoice(choiceName: v.name, isChecked: false))
                                    }
                                })
                                CurrentFacet.shared.conditions.append(Condition(categoryName: facet.name, choices: sectionItemsTemp))
                                sectionItemsTemp = []
                            })

                            if CurrentFacet.shared.conditions.contains(where: { condition -> Bool in
                                condition.categoryName == "listThematiques"
                            }) {
                                let indexThematique = CurrentFacet.shared.conditions.index { condition -> Bool in
                                    condition.categoryName == "listThematiques"
                                }

                                if let index = indexThematique {
                                    let conditionTmp = CurrentFacet.shared.conditions[index]
                                    CurrentFacet.shared.conditions.remove(at: index)
                                    CurrentFacet.shared.conditions.append(conditionTmp)
                                }
                            }

                        }
//                        self.allProductsLoaded = true
                        self.productTotalCount = (productsTotalCount?.intValue)!
                        completion(true, sorts as? [HYBSort])
                    }
                    self.calledOnce = false
                }
            }
        }
    }

    func getProductListWithFilter(filter: String, nextPageEnabled: Bool, completion: (@escaping (Bool, [HYBSort]?) -> Void)) {
        (MCMProductManager.sharedManager() as! MCMProductManager).getProductsAndDetails(byQuery: filter) { (productList, _, error, productsTotalCount, facets, sorts) in
            //test if no response
            if self.hybServiceWrapper.backEndService.currentPage == 0 && productList != nil && (productList?.isEmpty)! {
                // TODOs: Problems
            } else if self.hybServiceWrapper.backEndService.currentPage > 0 && productList != nil && (productList?.isEmpty)! {
                self.allProductsLoaded = true
                completion(false, nil)
                return
            } else if productList != nil && (productList?.count)! < Int(self.hybServiceWrapper.backEndService.pageSize) {
                self.allProductsLoaded = true
                self.productTotalCount = productsTotalCount?.intValue ?? 0
                CurrentFacet.shared.filterValue = self.getProductTotalCountFormattedForFilter()
                completion(true, sorts as? [HYBSort])
                return
            }
            if error != nil && productList == nil {
                completion(false, nil)
                return
            } else {
                if nextPageEnabled {
                    self.hybServiceWrapper.backEndService.nextPage()
                }
                self.productList.append(contentsOf: (productList as! [HYBProduct]))
                // SAVE FACETS IN SINGLETON
                if let facets = facets, CurrentFacet.shared.conditions.isEmpty {
                    CurrentFacet.shared.conditions = []
                    var sectionItemsTemp = [ConditionChoice]()
                    _ = (facets as! [HYBFacet]).map({ facet in
                        _ = facet.values.map({ value in
                            let myValue = value as! HYBFacetValue
                            sectionItemsTemp.append(ConditionChoice(choiceName: myValue.name, isChecked: false))
                        })
                        CurrentFacet.shared.conditions.append(Condition(categoryName: facet.name, choices: sectionItemsTemp))
                        sectionItemsTemp = []
                    })

                    if CurrentFacet.shared.conditions.contains(where: { condition -> Bool in
                        condition.categoryName == "listThematiques"
                    }) {
                        let indexThematique = CurrentFacet.shared.conditions.index { condition -> Bool in
                            condition.categoryName == "listThematiques"
                        }

                        if let index = indexThematique {
                            let conditionTmp = CurrentFacet.shared.conditions[index]
                            CurrentFacet.shared.conditions.remove(at: index)
                            CurrentFacet.shared.conditions.append(conditionTmp)
                        }
                    }
                }
                self.productTotalCount = (productsTotalCount?.intValue)!
                CurrentFacet.shared.filterValue = self.getProductTotalCountFormattedForFilter()
                completion(true, sorts as? [HYBSort])
                return
            }
        }
    }

    func getProductTotalCount() -> String {
        return R.string.localizable.product_total_number(self.productTotalCount)
    }

    func getProductTotalCountFormattedForFilter() -> String {
        if self.productTotalCount == 0 {
            return R.string.localizable.product_total_filter_empty()
        } else if self.productTotalCount == 1 {
            return R.string.localizable.product_total_number_filter_one()
        } else if self.productTotalCount > 1 {
            return R.string.localizable.product_total_number_filter(self.productTotalCount)
        } else {
            return R.string.localizable.product_total_filter_empty()
        }
    }

    func getProductForCell(indexOfCell: IndexPath) -> Product {
        if indexOfCell.row >= productList.count {
            return Product()
        }
        return Product.init(hybProduct: productList[indexOfCell.row])
    }

    func getPriceText(for contentType: ContentType, product: Product) -> NSMutableAttributedString {
        let priceType = (product.priceType?.elementsEqual("BUY"))! ? "Prix Unitaire Net" : "Prix Unitaire HT"
        switch contentType {
        case .favoritesList:
            return NSMutableAttributedString()
                .custom(String(format: "%@ ", product.price2!), font: UIFont.init(size: 15), color: .lpPurple)
                .custom(priceType, font: UIFont.systemFont(ofSize: 13), color: .lpGrey)
        default:
            return NSMutableAttributedString()
                .custom(String(format: "%@\n", product.price2!), font: UIFont.init(size: 15), color: .lpPurple)
                .custom(priceType, font: UIFont.systemFont(ofSize: 13), color: .lpGrey)
        }
    }

    func loadProductImageView(url: String, completion:@escaping (UIImage) -> Void) {

        (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper).backEndService.loadImage(byUrl: url) { (image, error) in
            if error == nil {
                completion(image!)
            } else {
                completion(R.image.beauxTimbres()!)
            }
        }
    }

    func getPromotionCause(product: Product) -> NSMutableAttributedString {
        return NSMutableAttributedString()
            .custom("Vous avez acheté ", font: UIFont.systemFont(ofSize: 13), color: .lpGrey)
            .custom(String(format: "%@", product.name!), font: UIFont.init(size: 15), color: .lpPurple)
    }

    func getProduct(withID productID: String, completion: @escaping(HYBProduct) -> Void) {
        (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper).backEndService.getProductForCode(productID) { (product, error) in
            if error != nil {
                //completion(product as! HYBProduct)
            } else {
                completion(product as! HYBProduct)
            }
        }
    }

    func resetToApplyFilter() {
        self.allProductsLoaded = false
        self.productList.removeAll()
        self.hybServiceWrapper.backEndService.resetPagination()
    }
    
    func getFormatted(sorts: [HYBSort]) -> [HYBSort] {
        var formattedSorts = [HYBSort]()
        for sort in sorts {
            switch sort.code {
            case "relevance":
                sort.name = "Pertinence"
                formattedSorts.append(sort)
            case "nombreCommandes-desc":
                sort.name = "Meilleures ventes"
                formattedSorts.insert(sort, at: 1)
            case "price-asc":
                sort.name = "Prix croissant"
                formattedSorts.append(sort)
            case "price-desc":
                sort.name = "Prix décroissant"
                formattedSorts.append(sort)
            case "dateEmissionLegale-desc":
                sort.name = "Nouveautés"
                formattedSorts.append(sort)
            case "name-asc":
                sort.name = "Noms de A-Z"
                formattedSorts.append(sort)
            case "name-desc":
                sort.name = "Noms de Z-A"
                formattedSorts.append(sort)
            default:
                break
            }
        }
        return formattedSorts
    }
    
}
