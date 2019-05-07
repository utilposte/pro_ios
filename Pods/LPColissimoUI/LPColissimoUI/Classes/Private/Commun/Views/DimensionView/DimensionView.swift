//
//  DimensionView.swift
//  LPColissimoUI
//
//  Created by Khaled El Abed on 17/10/2018.
//  Copyright © 2018 Khaled El Abed. All rights reserved.
//

import UIKit
public extension Double{
    func formatPrice()->String{
        return String(format:"%.2f", self)
    }
}

@IBDesignable class DimensionView: UIView {
    var contentView:UIView?
    var dimension : Dimension = .standard{
        didSet{
            self.titleLabel.text = dimension.title
            self.descriptionLabel.text = dimension.description
            self.boxImageView.image = ColissimoHomeServices.loadImage(name:dimension.image)
        }
    }
    
    var onClickListner : ()->Void = {()-> Void in}
    
    @IBInspectable var nibName:String?
    @IBInspectable var imageNamed: String = "ic_volumineux_help_size"{
        didSet{
            self.boxImageView.image = ColissimoHomeServices.loadImage(name:imageNamed)
        }
    }
    
    @IBInspectable var isSelected : Bool = false{
        didSet{
            titleLabel.textColor = isSelected ? UIColor.orange : UIColor.black
            descriptionLabel.textColor = isSelected ?  UIColor.black : UIColor.lightGray
        }
    }
    
    @IBInspectable var dimensionTitle:String = "Standard"{
        didSet{
            titleLabel.text = dimensionTitle
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var boxImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    @IBAction func tapped(_ sender: Any) {
        self.onClickListner()
    }
    
    public func setOnClickListner(completion: (_ result: Bool)->()) {
        completion(true)
    }
    
    
    func desactivate(){
        titleLabel?.alpha = 0.5
        descriptionLabel?.alpha = 0.5
        boxImageView?.alpha = 0.5
    }
    
    func setpPrice(){
        if let cost = dimension.format.additionalCost {
            let currencySymbol = getSymbolForCurrencyCode(code: cost.currencyIso!)
            let price = (cost.value!).formatPrice()
            self.titleLabel.text = dimension.title + " (+\(price)" + "\(currencySymbol))"
        }
       
    }
    
    func getSymbolForCurrencyCode(code: String) -> String {
        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        for localeID in locales {
            guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
                continue
            }
            if symbol.count == 1 {
                return symbol
            }
            candidates.append(symbol)
        }
        let sorted = sortAscByLength(list: candidates)
        if sorted.count < 1 {
            return ""
        }
        return sorted[0]
    }
    
    func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID as String)
        guard let code = locale.currencyCode else {
            return nil
        }
        if code != currencyCode {
            return nil
        }
        guard let symbol = locale.currencySymbol else {
            return nil
        }
        return symbol
    }
    
    func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
    
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let nib = UINib(nibName: nibName, bundle: bundle)
                return nib.instantiate(
                    withOwner: self,
                    options: nil).first as? UIView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
}
