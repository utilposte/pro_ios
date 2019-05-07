//
//  CustomFormalitiesViewController.swift
//  LPColissimoUI
//
//  Created by LaPoste on 22/11/2018.
//

import UIKit
import LPColissimo

public struct FormalityChoice {
    var code: String
    var name: String
}

public struct Article: Equatable {
    var description: String?
    var weight: Double?
    var quantity: Int?
    var unitValue: Double?
    
    public static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.description == rhs.description
        && lhs.weight == rhs.weight
        && lhs.quantity == rhs.quantity
        && lhs.unitValue == rhs.unitValue
    }
}

public struct SellArticle: Equatable {
    var description: String?
    var tarifSH: Int?
    var weight: Double?
    var quantity: Int?
    var unitValue: Double?
    var originCountry: CLCountry?
    
    public static func == (lhs: SellArticle, rhs: SellArticle) -> Bool {
        return lhs.description == rhs.description
            && lhs.tarifSH == rhs.tarifSH
            && lhs.weight == rhs.weight
            && lhs.quantity == rhs.quantity
            && lhs.unitValue == rhs.unitValue
//            && lhs.originCountry == rhs.originCountry
    }
}

public struct OtherArticle: Equatable {
    var description: String?
    var weight: Double?
    var quantity: Int?
    var unitValue: Double?
    
    public static func == (lhs: OtherArticle, rhs: OtherArticle) -> Bool {
        return lhs.description == rhs.description
            && lhs.weight == rhs.weight
            && lhs.quantity == rhs.quantity
            && lhs.unitValue == rhs.unitValue
    }
}

enum FormalitiesArticle {
    case all
    case sell
    case back
    case other
}

enum FormalitiesPicker {
    case articleType
    case originCountry
}

public class CustomFormalitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    enum Formalities {
        case step
        case info(title: NSMutableAttributedString)
        case weight(title: String, value: String)
        case type(title: String, value: String, choices: [FormalityChoice])
        case title(title: String)
        case article(article: Article, check: Bool)
        case otherArticle(otherArticle: OtherArticle, check: Bool)
        case sellArticle(sellArticle: SellArticle, check: Bool)
        case addButton(title: String, color: UIColor)
        case button(title: String, color: UIColor)
        case precision(title: String)
        
        var cellIdentifier: String {
            switch self {
            case .step:
                return "StepTableViewCellID"
            case .info:
                return "FormalitiesInfoTableViewCellID"
            case .weight, .precision:
                return "FormalitiesWeightTableViewCellID"
            case .type:
                return "FormalitiesPickerTableViewCellID"
            case .title:
                return "FormalitiesTitleTableViewCellID"
            case .article:
                return "FormalitiesArticleTableViewCellID"
            case .otherArticle:
                return "FormalitiesArticleOtherTableViewCellID"
            case .sellArticle:
                return "FormalitiesArticleSellTableViewCellID"
            case .button, .addButton:
                return "FormalitiesButtonTableViewCellID"
            }
        }
        
