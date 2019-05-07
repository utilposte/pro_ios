//
//  FirstStepViewController.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 22/10/2018.
//

import UIKit
import LPColissimo

public enum Step {
    case departureArrivalCountry
    case dimension
    case gauge
    case senderInfo
    case receiverInfo
    case drop
    case formalite(country: String)
    
    var stepNumber: String {
        switch self {
        case .departureArrivalCountry:
            return "1/6"
        case .dimension:
            return "2/6"
        case .gauge:
            return "3/6"
        case .senderInfo:
            return "4/6"
        case .receiverInfo:
            return "5/6"
        case .drop:
            return "6/6"
        case .formalite:
            return ""
        }
    }
    
    var stepTitle: String {
        switch self {
        case .departureArrivalCountry:
            return "Pays de départ et d'arrivée"
        case .dimension:
            return "Dimensions de votre colis"
        case .gauge:
            return "Poids de votre colis"
        case .senderInfo:
            return "Saisissez vos coordonnées"
        case .receiverInfo:
            return "Indiquez le destinataire"
        case .drop:
            return "Dépôt, livraison et indemnisation"
        case .formalite(let country):
            return "Formalités douanières :\n\(country)"
        }
    }
    
    var image: String {
        switch self {
        case .departureArrivalCountry:
            return "ic_step_1.png"
        case .dimension:
            return "ic_step_2.png"
        case .gauge:
            return "ic_step_3.png"
        case .senderInfo:
            return "ic_step_4.png"
        case .receiverInfo:
            return "ic_step_5.png"
        case .drop:
            return ""
        default:
            return ""
        }
    }
}

public class FirstStepViewController: UIViewController {
    enum FirstStep {
        case step(step: Step)
        case text(text: String)
        case departureCountry(placeholder: String, value: String)
        case arrivalCountry(placeholder: String, value: String)
        case weight(placeholder: String, value: Double)
        case next(title: String)
        
        var cellIdentifier: String {
            switch self {
            case .step:     return "StepTableViewCellID"
            case .text:     return "TextTableViewCellID"
            case .departureCountry, .arrivalCountry:     return "ChoiceTableViewCellID"
            case .weight:   return "TextFieldTableViewCellID"
            case .next:     return "ButtonTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .next:
                return 80
            case .text:
                return 80
            default:
                return UITableViewAutomaticDimension
            }
        }
    }
    
    enum PickerType {
        case departure
        case arrival
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var floatingView: FloatingView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var availableSections: [FirstStep] = []
    let picker = UIPickerView()
    let closeView = UIView()
    let crossButton = UIButton()
    var pickerType: PickerType = .departure
    var indexRow: Int?
    
    var departureCountries: [CLCountry] = []
    var arrivalCountries: [CLCountry] = []
    
    var departureCountry: CLCountry?
    var arrivalCountry: CLCountry?
    var weight: Double = 0.25
    
    var shouldStep3 = true
    
    lazy var thirdStepViewController: ThirdStepViewController = {
        return UIStoryboard.init(name: "Step", bundle: nil).instantiateViewController(withIdentifier: "ThirdStepViewControllerID") as! ThirdStepViewController
    }()
    
//    lazy var recapViewController: CLRecapViewController = {
//        return UIStoryboard.init(name: "CLRecap", bundle: nil).instantiateViewController(withIdentifier: "CLRecapViewController") as! CLRecapViewController
//    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupKeyboard()
        self.floatingView.isHidden = true
        self.floatingView.progress = 0.2
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.buildSection()
        self.fetchCountries()
        self.setFooterView()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE1ArriveeDepart,
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
    
    override public func viewDidLayoutSubviews() {
        self.floatingView.layoutSubviews()
    }
    
    private func buildSection() {
        self.availableSections.removeAll()
        
        self.availableSections.append(.step(step: .departureArrivalCountry))
        self.availableSections.append(.text(text: "Envoyez dès maintenant un Colissimo"))
        self.availableSections.append(.departureCountry(placeholder: "Départ", value: ColissimoData.shared.selectedSenderAddress?.name ?? ""))
        self.availableSections.append(.arrivalCountry(placeholder: "Arrivée", value: ColissimoData.shared.selectedReceiverAddress?.name ?? ""))
        self.availableSections.append(.weight(placeholder: "Poids", value: ColissimoData.shared.weight ?? 0))
        self.availableSections.append(.next(title: "Suivant"))

        self.floatingView.isHidden = false
        self.tableView.reloadData()
    }
    
