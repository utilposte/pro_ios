//
//  CLHeaderView.swift
//  LPColissimoUI
//
//  Created by LaPoste on 17/10/2018.
//  Copyright © 2018 Khaled El Abed. All rights reserved.
//

import UIKit

@IBDesignable class CLHeaderView: UIView {

    var gradientLayer: CAGradientLayer!


    var contentView:UIView?
    @IBInspectable var nibName:String = "CLHeaderView"
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        createGradientLayer(view: view)
        
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
        gradientLayer.frame = contentView!.bounds
    }
    
    
    func createGradientLayer( view : UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.lpGradientRed.cgColor, UIColor.lpGradientYellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    

    func setup(title : String, icon:String,step: Int?){
        let attributedString :NSMutableAttributedString
        if( step != nil){
            attributedString  = customizeStep(string: "\(String(describing: step!))/6\n")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            attributedString.append(customizeTitle(string: title))
        }else{
            attributedString  = customizeTitle(string: title)
        }
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        
        if let image : UIImage = ColissimoHomeServices.loadImage(name:icon) {
            headerImageView.image =  image//UIImage(named: icon)
            headerImageView.image = image.withRenderingMode(.alwaysTemplate)
            headerImageView.tintColor = UIColor.white
        }
    }
    
    func customizeTitle(string : String)-> NSMutableAttributedString{
        let titleFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        return NSMutableAttributedString(string: string, attributes:
            [NSAttributedString.Key.font : titleFont ])
    }
    
    func customizeStep(string : String)-> NSMutableAttributedString{
        let stepFont: UIFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)//Fonts.podFont(name: "Montserrat-Light", size: 12.0)
        return NSMutableAttributedString(string: string, attributes:
            [NSAttributedString.Key.font : stepFont ])
//        UIFont(name: "Helvetica", size: 18.0)
    }
}
