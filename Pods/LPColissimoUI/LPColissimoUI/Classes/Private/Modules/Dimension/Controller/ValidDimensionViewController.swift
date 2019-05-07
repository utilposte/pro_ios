//
//  ValidDimensionViewController.swift
//  AFNetworking
//
//  Created by LaPoste on 13/11/2018.
//

import UIKit
import LPColissimo
class ValidDimensionViewController: UIViewController {
    
    @IBOutlet weak var roundContainerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dimensionImageView: UIImageView!
    @IBOutlet weak var dimensionLabel: UILabel!
    
    @IBOutlet weak var dimensionDescLabel: UILabel!
    
    @IBOutlet weak var dimensionInputView: DimensionInputView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var changeButtonAction: UIButton!
    @IBOutlet weak var validateButton: RoundButton!
    
    @IBOutlet weak var validateButtonWidthConstraint: NSLayoutConstraint!
    var dimension : Dimension!
    var dimensionValue : DimensionValue!
    var isNotAllowed : Bool = false
    var error : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewController()
      
    }
    
    func desactivate(){
        changeButtonAction.isHidden = true
        validateButton.setTitle("Changer mes dimensions", for: .normal)
        validateButton.setTitle(title:"Changer mes dimensions", widthConstraints: validateButtonWidthConstraint)
        dimensionInputView.desactivate()
    }
    
    
    func setupViewController(){
        self.closeButton.setImage(ColissimoHomeServices.loadImage(name:"IconCloseWhite.png")!, for: .normal)
        self.dimensionInputView.setup(value: dimensionValue)
        self.dimensionInputView.desactivate()
        self.dimensionImageView.image = ColissimoHomeServices.loadImage(name:dimension.image)
        self.dimensionLabel.text = dimension.title
        self.dimensionDescLabel.text = dimension.help
        self.setup(title: "Votre colis est un format:\n", dimension: dimension.title)
//        validateButton.setTitle(title:"Valider", widthConstraints: validateButtonWidthConstraint)
        self.validateButton.setTitle("Valider", for: .normal)
        if  self.isNotAllowed {
            self.desactivate()
            self.dimensionDescLabel.text = error
            self.dimensionDescLabel.textColor = .red
        }
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
        let stepFont: UIFont = UIFont.systemFont(ofSize: 15.0, weight: .semibold)//Fonts.podFont(name: "Montserrat-Light", size: 12.0)
        return NSMutableAttributedString(string: string, attributes:
            [NSAttributedString.Key.font : stepFont ])
        //        UIFont(name: "Helvetica", size: 18.0)
    }
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.popToStep2()
        
    }
    
    
    func popToStep2(){
        for vc in (self.navigationController?.viewControllers)! {
            if vc is ColissimoDimensionViewController {
//                ( vc as! ColissimoDimensionViewController ).selectedDimension =  self.dimension
                ColissimoData.shared.dimension = self.dimension
                print("👀  \(#function) 👀 \(self.dimension.toString())");
                self.navigationController?.popToViewController(vc, animated: false)
            }
        }
    }
    @IBAction func validateButtonAction(_ sender: Any) {
        if isNotAllowed {
             popToHelp(shouldInit : true)
            
        }else{
           popToStep2()
        }
        
        
    }
    
    @IBAction func returnButtonAction(_ sender: Any) {
        popToHelp(shouldInit : true)
    }
    
    func popToHelp(shouldInit : Bool){
        for vc in (self.navigationController?.viewControllers)! {
            if vc is HelpDimensionViewController {
                (vc as! HelpDimensionViewController).shouldInitDimenstion = shouldInit
                self.navigationController?.popToViewController(vc, animated: false)
            }
        }
    }
}



extension UIButton {
    func setTitle(title:String,  widthConstraints: NSLayoutConstraint){
        self.setTitle(title, for: .normal)
        let textWidth = (title as NSString).size(withAttributes:[NSAttributedStringKey.font:self.titleLabel!.font!]).width
        let width = textWidth + 40
        //24 - the sum of your insets from left and right
        widthConstraints.constant = width
        self.layoutIfNeeded()
    }
}
