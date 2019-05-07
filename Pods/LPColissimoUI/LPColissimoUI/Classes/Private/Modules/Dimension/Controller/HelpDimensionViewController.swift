//
//  HelpDimensionViewController.swift
//  LPColissimoUI
//
//  Created by LaPoste on 05/11/2018.
//  Copyright © 2018 LaPoste. All rights reserved.
//

import UIKit
import LPColissimo

class HelpDimensionViewController: UIViewController {

    @IBOutlet weak var customInputView: DimensionInputView!
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var roundButton: RoundButton!
    @IBOutlet weak var closeButton: UIButton!
   
    var departureCountry: CLCountry?
    var isValidCountry : Bool = true
    public var arrivalCountry: CLCountry?{
        didSet{
            self.isValidCountry = arrivalCountry!.isocode != "be"
        }
    }
    
    public  var formats : [ConvertedFormat]  = [ConvertedFormat]()
    
    var validateText : String = "Valider"
    var colisFormat :  [CLFormat]!
    var dimensionValue : DimensionValue = DimensionValue()
    var shouldInitDimenstion : Bool  =  false {
        didSet{
            if shouldInitDimenstion {
                self.dimensionValue =  DimensionValue()
                self.dimensionValue.toString()
                customInputView.setup(value: dimensionValue)
                customInputView.reinit()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
    }
    
    func setup(){
        self.closeButton.setImage(ColissimoHomeServices.loadImage(name:"IconCloseWhite.png")!, for: .normal)
        
        print("👀  \(#function) 👀\(String(describing: arrivalCountry!.isocode))");
        print("👀  \(#function) 👀isValidCountry  : \( isValidCountry)");
        self.colisFormat = ColissimoManager.sharedManager.initData?.colisFormats
        //roundButton.backgroundColor =  UIColor.lpGreen
        roundButton.isHidden = true
        headerImageView.image = ColissimoHomeServices.loadImage(name:"illus_colis-dimension")!
//        headerImageView.image = headerImageView.image!.withRenderingMode(.alwaysTemplate)
//        headerImageView.tintColor = UIColor.white
        
        customInputView.onDidBeginEditing = {(dimension) in
            self.footerLabel.isHidden =  true
            self.roundButton.isHidden =  false
            self.dimensionValue = dimension
        }
        
        self.footerLabel.text = "La dimension minimale de votre colis doit permettre d'apposer la liasse de transport. Les dimensions maximales sont telles que la somme de la longueur (L), largeur (l) et hauteur (H) ne dépasse pas 200 cm ou que la longueur (L) ne dépasse pas 150 cm. \n\nSi votre colis a une forme cylindrique, veuillez sélectionner le format Tube."
        roundButton.setTitle(validateText, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kFormatSaisie,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: TaggingData.kChapter3,
                                                             level2: TaggingData.kColissimoLevel)
        
        self.customInputView.hideError()
        roundButton.setTitle("Valider", for: .normal)
    }
    
    override public func viewDidLayoutSubviews() {
        customInputView.layoutSubviews()
    }
  
    @IBAction func nextAction(_ sender: Any) {
        if self.customInputView.validateInput(){
            self.customInputView.showError()
            self.roundButton.setTitle("Recalculer", for: .normal)
            self.view.layoutIfNeeded()
            return
        }
        let result  = self.calculateDimension(dimension: dimensionValue)
        if let error : String = result.1 {
            self.notAuthorizedPush(dimensionValue: self.dimensionValue,error: error,dimension: nil)
            return
        }
        
        if let dimension = result.0 {
            if isValidCountry {
                self.validPush(dimension: dimension, dimensionValue: self.dimensionValue)
            }else if dimension == .big && !isValidCountry{
                self.unsuppoertedCountry(dimensionValue: self.dimensionValue,error: "Votre colis ne peut être pris en charge, car le pays de destination n'accepte pas ces dimensions.",dimension: dimension)
                //self.unsuppoertedCountry(dimensionValue:self.dimensionValue,error: "Votre colis ne peut être pris en charge.")
            }else{
                self.validPush(dimension: dimension, dimensionValue: self.dimensionValue)
            }
        }
        
       
    }
    func unsuppoertedCountry(dimensionValue:DimensionValue, error : String,dimension: Dimension){

        if let vc : ValidDimensionViewController = ColissimoManager.sharedManager.getValidViewController() as? ValidDimensionViewController{
            vc.dimension = dimension
            vc.dimensionValue =  dimensionValue
            vc.error = error
            vc.isNotAllowed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func validPush(dimension : Dimension,dimensionValue:DimensionValue){
        if let vc : ValidDimensionViewController = ColissimoManager.sharedManager.getValidViewController() as? ValidDimensionViewController{
            vc.dimension = dimension
            vc.dimensionValue =  dimensionValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func notAuthorizedPush(dimensionValue:DimensionValue, error : String, dimension :Dimension?){
        if let vc : InvalidDimensionViewController = ColissimoManager.sharedManager.getInvalidViewController() as? InvalidDimensionViewController{
            vc.dimensionValue =  dimensionValue
            if let dimension = dimension {
                vc.dimension = dimension
            }
            vc.errorMessage = error
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func desactivateddPush(){
        if let vc : InvalidDimensionViewController = ColissimoManager.sharedManager.getValidViewController() as? InvalidDimensionViewController{
            vc.dimensionValue =  dimensionValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func calculateDimension(dimension : DimensionValue)->(Dimension?, String?){
     
        for format in colisFormat {
            let c : ConvertedFormat =  ConvertedFormat(format: format)
            formats.append(c)
        }
        
        let volumineux = self.formats.filter({ format -> Bool in
            return format.type == "VOLUMINEUX"//country.isocode! == isoDeparture
        }).first!
        let standard = self.formats.filter({ format -> Bool in
            return format.type == "STANDARD"
        }).first!
        let tube = self.formats.filter({ format -> Bool in
            return format.type == "ROULEAU"
        }).first!
        
        
        let LLH : Int = dimension.hauteur+dimension.largeur+dimension.longueur
        let error200 = " Votre colis ne peut être pris en charge, car la somme de la longueur (L), largeur (l) et hauteur(h) est supérieur à 200 cm."
        let errorPay =  "Votre colis ne peut être pris en charge, car le pays de destination n'accepte pas ces dimensions."
        
        
        if LLH > volumineux.LLHMax! {
            print("👀  \(#function) 👀| Error >200");
            return (nil,error200)
        }
        print("👀 \(volumineux.LLHMin!) | \( volumineux.LLHMin! <= LLH ) <   \(LLH) 👀< | \(volumineux.LLHMax!) | \(LLH <= volumineux.LLHMax!) ");
        let standardHeightMax = standard.heightMax!
        let isLessThanStandardHeight = (dimension.hauteur <= standardHeightMax && dimension.largeur <= standardHeightMax && dimension.longueur <= standardHeightMax)
        let isGreaterThanStandard = (dimension.hauteur > standardHeightMax || dimension.largeur > standardHeightMax || dimension.longueur > standardHeightMax)
        print("👀  \(#function) 👀isGreaterThan \(isGreaterThanStandard)");
        print("👀  \(#function) 👀isLessThanStandardHeight \(isLessThanStandardHeight)");

        if LLH <= standard.LLHMax! && isLessThanStandardHeight {
            print("👀  \(#function) 👀 : STANDARD");
            return (Dimension(rawValue: 0),nil)
        }else if volumineux.LLHMin! < LLH && LLH <= volumineux.LLHMax! || isGreaterThanStandard {
            print("👀  \(#function) 👀 : VOLUMINEUX");
            return (Dimension(rawValue: 1),nil)
        }else{
            print("👀  \(#function) 👀|\(volumineux.LLHMin!) <Error <\(volumineux.LLHMax!)");
            return (nil,errorPay)
        }

    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
    
    }
    
}