        var rowHeight: Int {
            return 80
        }
    }
    
    var firstSection: [Formalities] = []
    var secondSection: [Formalities] = []
    
    var availableSections: [[Formalities]] = []
    var formalities: [FormalityChoice] = []
    var originCountries: [CLCountry] = []
    
    var indexPathCellCountry: IndexPath?
    
    var articles: [Formalities] = []
    
    var indexPathPicker: IndexPath?
    
    var pickerType: FormalitiesPicker = .articleType
    var isValid = true
    var isWeightCorrect = true
    
    var articleArrayObject: [Article] = []
    var sellArticleArrayObject: [SellArticle] = []
    var otherArticleArrayObject: [OtherArticle] = []
    
    var totalWeight: Double = 0
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.fetchCountries()
        self.setupKeyboard()
        self.setupTableView()
        self.setupPickerView()
        self.setFooterView()
        self.setupAvailableSection(false)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE31FormalitesDouanieres,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func setFooterView() {
        if let footer = ColissimoManager.sharedManager.delegate?.getFooterView() {
            let view: UIView = UIView(frame: footer.bounds)
            view.addSubview(footer)
            self.tableView.tableFooterView = view
        }
    }
    
    fileprivate func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(CustomFormalitiesViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomFormalitiesViewController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.closePicker()
        if let newFrame = (notification.userInfo?[ UIKeyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsetsMake( 0, 0, newFrame.height, 0 )
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[ UIKeyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsetsMake( 0, 0, 0, 0 )
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    
    fileprivate func checkArticles() {
        self.totalWeight = 0
        var i = 0
        while i < self.articles.count {
            if let _selectedFormality = ColissimoData.shared.formalityChoice {
                switch _selectedFormality.code {
                case "cadeau", "document", "echantillion":
                    self.tableView.scrollToRow(at: IndexPath(row: i, section: 1), at: .bottom, animated: false)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! FormalitiesArticleTableViewCell
                    if let _ = cell.descriptionTextField.text,
                        let quantity = Double(cell.quantityTextField.text ?? "0"),
                        let weight = Double(cell.weightTextfield.text?.replacingOccurrences(of: ",", with: ".") ?? "0"),
                        let _ = Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") {
                        let finalWeight = weight * quantity
                        self.isValid = true
                        self.totalWeight += finalWeight
                    } else {
                        self.isValid = false
                        let quantity = Double(cell.quantityTextField.text ?? "0") ?? 0
                        let weight = Double(cell.weightTextfield.text?.replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0
                        let finalWeight = weight * quantity
                        self.totalWeight += finalWeight
                    }
                case "retour-marchandise", "autre":
                    self.tableView.scrollToRow(at: IndexPath(row: i, section: 1), at: .bottom, animated: false)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! FormalitiesArticleOtherTableViewCell
                    if let _ = cell.descriptionTextField.text,
                        let quantity = Double(cell.quantityTextField.text ?? "0"),
                        let weight = Double(cell.weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"),
                        let _ = Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") {
                        self.isValid = true
                        let finalWeight = weight * quantity
                        self.totalWeight += finalWeight
                    } else {
                        self.isValid = false
                        let quantity = Double(cell.quantityTextField.text ?? "0") ?? 0
                        let weight = Double(cell.weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0
                        let finalWeight = weight * quantity
                        self.totalWeight += finalWeight
                    }
                case "envoi-commercial":
                    self.tableView.scrollToRow(at: IndexPath(row: i, section: 1), at: .bottom, animated: false)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! FormalitiesArticleSellTableViewCell
                    if let _ = cell.descriptionTextField.text,
                        let quantity = Double(cell.quantityTextField.text ?? "0"),
                        let weight = Double(cell.weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"),
                        let _ = Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"),
                        let _ = Double(cell.tarifSHTextField.text ?? "0"),
                        let tarifsString = cell.tarifSHTextField.text, tarifsString.characters.count == 6 || tarifsString.characters.count == 8 || tarifsString.characters.count == 10,
                        let _ = cell.originCountryTextField.text {
                        self.isValid = true
                        let finalWeight = weight * quantity
                        self.totalWeight += finalWeight
                        print(self.totalWeight)
                    } else {
                        self.isValid = false
                        let quantity = Double(cell.quantityTextField.text ?? "0") ?? 0
                        let weight = Double(cell.weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0
                        let finalWeight = weight * quantity
                        self.totalWeight += finalWeight
                    }
                default:
                    break
                }
            }
            i += 1
        }
    }
    
    fileprivate func addArticle() {
        if let _selectedFormality = ColissimoData.shared.formalityChoice {
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAjouterArticle,
                                                                  pageName: TaggingData.kE31FormalitesDouanieres,
                                                                  chapter1: TaggingData.kChapter1,
                                                                  chapter2: TaggingData.kChapter2,
                                                                  level2: TaggingData.kColissimoLevel)
            switch _selectedFormality.code {
            case "cadeau", "document", "echantillion":
                self.articles.append(.article(article: Article(), check: self.isValid))
            case "envoi-commercial":
                self.articles.append(.sellArticle(sellArticle: SellArticle(), check: self.isValid))
            case "retour-marchandise", "autre":
                self.articles.append(.otherArticle(otherArticle: OtherArticle(), check: self.isValid))
            default:
                break
            }
        }
    }
    
    fileprivate func deleteArticle(index: Int) {
        self.articles.remove(at: index)
    }
    
    fileprivate func saveArticles() {
        self.articleArrayObject.removeAll()
        self.otherArticleArrayObject.removeAll()
        self.sellArticleArrayObject.removeAll()
        var i = 0
        while i < self.articles.count {
            if let _selectedFormality = ColissimoData.shared.formalityChoice {
                switch _selectedFormality.code {
                case "cadeau", "document", "echantillion":
                    self.tableView.scrollToRow(at: IndexPath(row: i, section: 1), at: .bottom, animated: false)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! FormalitiesArticleTableViewCell
                    if let description = cell.descriptionTextField.text,
                        let quantity = Int(cell.quantityTextField.text ?? "0"),
                        let weight = Double(cell.weightTextfield.text?.replacingOccurrences(of: ",", with: ".") ?? "0"),
                        let unitValue = Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") {
                        let article = Article(description: description, weight: weight, quantity: quantity, unitValue: unitValue)
                        self.articleArrayObject.append(article)
                        self.articles[i] = .article(article: article, check: self.isValid)
                    } else {
                        let article = Article(description: cell.descriptionTextField.text, weight: Double(cell.weightTextfield.text?.replacingOccurrences(of: ",", with: ".") ?? "0"), quantity: Int(cell.quantityTextField.text ?? ""), unitValue: Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"))
                        self.articleArrayObject.append(article)
                        self.articles[i] = .article(article: article, check: self.isValid)
                    }
                case "retour-marchandise", "autre":
                    self.tableView.scrollToRow(at: IndexPath(row: i, section: 1), at: .bottom, animated: false)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! FormalitiesArticleOtherTableViewCell
                    if let description = cell.descriptionTextField.text, let quantity = Int(cell.quantityTextField.text ?? "0"), let weight = Double(cell.weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"), let unitValue = Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0") {
                        let otherArticle = OtherArticle(description: description, weight: weight, quantity: quantity, unitValue: unitValue)
                        self.otherArticleArrayObject.append(otherArticle)
                        self.articles[i] = .otherArticle(otherArticle: otherArticle, check: self.isValid)
                    } else {
                        let otherArticle = OtherArticle(description: cell.descriptionTextField.text, weight: Double(cell.weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"), quantity: Int(cell.quantityTextField.text ?? ""), unitValue: Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"))
                        self.otherArticleArrayObject.append(otherArticle)
                        self.articles[i] = .otherArticle(otherArticle: otherArticle, check: self.isValid)
                    }
                case "envoi-commercial":
                    self.tableView.scrollToRow(at: IndexPath(row: i, section: 1), at: .bottom, animated: false)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! FormalitiesArticleSellTableViewCell
                    if let description = cell.descriptionTextField.text, let quantity = Int(cell.quantityTextField.text ?? "0"), let weight = Double(cell.weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"), let unitValue = Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"), let tarif = Int(cell.tarifSHTextField.text ?? "0"), let tarifsString = cell.tarifSHTextField.text, tarifsString.characters.count == 6 || tarifsString.characters.count == 8 || tarifsString.characters.count == 10, let country = cell.originCountryTextField.text {
                        self.isValid = true
                        let _country = self.originCountries.first(where: { $0.name == country })
                        let sellArticle = SellArticle(description: description, tarifSH: tarif, weight: weight, quantity: quantity, unitValue: unitValue, originCountry: self.getCountryForIsoCode(isocode: (_country?.isocode)!))
                        self.sellArticleArrayObject.append(sellArticle)
                        self.articles[i] = .sellArticle(sellArticle: sellArticle, check: self.isValid)
                    } else {
                        self.isValid = false
                        let _country = self.originCountries.first(where: { $0.name == cell.originCountryTextField.text })
                        let sellArticle = SellArticle(description: cell.descriptionTextField.text, tarifSH: Int(cell.tarifSHTextField.text ?? ""), weight: Double(cell.weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"), quantity: Int(cell.quantityTextField.text ?? ""), unitValue: Double(cell.unitPriceTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"), originCountry: self.getCountryForIsoCode(isocode: ((_country?.isocode)!)))
                        self.sellArticleArrayObject.append(sellArticle)
                        self.articles[i] = .sellArticle(sellArticle: sellArticle, check: self.isValid)
                    }
                default:
                    break
                }
            }
            i += 1
        }
        
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(row: self.articles.count - 1, section: 1), at: .top, animated: false)
        }
    }
    
    func getCountryForIsoCode(isocode: String) -> CLCountry? {
        return self.originCountries.first(where: { country -> Bool in
            return country.isocode == isocode
        })
    }
    
    fileprivate func fetchCountries() {
        ColissimoAPIClient.sharedInstance.getInitData(success: { success in
            self.originCountries.removeAll()
            self.originCountries = success.arrivalCountries
        }) { (error) in
            print("error is \(error)")
        }
    }
    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    fileprivate func setupPickerView() {
        self.setupFormalitiesType()
        
        self.toolBar.isHidden = true
        self.pickerView.isHidden = true
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = .white
        self.toolBar.backgroundColor = .white
        self.pickerView.reloadAllComponents()
    }
    
    @IBAction func closePickerView(_ sender: Any) {
        self.toolBar.isHidden = true
        self.pickerView.isHidden = true
        var row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView(self.pickerView, didSelectRow: row, inComponent: 0)
    }
    
    func closePicker() {
        self.toolBar.isHidden = true
        self.pickerView.isHidden = true
    }
    
    fileprivate func setupInfoTitle() -> NSMutableAttributedString {
        let attributedString = NSAttributedString(string: "Vers l'Europe, l'outre-mer et l'international, vos envois peuvent être soumis à des formalités douanières, avec l'obligation de joindre des déclarations et documents spécifiques.", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .light), NSAttributedStringKey.foregroundColor: UIColor.lpTextGrey])
        let buttonAttributedString = NSAttributedString(string: "Plus d'informations", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .light), NSAttributedStringKey.foregroundColor: UIColor.lpBlueButton])
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttributedString.append(buttonAttributedString)
        
        return mutableAttributedString
    }
    
    fileprivate func setupErrorWeightTitle() -> NSMutableAttributedString {
        let attributedString = NSAttributedString(string: "Le poids total ne correspond pas à la somme des poids de tous vos articles. Veuillez indiquer le poids total ou ajuster le poids de chaque article.", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .light), NSAttributedStringKey.foregroundColor: UIColor.red])
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        return mutableAttributedString
    }
    
    fileprivate func setupFormalitiesType() {
        self.formalities.append(FormalityChoice(code: "retour-marchandise", name: "Retour de marchandise"))
        self.formalities.append(FormalityChoice(code: "cadeau", name: "Cadeau"))
        self.formalities.append(FormalityChoice(code: "echantillion", name: "Echantillon"))
        self.formalities.append(FormalityChoice(code: "document", name: "Document"))
        self.formalities.append(FormalityChoice(code: "envoi-commercial", name: "Vente de marchandises"))
        self.formalities.append(FormalityChoice(code: "autre", name: "Autre"))
    }
    
    fileprivate func setupAvailableSection(_ final: Bool = false) {
        self.firstSection.removeAll()
        self.secondSection.removeAll()
        self.availableSections.removeAll()
        
        self.firstSection.append(.step)
        self.firstSection.append(.info(title: self.setupInfoTitle()))
        
        // TODO
        // MARK: INFERIEUR OU EGAL POUR LE POIDS
        if let weight = ColissimoData.shared.weight {
            if final || self.isWeightCorrect == false {
                if self.totalWeight != 0 && self.totalWeight > weight {
                    self.isWeightCorrect = false
                    self.firstSection.append(.info(title: self.setupErrorWeightTitle()))
                } else {
                    self.isWeightCorrect = true
                }
            }
        } else {
            print("⛔️⛔️⛔️ Colissimo.shared.weight is nil ⛔️⛔️⛔️")
        }
        if let weight = ColissimoData.shared.weight {
            self.firstSection.append(.weight(title: "Poids total de tous vos articles", value: "\(weight) kg"))
        }
        
        self.firstSection.append(.type(title: "Nature du contenu de votre colis*", value: ColissimoData.shared.formalityChoice?.name ?? "Nature du contenu de votre colis", choices: self.formalities))
        
        if let formality = ColissimoData.shared.formalityChoice {
            switch formality.code {
            case "retour-marchandise":
                self.firstSection.append(.precision(title: "Veuillez préciser le motif de votre retour"))
            case "autre":
                self.firstSection.append(.precision(title: "Veuillez préciser"))
            default:
                break
            }
        }
        
        self.firstSection.append(.title(title: "Détaillez tous vos articles"))
        
        self.availableSections.append(self.firstSection)
        
        if ColissimoData.shared.articles.count > 0 {
            ColissimoData.shared.articles.map {
                self.articles.append(.article(article: $0, check: self.isValid))
            }
        } else if ColissimoData.shared.sellArticles.count > 0 {
            ColissimoData.shared.sellArticles.map {
                self.articles.append(.sellArticle(sellArticle: $0, check: self.isValid))
            }
        } else if ColissimoData.shared.otherArticles.count > 0 {
            ColissimoData.shared.otherArticles.map {
                self.articles.append(.otherArticle(otherArticle: $0, check: self.isValid))
            }
        }
        
        self.secondSection = self.articles
            
        self.availableSections.append(self.secondSection)
        if self.articles.count < 10 {
            self.availableSections.append([.addButton(title: "Ajouter un article", color: .lpOrange), .button(title: "SUIVANT", color: .lpGreen)])
        } else {
            self.availableSections.append([.button(title: "SUIVANT", color: .lpGreen)])
        }
        
        self.tableView.reloadData()
        
    }
    
}

