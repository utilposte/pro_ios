//
//  InvalidDimensionViewController.swift
//  AFNetworking
//
//  Created by LaPoste on 14/11/2018.
//

import UIKit

class InvalidDimensionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dimensionInputView: DimensionInputView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var changeButton: RoundButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var dimensionValue : DimensionValue!
    var dimension : Dimension!
    var isInvalidCountry : Bool = false{
        didSet{
           
        }
    }
    var errorMessage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Quel format choisir ?"
        if dimension != nil {
            setup(title: "Votre colis est un format:\n", dimension: dimension.title)
        }
        self.closeButton.setImage(ColissimoHomeServices.loadImage(name:"IconCloseWhite.png")!, for: .normal)
        dimensionInputView.setup(value: dimensionValue)
        dimensionInputView.desactivate()
        self.changeButton.setTitle("Changer mes dimensions", for: .normal)
        
        descriptionLabel.text = errorMessage
        if isInvalidCountry {
             changeButton.isHidden = isInvalidCountry
        }
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kFormatResultat,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: TaggingData.kChapter3,
                                                             level2: TaggingData.kColissimoLevel)
    }
    
    func setup(title : String,dimension: String){
        let attributedString :NSMutableAttributedString = customizeTitle(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.alignment = NSTextAlignment.center
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        attributedString.append(customizeDimension(string: dimension))
        
        titleLabel.attributedText = attributedString
        
    }
    
    func customizeTitle(string : String)-> NSMutableAttributedString{
        let titleFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        return NSMutableAttributedString(string: string, attributes:
            [NSAttributedString.Key.font : titleFont ])
    }
    
    func customizeDimension(string : String)-> NSMutableAttributedString{
        let stepFont: UIFont = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        return NSMutableAttributedString(string: string, attributes:
            [NSAttributedString.Key.font : stepFont ])
    }
    
    @IBAction func changeButtonAction(_ sender: Any) {
        self.popToHelp(shouldInit: true)
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        popToStep2()
    }
    
    func popToHelp(shouldInit : Bool){
        for vc in (self.navigationController?.viewControllers)! {
            if vc is HelpDimensionViewController {
                (vc as! HelpDimensionViewController).shouldInitDimenstion = shouldInit
                self.navigationController?.popToViewController(vc, animated: false)
            }
        }
    }
    
    func popToStep2(){
        for vc in (self.navigationController?.viewControllers)! {
            if vc is ColissimoDimensionViewController {
                
                self.navigationController?.popToViewController(vc, animated: false)
            }
        }
    }
}
