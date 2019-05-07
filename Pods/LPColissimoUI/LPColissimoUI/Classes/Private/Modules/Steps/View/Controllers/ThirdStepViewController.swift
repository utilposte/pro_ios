//
//  ThirdStepViewController.swift
//  Alamofire
//
//  Created by Yonael Tordjman on 05/11/2018.
//

import UIKit
import LPColissimo

public class ThirdStepViewController: UIViewController {
    
    @IBOutlet weak var stepView: CLHeaderView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var floatingView: FloatingView!
    @IBOutlet weak var gauge: ReusableGauge!
    @IBOutlet weak var gramTextField: UITextField!
    @IBOutlet weak var gramLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var footerContainerView: UIView!
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    
    var maxValue = 30
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        if let selectedReceiverAddress = ColissimoData.shared.selectedReceiverAddress {
            self.maxValue = Int(selectedReceiverAddress.poidsmax)
        }
        self.gauge.maxValue = self.maxValue * 1000
        self.gauge.delegate = self
        self.gauge.backgroundColor = .clear
        
        self.gauge.setNeedsDisplay()
        self.floatingView.progress = 0.4
        floatingView.animate()
        if let price = ColissimoData.shared.price, let weight = ColissimoData.shared.weight {
            self.floatingView.price = price
            self.floatingView.productImageNamed = ColissimoData.shared.dimension.image
            self.setGaugeKg(value: weight)
        }
        
        self.setupGramTextField()
        self.setupGramLabel()
        self.setupInfoLabel()
        self.setupNextStepButton()
        self.setupStepView()
        self.setFooterView()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE3Poids,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
    }
    
    override public func viewDidLayoutSubviews() {
        self.floatingView.layoutSubviews()
    }
    
    // MARK: Setup Views
    func setFooterView() {
        if let footer = ColissimoManager.sharedManager.delegate?.getFooterView() {
            footerHeightConstraint.constant = footer.bounds.height
            footerContainerView.addSubview(footer)
        }
    }
    
    private func setupStepView() {
        self.stepView.setup(title: "Poids de votre colis", icon:"ic_step_3.png",step: 3)
    }
    
    private func setupNextStepButton() {
        self.nextStepButton.backgroundColor = UIColor.lpGreen
        self.nextStepButton.setTitle("SUIVANT", for: .normal)
        self.nextStepButton.setTitleColor(.white, for: .normal)
        self.nextStepButton.layer.cornerRadius = self.nextStepButton.frame.height / 2
    }
    
    private func setupInfoLabel() {
        self.infoLabel.textAlignment = .center
        self.infoLabel.text = "Ajustez ou saisissez le poids de votre colis (max \(self.maxValue) kg)"
        self.infoLabel.numberOfLines = 0
        self.infoLabel.font = UIFont.systemFont(ofSize: 12)
        self.infoLabel.textColor = UIColor.init(red: 164/255, green: 171/255, blue: 176/255, alpha: 1)
    }
    
    private func setupGramLabel() {
        if let weight = ColissimoData.shared.weight {
            let cleanString = (weight * 1000).cleanString
            self.gramLabel.text = "Soit \(cleanString) g"
        }
        self.gramLabel.font = UIFont.systemFont(ofSize: 14)
        self.gramLabel.textColor = UIColor.init(red: 60/255, green: 60/255, blue: 59/255, alpha: 1)
        self.gramLabel.textAlignment = .center
    }
    
    private func setupGramTextField() {
        if let weight = ColissimoData.shared.weight {
            let cleanString = weight.cleanString
            self.gramTextField.text = "\(cleanString) kg"
        }
        self.gramTextField.borderStyle = .roundedRect
        self.gramTextField.borderColor = .clear
        self.gramTextField.layer.masksToBounds = false
        self.gramTextField.layer.shadowRadius = 3.0
        self.gramTextField.layer.shadowColor = UIColor.gray.cgColor
        self.gramTextField.layer.shadowOffset = CGSize.init(width: 1, height: 0.5)
        self.gramTextField.layer.shadowOpacity = 1.0
        self.gramTextField.textAlignment = .center
        self.gramTextField.addTarget(self, action: #selector(ThirdStepViewController.changeValue), for: .editingChanged)
        self.gramTextField.delegate = self
        self.gramTextField.keyboardType = .decimalPad
        self.gramTextField.delegate = self
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(ColissimoHomeViewController.doneButtonAction))
        doneButton.tintColor = .black
        doneToolbar.items = [flexibleSpace, doneButton]
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        self.gramTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.gramTextField.delegate = self
        _ = self.gramTextField.delegate?.textFieldShouldReturn!(self.gramTextField)
    }
    
    @objc func changeValue() {
        if let text = self.gramTextField.text {
            let textDouble = Double(text) ?? 0
            self.setGaugeKg(value: textDouble)
            ColissimoData.shared.weight = textDouble
            let cleanString = textDouble.cleanString
            self.gramLabel.text = "Soit \(Int(textDouble) * 1000) g"
            self.getPrice()
        }
    }
    
    // MARK: Gauge methods
    
    private func setGaugeKg(value: Double) {
        self.gauge.value = Float(self.gauge.getValueFor(kg: value * 1000))
        self.gauge.setNeedsDisplay()
    }
    
    
    @IBAction func helpButtonTapped(_ sender: Any) {
        let vc = ColissimoManager.sharedManager.getColissimoThirdStepHelpViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let formCountries = FormalityCountry.shared.countries.first { country -> Bool in
            return country.departure_country_id == ColissimoData.shared.departureCountry && country.arrival_country_id == ColissimoData.shared.arrivalCountry
        }
        
        if formCountries?.has_customs_formalities == 1 {
            if CLRouter.shared.areEqual() {
                ColissimoManager.sharedManager.delegate?.homeViewDidCallDirectlyRecap(containsFormalities: ColissimoData.shared.containsFormalities(), step: 3)
            } else {
                ColissimoManager.sharedManager.delegate?.didCallFormalities()
            }
            
        } else {
            if CLRouter.shared.areEqual() {
                ColissimoManager.sharedManager.delegate?.homeViewDidCallDirectlyRecap(containsFormalities: ColissimoData.shared.containsFormalities(), step: 4)
            } else {
                ColissimoManager.sharedManager.delegate?.didCallSenderForm()
            }
        }
    }
    
    internal func getPrice() {
        if let departureCountry = ColissimoData.shared.departureCountry, let arrivalCountry = ColissimoData.shared.arrivalCountry, let weight = ColissimoData.shared.weight, let surcout = ColissimoData.shared.isSurcout {
            ColissimoAPIClient.sharedInstance.getPrice(fromIsoCode: departureCountry, toIsoCode: arrivalCountry, weight: weight, deposit: "", insuredValue: 0, withSignature: false, indemnitePlus: false, withSurcout: surcout, success: { price in
                self.floatingView.price = price.totalHT
                ColissimoData.shared.price = price.totalHT
                ColissimoData.shared.priceHT = price.prixHT
            }) { error in
                print(error)
            }
        } else {
            
        }
    }
}