extension CustomFormalitiesViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return availableSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableSections[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.availableSections[indexPath.section][indexPath.row]
        
        switch item {
        case .info(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesInfoTableViewCell
            cell.setupCell(title: title)
            return cell
        case .weight(let title, let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesWeightTableViewCell
            let doubleValue = Double.init(value.replacingOccurrences(of: " kg", with: ""))
            if let _doubleValue = doubleValue {
                cell.delegate = self
                if let selectedReceiverAddress = ColissimoData.shared.selectedReceiverAddress {
                    cell.maxValue = Double(selectedReceiverAddress.poidsmax)
                }
                cell.isWeight = true
                cell.setupCell(title: title, value: "\(String(format: "%.3f", _doubleValue)) kg")
            }
            return cell
        case .type(let title, let value, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesPickerTableViewCell
            cell.delegate = self
            cell.setupCell(title: title, value: value)
            return cell
        case .title(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesTitleTableViewCell
            cell.setupCell(title: title)
            return cell
        case .article(let article, let check):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesArticleTableViewCell
            cell.delegate = self
            cell.setupCell(article: article, index: indexPath.row, check: check, weight: self.isWeightCorrect, itemsNumber: self.articles.count)
            return cell
        case .sellArticle(let sellArticle, let check):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesArticleSellTableViewCell
            cell.delegate = self
            if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress {
                cell.setupCell(sellArticle: sellArticle, index: indexPath.row, check: check, weight: self.isWeightCorrect, country: selectedSenderAddress.name ?? "", itemsNumber: self.articles.count)
            }
            return cell
        case .otherArticle(let otherArticle, let check):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesArticleOtherTableViewCell
            cell.delegate = self
            cell.setupCell(otherArticle: otherArticle, index: indexPath.row, check: check, weight: self.isWeightCorrect, itemsNumber: self.articles.count)
            return cell
        case .button(let title, let color):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesButtonTableViewCell
            cell.setupCell(title: title, color: color)
            cell.actionButtonConstraintLeading.constant = 99
            cell.actionButtonConstraintTrailing.constant = 99
            cell.actionButton.layoutIfNeeded()
            return cell
        case .addButton(let title, let color):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesButtonTableViewCell
            cell.setupCell(title: title, color: color)
            return cell
        case .precision(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! FormalitiesWeightTableViewCell
            if let returnReason = ColissimoData.shared.returnReason {
                cell.setupCell(title: title, value: returnReason)
            }
            cell.delegate = self
            cell.valueTextfield.keyboardType = .default
            return cell
        case .step:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! StepTableViewCell
            if let selectedReceiverAddress = ColissimoData.shared.selectedReceiverAddress {
                cell.setupCell(step: .formalite(country: selectedReceiverAddress.name))
            }
            return cell
        }
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.availableSections[indexPath.section][indexPath.row]
        
        switch item {
        case .info:
            ColissimoManager.sharedManager.delegate?.customFormalitiesDidCallMoreInfo(url: "https://www.laposte.fr/professionnel/gestion-et-envois-au-quotidien/conseils-pratiques/comment-gerer-les-formalites-douanieres")
        case .type:
            self.hideKeyboard()
            self.pickerType = .articleType
            self.pickerView.reloadAllComponents()
            self.pickerView.isHidden = false
            self.toolBar.isHidden = false
        case .addButton:
            guard let _ = ColissimoData.shared.formalityChoice else { return }
            if let weight = ColissimoData.shared.weight {
                if self.articles.count < 10 {
                    self.checkArticles()
                    self.saveArticles()
                    if self.isValid == true && self.totalWeight <= weight {
                        self.addArticle()
                        self.setupAvailableSection(false)
                    } else {
                        self.setupAvailableSection(true)
                    }
                }
            }
        case .button:
            guard let _ = ColissimoData.shared.formalityChoice else { return }
            self.checkArticles()
            self.saveArticles()
            
            if let weight = ColissimoData.shared.weight {
                if self.totalWeight <= weight {
                    if self.isValid == true {
                        self.isWeightCorrect = true
                        
                        self.setupAvailableSection(false)
                        ColissimoData.shared.articles = self.articleArrayObject
                        ColissimoData.shared.otherArticles = self.otherArticleArrayObject
                        ColissimoData.shared.sellArticles = self.sellArticleArrayObject
                        
                        if ColissimoData.shared.articles.isEmpty && ColissimoData.shared.otherArticles.isEmpty && ColissimoData.shared.sellArticles.isEmpty { return }
                        
                        if CLRouter.shared.areEqual() {
                            ColissimoManager.sharedManager.delegate?.homeViewDidCallDirectlyRecap(containsFormalities: ColissimoData.shared.containsFormalities(), step: 4)
                        } else {
                            ColissimoManager.sharedManager.delegate?.didCallSenderForm()
                        }
                        
                    } else {
                        self.setupAvailableSection(true)
                    }
                } else {
                    self.isWeightCorrect = false
                    self.setupAvailableSection(true)
                }
            }
        default:
            break
        }
    }
}

extension CustomFormalitiesViewController: FormalitiesPickerTableViewCellDelegate {
    
    func labelDidTapped(cell: FormalitiesPickerTableViewCell) {
        self.hideKeyboard()
        self.pickerType = .articleType
        self.pickerView.reloadAllComponents()
        self.pickerView.isHidden = false
        self.toolBar.isHidden = false
    }
}

extension CustomFormalitiesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.pickerType {
        case .articleType:
            return self.formalities.count
        case .originCountry:
            return self.originCountries.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.pickerType {
        case .articleType:
            return self.formalities[row].name
        case .originCountry:
            return self.originCountries[row].name
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch self.pickerType {
        case .articleType:
            if let formality = ColissimoData.shared.formalityChoice {
                if formality.code == self.formalities[row].code {
                    ColissimoData.shared.formalityChoice = self.formalities[row]
                    self.setupAvailableSection(false)
                } else {
                    ColissimoData.shared.formalityChoice = self.formalities[row]
                    self.articles.removeAll()
                    self.addArticle()
                    self.setupAvailableSection(false)
                }
            } else {
                ColissimoData.shared.formalityChoice = self.formalities[row]
                self.articles.removeAll()
                self.addArticle()
                self.setupAvailableSection(false)
            }
        case .originCountry:
            if let indexPath = self.indexPathCellCountry {
                DispatchQueue.main.async {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    let cell = self.tableView.cellForRow(at: indexPath) as! FormalitiesArticleSellTableViewCell
                    cell.originCountryTextField.text = self.originCountries[row].name ?? ""
                }
            }
        }
    }
}

extension CustomFormalitiesViewController: FormalitiesArticleSellTableViewCellDelegate, FormalitiesArticleTableViewCellDelegate, FormalitiesArticleOtherTableViewCellDelegate {
    func keyboardDidClose(cell: FormalitiesArticleSellTableViewCell) {
        self.saveArticles()
        self.setupAvailableSection(true)
    }
    
    func keyboardDidClose(cell: FormalitiesArticleOtherTableViewCell) {
        self.saveArticles()
        self.setupAvailableSection(true)
    }
    
    
    func keyboardDidClose(cell: FormalitiesArticleTableViewCell) {
        self.saveArticles()
        self.setupAvailableSection(true)
    }
    
    func tarifSHButtonDidTapped(cell: FormalitiesArticleSellTableViewCell) {
        ColissimoManager.sharedManager.delegate?.customFormalitiesDidCallMoreInfo(url: "http://ec.europa.eu/taxation_customs/dds2/taric/taric_consultation.jsp?Lang=fr&SimDate=20151116")
    }
    
    
    func deleteButtonDidTapped(cell: FormalitiesArticleTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            self.saveArticles()
            self.deleteArticle(index: indexPath.row)
            self.setupAvailableSection(false)
        }
    }
    
    func deleteButtonDidTapped(cell: FormalitiesArticleOtherTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            self.saveArticles()
            self.deleteArticle(index: indexPath.row)
            self.setupAvailableSection(false)
        }
    }
    
    func deleteButtonDidTapped(cell: FormalitiesArticleSellTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            self.saveArticles()
            self.deleteArticle(index: indexPath.row)
            self.setupAvailableSection(false)
        }
    }
    
    func originCountryDidTapped(cell: FormalitiesArticleSellTableViewCell) {
        self.indexPathCellCountry = self.tableView.indexPath(for: cell)
        self.hideKeyboard()
        self.pickerType = .originCountry
        self.pickerView.reloadAllComponents()
        self.pickerView.isHidden = false
        self.toolBar.isHidden = false
    }
    
}

extension CustomFormalitiesViewController: FormalitiesWeightTableViewCellDelegate {
    func weightDidChanged(weight: Double) {
        ColissimoData.shared.weight = weight
        self.setupAvailableSection()
    }
    
    func precisionTextDidChange(text: String) {
        ColissimoData.shared.returnReason = text
    }
}
