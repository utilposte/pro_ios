//
//  InputFormView.swift
//  LPColissimoUI
//
//  Created by LaPoste on 22/11/2018.
//

import UIKit

@IBDesignable class InputFormView: UIView {
    var contentView:UIView?
    var onDidBeginEditing : (Int)->Void = {(Int)-> Void in}
    let  nibName:String = "InputFormView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        
//        configure()
    }
    
    func loadViewFromNib() -> UIView? {
//        guard let nibName = nibName else { return nil }
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
    
    override func layoutSubviews() {
        //            roundCorner()
    }

}
