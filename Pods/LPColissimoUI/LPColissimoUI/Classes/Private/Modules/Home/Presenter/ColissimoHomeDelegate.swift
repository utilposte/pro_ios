//
//  ColissimoHomeDelegate.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 18/10/2018.
//

import UIKit

protocol ColissimoHomeDelegate: class {
    func setPageViewCollectionImages(images: [UIImage])
    func setGuideS(guides : [HomeGuideViewModel])
    func setGuideCells(cells : [UITableViewCell])
    func setAdvantageCells(cells : [UITableViewCell])
    func setUpDefaultValues()
    func showErrorView(_ text:String)
    
    // PickerView
    func dismissPickerView()
    func setArrivalCountry(country: String)
    func setDepartureCountry(country: String)
    func priceDidChange(price : String)
    
}
