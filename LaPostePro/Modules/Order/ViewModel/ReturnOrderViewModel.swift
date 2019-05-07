//
//  ReturnOrderViewModel.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 19/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

class ReturnOrderViewModel {
    var detailOrder : HYBOrder
    var isClaim : Bool
    var products = [ReturnOrderModel]()
    lazy var loaderManager = LoaderViewManager()
    
    init(order : HYBOrder, isClaim : Bool) {
        self.detailOrder = order
        self.isClaim = isClaim
    }
    
    func configureData(callback:@escaping ([ReturnOrderModel]) -> ()){
        
        guard let entries = detailOrder.entries as? [HYBOrderEntry] else {
            return
        }
        
        products = [ReturnOrderModel]()
        let group = DispatchGroup()
        for entry in entries {
            
            var product = ReturnOrderModel()
            product.requestType = isClaim ? "Claim" : "Return"
            product.refLabel = "Ref : \(entry.product.code ?? "")"
            product.nameProduct = entry.product.name ?? ""
            product.detailsProduct = "" //  NO Details
            product.numcommande = detailOrder.code ?? ""
//            product.produit = detailOrder.code ?? ""
            product.entryNumber = "\(entry.entryNumber ?? 0)"
            product.maxProducts = entry.quantity as? Int ?? 1
            
            group.enter()
            OrderNetworkManager.getReasonForProduct(productId: entry.product.code ?? "", isClaim: isClaim) { (result, error) in
                if let returnProductReasons = result, let reasons = returnProductReasons.motifs {
                    product.reasons = reasons
                    if let productType = returnProductReasons.typesProduit?.first {
                        product.isPhysicalProduct = (productType == "ProduitPhysique")
                    }
                    self.products.append(product)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            callback(self.products)
            Logger.shared.debug("All getReasonForProduct requests done")
        }
    }
    
    func callClaimOrder(products : [ReturnOrderModel], callback:@escaping ([ReturnOrderModel], Bool) -> ()){
        loaderManager.showLoderView()
        let group = DispatchGroup()
        var errorProducts = [ReturnOrderModel]()
        var isSuccess = true
        for product in products {
            group.enter()
            OrderNetworkManager.postClaimForProduct(product) { (success) in
                if success == false {
                    errorProducts.append(product)
                    isSuccess = false
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.loaderManager.hideLoaderView()
            callback(errorProducts, isSuccess)
            Logger.shared.debug("All callClaimOrder requests done")
        }
    }
    
    
    // TOOLS :
    func getSuccessAttributedStringForMessageView(primaryFont : UIFont,secondaryFont  : UIFont) -> NSAttributedString {
        let titleFont = [NSAttributedStringKey.font : secondaryFont]
        let messageFont = [NSAttributedStringKey.font : primaryFont]
        
        let attributedString = NSMutableAttributedString(string:"Nous avons bien enregistré", attributes:messageFont)
        attributedString.append(NSMutableAttributedString(string:" votre demande de retour", attributes:titleFont))
        attributedString.append(NSMutableAttributedString(string:" produits. Merci.", attributes:messageFont))
        
        return attributedString
    }
    
    // TOOLS :
    func getClaimSuccessAttributedStringForMessageView(primaryFont : UIFont,secondaryFont  : UIFont) -> NSAttributedString {
        let titleFont = [NSAttributedStringKey.font : secondaryFont]
        let messageFont = [NSAttributedStringKey.font : primaryFont]
        
        let attributedString = NSMutableAttributedString(string:"Nous reviendrons vers vous ", attributes:messageFont)
        attributedString.append(NSMutableAttributedString(string:"sous 48h dans votre boîte mail.", attributes:titleFont))
        attributedString.append(NSMutableAttributedString(string:" Merci de votre confiance.", attributes:messageFont))
        
        return attributedString
    }
    
    
    
    
    func validatePorduct(_ product : ReturnOrderModel) -> ReturnOrderModel? {
        var resultProduct = product
        if product.isSelected == false {
            return nil
        }
        // check Description
        if product.description == "" {
            return nil
        }
        // Check Reason
        if let reason = product.currentReason {
            // check sub Reason
            if let subReasons = reason.sousMotifs {
                // Check number Of subReasons
                if subReasons.count == 1 {
                    //
                    let subReason = subReasons[0]
                    resultProduct.source  = reason.codeSource ?? ""
                    resultProduct.famille = subReason.famille ?? ""
                    resultProduct.motif   = reason.codeMotifScore ?? ""
                    resultProduct.sousmotif = subReason.codeMotifScore ?? ""
                    resultProduct.produit = reason.codeProduitScore ?? ""
                } else if subReasons.count > 1 {
                    //
                    if let subReason = product.currentSubReason {
                        resultProduct.source  = reason.codeSource ?? ""
                        resultProduct.famille = subReason.famille ?? ""
                        resultProduct.motif   = reason.codeMotifScore ?? ""
                        resultProduct.sousmotif = subReason.codeMotifScore ?? ""
                        resultProduct.produit = reason.codeProduitScore ?? ""
                    } else {
                        return nil
                    }
                } else {
                    // Problem withSubreason :: put reason for sucrity (Shoud never enter this closure)
                    resultProduct.source    = reason.codeSource ?? ""
                    resultProduct.famille   = reason.famille ?? ""
                    resultProduct.motif     = reason.codeMotifScore ?? ""
                    resultProduct.produit   = reason.codeProduitScore ?? ""
                }
            } else {
                // No SubReason
                resultProduct.source    = reason.codeSource ?? ""
                resultProduct.famille   = reason.famille ?? ""
                resultProduct.motif     = reason.codeMotifScore ?? ""
                resultProduct.produit   = reason.codeProduitScore ?? ""
            }
        } else {
            return nil
        }
        return resultProduct
    }
}