extension ThirdStepViewController: ReusableGaugeDelegate {
    func valueDidChange(value: Float) {
        self.gramTextField.text = "\(((round(value)) / 1000).cleanString) kg"
        ColissimoData.shared.weight = Double((round(value) / 1000))
        self.gramLabel.text = "Soit \(Int(round(value))) g"
        self.getPrice()
    }
    
    func endEditing(value: Float) {
        if value < 10 {
            // Handle error
            if let errorView = ErrorMessageView.instanceFromNib() as? ErrorMessageView {
                let originY = self.calculateTopDistance()
                let error = LocalizedColissimoUI(key: "k_home_error_default_value")
                errorView.addInView(self.view, message: error, fromY: originY)
                self.setGaugeKg(value: 0.25)
                ColissimoData.shared.weight = 0.25
                self.gramTextField.text = " 0.25 kg"
                self.gramLabel.text = "Soit 250 g"
                self.getPrice()
            }
        } else if value > (Float(maxValue * 1000)) {
            // Handle error
            if let errorView = ErrorMessageView.instanceFromNib() as? ErrorMessageView {
                let originY = self.calculateTopDistance()
                let error = LocalizedColissimoUI(key: "k_home_error_max_value")
                errorView.addInView(self.view, message: error, fromY: originY)
                self.setGaugeKg(value: Double(maxValue))
                ColissimoData.shared.weight = Double(maxValue)
                self.gramTextField.text = "\(maxValue) kg"
                self.gramLabel.text = "Soit \(maxValue * 1000) g"
                self.getPrice()
            }
        }
    }
}

extension ThirdStepViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = self.gramTextField.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: ".") {
            let textDouble = Double(text) ?? 0
            
            if textDouble < 0.01 {
                // Handle error
                if let errorView = ErrorMessageView.instanceFromNib() as? ErrorMessageView {
                    let originY = self.calculateTopDistance()
                    let error = LocalizedColissimoUI(key: "k_home_error_default_value")
                    errorView.addInView(self.view, message: error, fromY: originY)
                    self.setGaugeKg(value: 0.25)
                    self.gramTextField.text = " 0.25 kg"
                    self.gramLabel.text = "Soit 250 g"
                    ColissimoData.shared.weight = 0.25
                    self.getPrice()
                }
            } else if Int(textDouble) > maxValue {
                // Handle error
                if let errorView = ErrorMessageView.instanceFromNib() as? ErrorMessageView {
                    let originY = self.calculateTopDistance()
                    let error = LocalizedColissimoUI(key: "k_home_error_max_value")
                    errorView.addInView(self.view, message: error, fromY: originY)
                    self.setGaugeKg(value: Double(maxValue))
                    self.gramTextField.text = "\(maxValue) kg"
                    self.gramLabel.text = "Soit \(maxValue * 1000) g"
                    ColissimoData.shared.weight = Double(maxValue)
                    self.getPrice()
                }
            } else {
                self.setGaugeKg(value: textDouble)
                ColissimoData.shared.weight = textDouble
                self.gramTextField.text = "\(textDouble.cleanString) kg"
                self.gramLabel.text = "Soit \((textDouble * 1000).cleanString) g"
                self.getPrice()
            }
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.gramTextField {
            self.gramTextField.text = self.gramTextField.text?.replacingOccurrences(of: "kg", with: "")
        }
    }
}
