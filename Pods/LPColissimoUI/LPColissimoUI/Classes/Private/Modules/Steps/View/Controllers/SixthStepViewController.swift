//
//  SixthStepViewController.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 19/11/2018.
//

import UIKit
import LPColissimo

// MARK: Globals struct
struct Choice {
    var image: UIImage?
    var titleButton: String?
    var isEnabled: Bool?
    var isSelected: Bool?
    var unavailableText: String?
}

enum InsuranceError: Equatable {
    case minus(value: Double)
    case plus(value: Double)
    case none
    
    var description: String {
        switch self {
        case .minus(let value):
            return "Valeur minimum \(value) €"
        case .plus(let value):
            return "Valeur maximum \(value) €"
        case .none:
            return ""
        }
    }
}

public class SixthStepViewController: UIViewController {
    
    // MARK: Enum
    
    enum SixthStep {
        case step(step: Step)
        case title(title: String)
        case choice(firstChoice: Choice, secondChoice: Choice)
        case dialog(title: String, content: String)
        case advancedDialog(initialPrice: Int, price: Int, isOn: Bool, tarif: String)
        case back
        case button
        
        var cellIdentifier: String {
            switch self {
            case .step:                    return "StepTableViewCellID"
            case .title:                   return "TitleTableViewCellID"
            case .choice:                  return "DualChoiceTableViewCellID"
            case .dialog:                  return "DialogTableViewCellID"
            case .advancedDialog:          return "AdvancedDialogTableViewCellID"
            case .back:                    return "ColissimoBackTableViewCellID"
            case .button:                  return "ButtonTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .choice:
                return 260
            case .button:
                return 130
            case .title, .dialog, .advancedDialog, .back, .step:
                return UITableViewAutomaticDimension
            }
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var availableSections: [[SixthStep]] = [[]]
    @IBOutlet weak var floatingView: FloatingView!
    
    // INDEMNISATION
    var isDeliveryBoite: Bool?
    var isDeliveryMain: Bool?
    var indemnisationBoiteMax: Double?
    var indemnisationBoiteMin: Double?
    var indemnisationMainMax: Double?
    var indemnisationMainMin: Double?
    
    var insuranceError: InsuranceError = .none
    
    var retrieveColisDate: String?
    var getScndDate = false
    
    var firstChoice = Choice(image: ColissimoHomeServices.loadImage(name:"ic_mode_home.png"), titleButton: "Dans ma boite aux lettres", isEnabled: true, isSelected: false, unavailableText: "L'envoi depuis votre boite aux lettres n'est pas disponible.")
    var secondChoice = Choice(image: ColissimoHomeServices.loadImage(name:"ic_mode_poste.png"), titleButton: "Dans un bureau de poste", isEnabled: true, isSelected: false, unavailableText: nil)
    var thirdChoice = Choice(image: ColissimoHomeServices.loadImage(name:"img_bal.png"), titleButton: "En boite aux lettres", isEnabled: true, isSelected: false, unavailableText: "La réception en boite aux lettres est indisponible pour votre colis.")
    var fourthChoice = Choice(image: ColissimoHomeServices.loadImage(name:"img_main_propre.png"), titleButton: "En main propre", isEnabled: true, isSelected: false, unavailableText: "")
    
    var isOn = false
    var defaultPrice: CLPrice?
    var price: CLPrice?
    var tarif = ""
    var withSignature = false
    var insuredValue: Double = 0
    var depositMode: String = "BUREAU_POSTE"
    var deliveryMode: String = "BOITE_LETTRE"
    
    var insuranceValue: Double = 0
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.fetchIndemnisation()
        self.activityIndicator.isHidden = true
        self.fetchBALInfo()
        self.thirdChoiceSelected()
        self.setFooterView()
        
        self.floatingView.progress = 0.8
        floatingView.animate()
        if let price = ColissimoData.shared.price {
            self.floatingView.productImageNamed = ColissimoData.shared.dimension.image
            self.floatingView.price = price
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE6DepotLivraison,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
    }
    
    func setFooterView() {
        if let footer = ColissimoManager.sharedManager.delegate?.getFooterView() {
            let view: UIView = UIView(frame: footer.bounds)
            view.addSubview(footer)
            self.tableView.tableFooterView = view
        }
    }
    
    override public func viewDidLayoutSubviews() {
        self.floatingView.layoutSubviews()
    }
    
    private func thirdChoiceSelected() {
        if let weight = ColissimoData.shared.weight, let arrivalCountry = ColissimoData.shared.arrivalCountry {
            let departureCountries = ["ad", "fr", "gp", "gf", "re", "mq", "yt", "mc", "bl", "mf", "pm"]
            if weight <= 5 && departureCountries.contains(arrivalCountry) {
                self.thirdChoice.isSelected = true
                self.deliveryMode = "BOITE_LETTRE"
            } else {
                self.thirdChoice.isSelected = false
                self.deliveryMode = "MAIN_PROPRE"
            }
        }
    }
    
    private func setupTableView() {
        self.tableView.estimatedRowHeight = 180
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func fetchIndemnisation() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        if let weight = ColissimoData.shared.weight, let priceHT = ColissimoData.shared.priceHT, let arrivalCountry = ColissimoData.shared.arrivalCountry {
            ColissimoAPIClient.sharedInstance.getDeliveryMode(weigth: weight, transportPrice: priceHT, toIsoCode: arrivalCountry, withSignature: false, success: { deliveryResponse in
                self.activityIndicator.stopAnimating()
                if let isDeliveryMain = deliveryResponse.isPossibleLivraisonMainPropre {
                    self.isDeliveryMain = isDeliveryMain
                    self.fourthChoice.isEnabled = self.isDeliveryMain
                }
                
                if let isDeliveryBoite = deliveryResponse.isPossibleLivraisonBoite {
                    self.isDeliveryBoite = isDeliveryBoite
                    self.thirdChoice.isEnabled = self.isDeliveryBoite
                }
                
                if let indemnisationMainMax = deliveryResponse.indemnisationMainPropre?.max {
                    self.indemnisationMainMax = indemnisationMainMax
                }
                
                if let indemnisationMainMin = deliveryResponse.indemnisationMainPropre?.min {
                    self.indemnisationMainMin = indemnisationMainMin
                    if ColissimoData.shared.insuredValue == nil {
                        ColissimoData.shared.insuredValue = Double(indemnisationMainMin)
                    }
                }
                
                if let indemnisationBoiteMax = deliveryResponse.indemnisationBoite?.max {
                    self.indemnisationBoiteMax = indemnisationBoiteMax
                }
                
                if let indemnisationBoiteMin = deliveryResponse.indemnisationBoite?.min {
                    self.indemnisationBoiteMin = indemnisationBoiteMin
                }
                
                // MARK: PRESELECTION OF CHOICE FOR DELIVERY
                
                if self.isDeliveryBoite == true {
                    self.thirdChoice.isSelected = true
                    self.fourthChoice.isSelected = false
                } else {
                    self.thirdChoice.isSelected = false
                    self.fourthChoice.isSelected = true
                }
                
                self.insuredValue = ColissimoData.shared.insuredValue ?? Double(self.indemnisationMainMin ?? 50)
                self.getColisPrice(insuredValue: self.insuredValue)
                self.setupTableView()
                self.setupSection()
            }) { error in
                self.activityIndicator.stopAnimating()
                print(error)
            }
        }
    }
    
    private func getColisPrice(insuredValue: Double) {
        let insuredValueToSend = self.deliveryMode == "MAIN_PROPRE" ? insuredValue : 0
        if let departureCountry = ColissimoData.shared.departureCountry, let arrivalCountry = ColissimoData.shared.arrivalCountry, let weight = ColissimoData.shared.weight, let isSurcout = ColissimoData.shared.isSurcout {
            
            ColissimoAPIClient.sharedInstance.getPrice(fromIsoCode: departureCountry, toIsoCode: arrivalCountry, weight: weight, deposit: self.depositMode, insuredValue: insuredValueToSend, withSignature: true, indemnitePlus: false, withSurcout: isSurcout, success: { price in
                
                self.tarif = "\(price.assuranceLabel) + \(price.assuranceTotal) €"
                self.defaultPrice = price
                
                ColissimoData.shared.productCodeColis = price.productCodeColis
                ColissimoData.shared.totalNetPriceAssurance = price.assuranceTotal
                ColissimoData.shared.totalNetPriceSurcout = price.surcout
                
                if self.fourthChoice.isSelected == true {
                    self.floatingView.price = price.totalHT
                    ColissimoData.shared.price = price.totalHT
                } else {
                    self.floatingView.price = price.totalHT
                    ColissimoData.shared.price = price.totalHT
                }
                
                ColissimoData.shared.priceHT = price.prixHT
                
                
                if self.fourthChoice.isSelected == true {
                    if price.assuranceTotal == 0 {
                        self.fourthChoice.unavailableText = "inclus \n Contre-signature"
                    } else {
                        self.fourthChoice.unavailableText = "+ \(price.assuranceTotal) € \n Contre-signature"
                    }
                } else {
                    ColissimoData.shared.totalNetPriceAssurance = 0
                    self.fourthChoice.unavailableText = ""
                }
                
                self.setupSection()
            }) { error in
                print("Ooops an error occured => \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchBALInfo() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        if let weight = ColissimoData.shared.weight, let departureCountry = ColissimoData.shared.departureCountry, let arrivalCountry = ColissimoData.shared.arrivalCountry, let senderAddress = ColissimoData.shared.senderAddress {
            
            ColissimoAPIClient.sharedInstance.getDepotMode(weigth: weight, typeColis: ColissimoData.shared.dimension.title.uppercased(), fromIsoCode: departureCountry, toIsoCode: arrivalCountry, postalCode: senderAddress.postalCode, locality: senderAddress.locality, line2: senderAddress.street, success: { modeResponse in
                
                if let basculeToSecondeDate = modeResponse.basculeToSecondeDate, basculeToSecondeDate == true {
                    if let secondDate = modeResponse.secondDate {
                        self.retrieveColisDate = secondDate.label ?? ""
                        ColissimoData.shared.dateDepot = secondDate.id ?? ""
                        self.getScndDate = true
                    }
                } else {
                    if let dateArray = modeResponse.date, !dateArray.isEmpty {
                        self.retrieveColisDate = dateArray.last?.label ?? ""
                        ColissimoData.shared.dateDepot = dateArray.last?.id ?? ""
                        self.getScndDate = false
                    }
                }
                
                self.activityIndicator.stopAnimating()
                self.firstChoice.isEnabled = true
                
                // MARK: PRESELECTION OF CHOICE FOR DEPOSIT
                self.firstChoice.isSelected = true
                self.secondChoice.isSelected = false
                
                self.depositMode = "BOITE_LETTRE"
                self.setupTableView()
                self.setupSection()
            }) { error in
                self.activityIndicator.stopAnimating()
                self.firstChoice.isEnabled = false
                
                // MARK: PRESELECTION OF CHOICE FOR DEPOSIT
                self.firstChoice.isSelected = false
                self.secondChoice.isSelected = true
                
                self.depositMode = "BUREAU_POSTE"
                self.setupTableView()
                self.setupSection()
                print(error)
            }
        }
    }
    
    private func setupSection() {
        self.availableSections.removeAll()
        var firstSectionArray: [SixthStep] = []
        firstSectionArray.append(.step(step: Step.drop))
        firstSectionArray.append(.title(title: "Je choisis de déposer mon colis :"))
        firstSectionArray.append(.choice(firstChoice: self.firstChoice, secondChoice: self.secondChoice))
        
        self.isOn = ColissimoData.shared.isOn
        
        if let deliveryMode = ColissimoData.shared.deliveryMode {
            if deliveryMode == "MAIN_PROPRE" {
                self.thirdChoice.isSelected = false
                self.fourthChoice.isSelected = true
            } else if deliveryMode == "BOITE_LETTRE" {
                self.thirdChoice.isSelected = true
                self.fourthChoice.isSelected = false
            }
        }
        
        if let depositMode = ColissimoData.shared.depositMode {
            if depositMode == "BOITE_LETTRE" {
                self.firstChoice.isSelected = true
                self.secondChoice.isSelected = false
            } else if depositMode == "BUREAU_POSTE" {
                self.firstChoice.isSelected = false
                self.secondChoice.isSelected = true
            }
        }
        
        if self.firstChoice.isSelected == true {
            if let date = self.retrieveColisDate {
                if self.getScndDate {
                    firstSectionArray.append(.dialog(title: "Attention, pour toute commande validée après 23h, le facteur récupère votre colis dans la journée du \(date).", content: " Déposez votre colis avant 8h00 du matin pour que votre facteur le récupère dans la journée et dépose un avis de prise en charge."))
                } else {
                    firstSectionArray.append(.dialog(title: "votre facteur récupèrera votre colis dans la journée du \(date)", content: "Déposez votre colis avant 8h00 pour que votre facteur le récupère et dépose un avis de prise en charge."))
                }
            }
        } else if self.secondChoice.isSelected == true { }
        
        self.availableSections.append(firstSectionArray)
        var secondSectionArray: [SixthStep] = []
        secondSectionArray.append(.title(title: "Je choisis le mode de livraison :"))
        
        secondSectionArray.append(.choice(firstChoice: self.thirdChoice, secondChoice: self.fourthChoice))
        
        if let defaultCompensationByWeight = ColissimoData.shared.defaultCompensationByWeight, let insuredValue = ColissimoData.shared.insuredValue {
            if self.thirdChoice.isSelected == true {
                if let indemnisationBAL = self.indemnisationBoiteMin {
                    secondSectionArray.append(.dialog(title: "Votre livraison inclus une indémnisation de \(String(format: "%.2f", indemnisationBAL).replacingOccurrences(of: ".", with: ",")) € en cas de perte de colis (soit \(Int(defaultCompensationByWeight))€ /kg).", content: ""))
                }
            } else if self.fourthChoice.isSelected == true {
                secondSectionArray.append(.advancedDialog(initialPrice: Int(self.indemnisationMainMin ?? 50), price: Int(insuredValue), isOn: self.isOn, tarif: self.tarif))
                if self.insuranceValue < insuredValue {
                    self.insuranceValue = insuredValue
                }
            }
        }
        
        secondSectionArray.append(.button)
        
        self.availableSections.append(secondSectionArray)
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension SixthStepViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableSections[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.availableSections[indexPath.section][indexPath.row]
        switch item {
        case .step(let step):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! StepTableViewCell
            cell.setupCell(step: step)
            return cell
        case .title(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! TitleTableViewCell
            cell.setupCell(title: title)
            return cell
        case .choice(let choice, let choice2):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! DualChoiceTableViewCell
            cell.setupCell(firstChoice: choice, secondChoice: choice2)
            cell.delegate = self
            return cell
        case .dialog(let title, let content):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! DialogTableViewCell
            if indexPath.section == 0 {
                cell.setupCell(title: title, content: content, firstSelected: self.firstChoice.isSelected ?? false)
            } else {
                cell.setupCell(title: title, content: content, firstSelected: self.thirdChoice.isSelected ?? false)
            }
            
            return cell
        case .advancedDialog(let initialPrice, let price, let isOn, let tarif):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AdvancedDialogTableViewCell
            cell.delegate = self
            cell.priceError = self.insuranceError
            cell.setupCell(initialPrice: initialPrice, price: price, isOn: isOn, tarif: tarif)
            return cell
        case .back:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ColissimoBackTableViewCell
            cell.setupCell()
            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ButtonTableViewCell
            cell.setupCell(title: "SUIVANT")
            cell.delegate = self
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.availableSections[indexPath.section][indexPath.row].rowHeight
    }
    
}

extension SixthStepViewController: DualChoiceTableViewCellDelegate {
    func firstViewDidTapped(cell: DualChoiceTableViewCell) {
        let cellIndexPath = self.tableView.indexPath(for: cell)
        
        if let indexPath = cellIndexPath {
            switch indexPath.section {
            case 0:
                if self.firstChoice.isEnabled == true{
                    self.firstChoice.isSelected = true
                    self.secondChoice.isSelected = false
                    self.depositMode = "BOITE_LETTRE"
                    ColissimoData.shared.depositMode = self.depositMode
                }
            case 1:
                if self.thirdChoice.isEnabled == true{
                    self.thirdChoice.isSelected = true
                    self.fourthChoice.isSelected = false
                    self.withSignature = false
                    self.deliveryMode = "BOITE_LETTRE"
                    ColissimoData.shared.deliveryMode = self.deliveryMode
                }
            default:
                break
            }
            self.setupSection()
            if let insuredValue = ColissimoData.shared.insuredValue {
                self.getColisPrice(insuredValue: insuredValue)
            }
        }
    }
    
    func secondViewDidTapped(cell: DualChoiceTableViewCell) {
        let cellIndexPath = self.tableView.indexPath(for: cell)
        
        if let indexPath = cellIndexPath {
            switch indexPath.section {
            case 0:
                if self.secondChoice.isEnabled == true {
                    self.firstChoice.isSelected = false
                    self.secondChoice.isSelected = true
                    self.withSignature = false
                    self.depositMode = "BUREAU_POSTE"
                    ColissimoData.shared.depositMode = self.depositMode
                }
            case 1:
                if self.fourthChoice.isEnabled == true {
                    self.thirdChoice.isSelected = false
                    self.fourthChoice.isSelected = true
                    self.withSignature = true
                    self.isOn = false
                    ColissimoData.shared.isOn = self.isOn
                    self.deliveryMode = "MAIN_PROPRE"
                    ColissimoData.shared.deliveryMode = self.deliveryMode
                }
            default:
                break
            }
            self.setupSection()
            if let insuredValue = ColissimoData.shared.insuredValue {
                self.getColisPrice(insuredValue: insuredValue)
            }
        }
    }
}

extension SixthStepViewController: ButtonTableViewCellDelegate {
    func buttonDidTapped(cell: ButtonTableViewCell) {
        guard let indemMin = self.indemnisationMainMin, let indemMax = self.indemnisationMainMax else { return }
        self.insuredValue = self.insuranceValue
        if self.isOn {
            if self.insuranceValue > indemMin && self.insuranceValue <= indemMax {
                ColissimoData.shared.indemnitePlus = false
                ColissimoData.shared.withSignature = self.withSignature
                ColissimoData.shared.insuredValue = self.insuredValue
                ColissimoData.shared.depositMode = self.depositMode
                ColissimoData.shared.deliveryMode = self.deliveryMode
                ColissimoManager.sharedManager.delegate?.didCallRecap()
            } else {
                ColissimoData.shared.insuredValue = self.indemnisationMainMin! + 1
                if let insuredValue = ColissimoData.shared.insuredValue {
                    self.getColisPrice(insuredValue: insuredValue)
                }
            }
        } else {
            self.insuredValue = self.indemnisationMainMin!
            ColissimoData.shared.indemnitePlus = false
            ColissimoData.shared.withSignature = self.withSignature
            ColissimoData.shared.insuredValue = self.insuredValue
            ColissimoData.shared.depositMode = self.depositMode
            ColissimoData.shared.deliveryMode = self.deliveryMode
            ColissimoManager.sharedManager.delegate?.didCallRecap()
        }
    }
}

extension SixthStepViewController: AdvancedDialogTableViewCellDelegate {
    func switchDidChange(cell: AdvancedDialogTableViewCell) {
        self.isOn = !self.isOn

        if self.isOn {
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kActiverIndemnisation,
                                                                  pageName: TaggingData.kE6DepotLivraison,
                                                                  chapter1: TaggingData.kChapter1,
                                                                  chapter2: TaggingData.kChapter2,
                                                                  level2: TaggingData.kColissimoLevel)
            
            let indexPath = self.tableView.indexPath(for: cell)
            if let _indexPath = indexPath {
                let cell = self.tableView.cellForRow(at: _indexPath) as! AdvancedDialogTableViewCell
                if let insuredValueText = cell.thirdTextField.text, let insuredValueDouble = Double(insuredValueText) {
                    ColissimoData.shared.insuredValue = insuredValueDouble
                    self.insuranceValue = insuredValueDouble
                    self.getColisPrice(insuredValue: insuredValueDouble)
                }
            }
        } else {
            ColissimoData.shared.insuredValue = Double(self.indemnisationMainMin ?? 50)
            if let insuredValue = ColissimoData.shared.insuredValue {
                self.getColisPrice(insuredValue: insuredValue)
            }
        }
        
        ColissimoData.shared.isOn = self.isOn
    }
    
    func thirdButtonTapped() {
        _ = ColissimoManager.sharedManager.delegate?.step6ViewDidCallPrice()
    }
    
    func thirdTextFieldDidEditing(value: String, cell: AdvancedDialogTableViewCell) {
        if let insuredValue = Double(value), let indemMin = self.indemnisationMainMin, let indemMax = self.indemnisationMainMax {
            self.insuranceValue = insuredValue
            if insuredValue <= indemMin {
                ColissimoData.shared.insuredValue = indemMin
                if let insuredValue = ColissimoData.shared.insuredValue {
                    self.getColisPrice(insuredValue: insuredValue)
                }
            } else if insuredValue > indemMax {
                ColissimoData.shared.insuredValue = indemMin
                if let insuredValue = ColissimoData.shared.insuredValue {
                    self.getColisPrice(insuredValue: insuredValue)
                }
            } else if insuredValue == 0 {
                ColissimoData.shared.insuredValue = indemMin
                if let insuredValue = ColissimoData.shared.insuredValue {
                    self.getColisPrice(insuredValue: insuredValue)
                }
            } else {
                ColissimoData.shared.insuredValue = insuredValue
                self.getColisPrice(insuredValue: insuredValue)
                self.insuranceError = .none
            }
        } else {
            self.insuranceValue = 0
            ColissimoData.shared.insuredValue = self.indemnisationMainMin! + 1
            
            if let insuredValue = ColissimoData.shared.insuredValue {
                self.getColisPrice(insuredValue: insuredValue)
            }            
        }
    }
    
    func thirdTextFieldDidChangeErrorStatus(value: String, cell: AdvancedDialogTableViewCell) {
        if let insuredValue = Double(value), let indemMin = self.indemnisationMainMin, let indemMax = self.indemnisationMainMax {
            self.insuranceValue = insuredValue
            if insuredValue <= indemMin {
                self.insuranceError = .minus(value: indemMin + 1)
            } else if insuredValue > indemMax {
                self.insuranceError = .plus(value: indemMax)
            } else if insuredValue == 0 {
                self.insuranceError = .minus(value: indemMin + 1)
            } else {
                self.insuranceError = .none
            }
        } else {
            self.insuranceError = .minus(value: self.indemnisationMainMin! + 1)
        }
    }
}