    func fetchCountries() {
        ColissimoManager.sharedManager.getInitData(success: { success in
            // Add departure countries
            self.departureCountries.removeAll()
            self.departureCountries = success.departuresCountries
            
            // Add arrival countries
            self.arrivalCountries.removeAll()
            self.arrivalCountries = success.arrivalCountries
            
            if ColissimoData.shared.selectedSenderAddress == nil {
                ColissimoData.shared.selectedSenderAddress = self.departureCountries.filter({ country -> Bool in
                    return country.isocode! == success.defaultDepartureCountry
                }).first
            }
            
            if ColissimoData.shared.selectedReceiverAddress == nil {
                ColissimoData.shared.selectedReceiverAddress = self.arrivalCountries.filter({ country -> Bool in
                    return country.isocode! == success.defaultArrivalCountry
                }).first
            }
            
            self.buildSection()
            
            self.getPrice()
        }) { error in
            let alertController = UIAlertController(title: "Erreur", message: "Une erreur est survenue", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Fermer", style: .cancel, handler: nil)
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
}

extension FirstStepViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableSections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.availableSections[indexPath.row]
        switch item {
        case .step:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! StepTableViewCell
            cell.layer.insertSublayer(cell.gradient(frame: cell.bounds), at:0)
            cell.layoutSubviews()
            cell.setupCell(step: .departureArrivalCountry)
            return cell
        case .text(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! TextTableViewCell
            cell.setupCell(text: text)
            return cell
        case .departureCountry(let placeholder, let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ChoiceTableViewCell
            cell.setupCell(title: placeholder, value: value, action: "")
            cell.delegate = self
            return cell
        case .arrivalCountry(let placeholder, let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ChoiceTableViewCell
            cell.setupCell(title: placeholder, value: value, action: "")
            cell.delegate = self
            return cell
        case .weight(let placeholder, let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.setupCell(placeholder: placeholder, value: value)
            cell.textfieldValue.keyboardType = .decimalPad
            cell.delegate = self
            return cell
        case .next(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ButtonTableViewCell
            cell.setupCell(title: title)
            cell.delegate = self
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.availableSections[indexPath.row].rowHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.availableSections[indexPath.row]
        switch item {
        case .step:
            break
        case .text:
            break
        case .departureCountry:
            self.closeKeyboard()
            self.indexRow = indexPath.row
            self.closePicker()
            self.addPicker(for: .departure)
            self.pickerType = .departure
            self.picker.reloadAllComponents()
        case .arrivalCountry:
            self.closeKeyboard()
            self.indexRow = indexPath.row
            self.closePicker()
            self.addPicker(for: .arrival)
            self.pickerType = .arrival
            self.picker.reloadAllComponents()
        case .weight:
            let cell = self.tableView.cellForRow(at: indexPath) as! TextFieldTableViewCell
            cell.textfieldValue.becomeFirstResponder()
            break
        case .next:
            break
        }
    }
    
    func closeKeyboard() {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! TextFieldTableViewCell
        cell.textfieldValue.resignFirstResponder()
    }
    
    func addPicker(for: PickerType) {
        self.picker.dataSource = self
        self.picker.delegate = self
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        self.picker.backgroundColor = UIColor(red: 252/255, green: 255/255, blue: 252/255, alpha: 1)
        self.view.addSubview(self.picker)
        
        self.closeView.backgroundColor = UIColor(red: 191/255, green: 192/255, blue: 192/255, alpha: 1)
        self.closeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.closeView)
        
        self.crossButton.translatesAutoresizingMaskIntoConstraints = false
        self.crossButton.setTitle("OK", for: .normal)
        self.crossButton.setTitleColor(.black, for: .normal)
        self.crossButton.addTarget(self, action: #selector(FirstStepViewController.closePicker), for: .touchUpInside)
        self.closeView.addSubview(self.crossButton)
        
        NSLayoutConstraint.activate([
            self.picker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.picker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.picker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.picker.heightAnchor.constraint(equalToConstant: 150),
            self.closeView.bottomAnchor.constraint(equalTo: self.picker.topAnchor),
            self.closeView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.closeView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.closeView.heightAnchor.constraint(equalToConstant: 50),
            self.crossButton.rightAnchor.constraint(equalTo: self.closeView.rightAnchor, constant: -20),
            self.crossButton.topAnchor.constraint(equalTo: self.closeView.topAnchor),
            self.crossButton.bottomAnchor.constraint(equalTo: self.closeView.bottomAnchor),
            ])
    }
    
    @objc func closePicker() {
        self.picker.removeFromSuperview()
        self.closeView.removeFromSuperview()
        self.crossButton.removeFromSuperview()
    }
    
    private func getPrice() {
        if let departureCountry = ColissimoData.shared.departureCountry, let arrivalCountry = ColissimoData.shared.arrivalCountry, let weight = ColissimoData.shared.weight, let surcout = ColissimoData.shared.isSurcout {
            ColissimoAPIClient.sharedInstance.getPrice(fromIsoCode: departureCountry, toIsoCode: arrivalCountry, weight: weight, deposit: "", insuredValue: 0, withSignature: false, indemnitePlus: false, withSurcout: surcout, success: { price in
                self.floatingView.price = price.totalHT
                ColissimoData.shared.price = price.totalHT
                ColissimoData.shared.priceHT = price.prixHT
            }) { error in
                print(error)
            }
        } else {
            print("⛔️⛔️⛔️ getPrice contains nil ⛔️⛔️⛔️")
        }
    }
}

extension FirstStepViewController: ButtonTableViewCellDelegate {
    func buttonDidTapped(cell: ButtonTableViewCell) {
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! TextFieldTableViewCell
        
        if let text = cell.textfieldValue.text {
            if text != "" {
                _ = cell.textfieldValue?.delegate?.textFieldShouldReturn!(cell.textfieldValue!)
            } else {
                _ = cell.textfieldValue?.delegate?.textFieldShouldReturn!(cell.textfieldValue!)
            }
        }
        
        if CLRouter.shared.areEqual() {
            if self.shouldStep3 {
             ColissimoManager.sharedManager.delegate?.homeViewDidCallDirectlyRecap(containsFormalities: ColissimoData.shared.containsFormalities(), step: 1)
            }
        } else {
            ColissimoManager.sharedManager.delegate?.homeViewDidCallStep2With()
        }
    }
}

extension FirstStepViewController: ChoiceTableViewCellDelegate {
    func buttonDidTapped(cell: ChoiceTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            self.tableView.delegate?.tableView!(self.tableView, didSelectRowAt: indexPath)
        }
    }
}

extension FirstStepViewController: TextFieldTableViewCellDelegate {
    func keyboardDidClosed(value: Double, cell: TextFieldTableViewCell) {
        self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height + 100)
        
        self.tableView.scrollToRow(at: self.tableView.indexPathForSelectedRow ?? IndexPath.init(row: 4, section: 0), at: .top, animated: true)
        
        guard let poidsMax = ColissimoData.shared.selectedReceiverAddress?.poidsmax else { return }
        
        if value > poidsMax {
            if let errorView = ErrorMessageView.instanceFromNib() as? ErrorMessageView {
                let originY = self.calculateTopDistance()
                let error = LocalizedColissimoUI(key: "k_home_error_max_value")
                errorView.addInView(self.view, message: error, fromY: originY)
            }
            
            self.shouldStep3 = false
            self.weight = self.arrivalCountry!.poidsmax
            self.buildSection()
            return
        } else if value < 0.01 {
            if let errorView = ErrorMessageView.instanceFromNib() as? ErrorMessageView {
                let originY = self.calculateTopDistance()
                let error = LocalizedColissimoUI(key: "k_home_error_default_value")
                errorView.addInView(self.view, message: error, fromY: originY)
            }
            
            self.shouldStep3 = false
            self.weight = 0.25
            self.buildSection()
            return
        } else {
            self.weight = value
            self.shouldStep3 = true
        }
        ColissimoData.shared.weight = value
        self.getPrice()
        self.buildSection()
    }
    
    func crossButtonDidTapped(cell: TextFieldTableViewCell) {
        if !cell.textfieldValue.isFirstResponder {
            cell.textfieldValue.becomeFirstResponder()
        }
        cell.textfieldValue.text?.removeAll()
    }
    
    func textFieldDidEditing(cell: TextFieldTableViewCell) {
        self.closePicker()
        self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height - 100)
        
        self.tableView.scrollToRow(at: self.tableView.indexPathForSelectedRow ?? IndexPath.init(row: 5, section: 0), at: .bottom, animated: true)
    }
}

extension FirstStepViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public  func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.pickerType {
        case .arrival:
            return self.arrivalCountries.count
        case .departure:
            return self.departureCountries.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.pickerType {
        case .arrival:
            return self.arrivalCountries[row].name ?? ""
        case .departure:
            return self.departureCountries[row].name ?? ""
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let indexRow = self.indexRow else { return }
        let indexPath = IndexPath(row: indexRow, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as! ChoiceTableViewCell
        
        switch self.pickerType {
        case .arrival:
            cell.valueLabel.text = self.arrivalCountries[row].name ?? ""
            self.arrivalCountry = self.arrivalCountries[row]
        case .departure:
            cell.valueLabel.text = self.departureCountries[row].name ?? ""
            self.departureCountry = self.departureCountries[row]
        }
        
        ColissimoData.shared.departureCountry = self.departureCountry?.isocode ?? ""
        ColissimoData.shared.arrivalCountry = self.arrivalCountry?.isocode ?? ""
        
        ColissimoData.shared.selectedSenderAddress = self.departureCountry
        ColissimoData.shared.selectedReceiverAddress = self.arrivalCountry
        
        self.getPrice()
    }
}
