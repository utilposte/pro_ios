//
//  ColissimoHomeViewController.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 17/10/2018.
//

import UIKit
import LPColissimo

class ColissimoHomeViewController: UIViewController {
    
    // MARK: - Vaeriables
    var presenter : ColissimoHomePresenter?
    var guideCells = [UITableViewCell]()
    var advantageCells = [UITableViewCell]()
    var guides = [HomeGuideViewModel]()
    var countryPickerViewController : ColissimoCountryPickerViewController?
    var isDataLoaded : Bool = false
    var containsColissimo: Bool = false
    
    // MARK: - IBOutlet
    @IBOutlet weak var pageViewCollection: PageViewController!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var departureCountryLabel: UILabel!
    @IBOutlet weak var arrivalCountryLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var castWeightLabel: UILabel!
    @IBOutlet weak var resultPriceLabel: UILabel!
    @IBOutlet weak var priceWaitingAvtivityIndicator: UIActivityIndicatorView!
    // For lacalized
    @IBOutlet weak var sendColissimoLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var weithLabel: UILabel!
    @IBOutlet weak var startFromLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    // For Images
    @IBOutlet weak var selectImageDeparture: UIImageView!
    @IBOutlet weak var selectImageArrival: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    // Picker View
    @IBOutlet weak var countryPickerContainerView: UIView!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ColissimoManager.sharedManager.delegate?.setUpNavigationItem(navigationItem: self.navigationItem)
        self.addDoneButtonOnKeyboard()
        self.setUpStrings()
        self.setUpImages()
        self.setFooterView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initPresenter()
        pageViewCollection.startTimer()
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE0Accueil,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pageViewCollection.cancelTimer()
        self.presenter = nil
    }
    
    func enableButton(_ button : UIButton ,isEnabled : Bool){
        button.isEnabled = isEnabled
        button.backgroundColor = isEnabled ? UIColor.lpOrange : UIColor.lightGray
    }
    
    func setFooterView() {
        if let footer = ColissimoManager.sharedManager.delegate?.getFooterView() {
            let view: UIView = UIView(frame: footer.bounds)
            view.addSubview(footer)
            self.tableView.tableFooterView = view
        }
    }
    
    func initPresenter() {
        //        sendButton.isEnabled = self.isDataLoaded
        enableButton(sendButton, isEnabled:self.isDataLoaded )
        if presenter == nil {
            self.presenter = ColissimoHomePresenter(self)
            //            self.presenter?.getDataForView()
            self.presenter?.getDataForView(success: { (result: DataContainer) in
                self.isDataLoaded = true
                
                self.enableButton(self.sendButton, isEnabled:self.isDataLoaded )
                self.tableView.reloadData()
            },
                                           failure: { (error: Error) in
                                            self.isDataLoaded = false
                                            self.enableButton(self.sendButton, isEnabled:self.isDataLoaded )
                                            
            })
            
            self.presenter?.generateGuideCellsIn(self.tableView)
            self.presenter?.generateAdvantageCellsIn(self.tableView)
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        if let pickerViewController = destination as? ColissimoCountryPickerViewController {
            countryPickerViewController = pickerViewController
            self.initPresenter()
            countryPickerContainerView.isHidden = true
            countryPickerViewController?.presenter = self.presenter
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    
    // MARK: - SetUp View
    func setUpStrings() {
        self.title = LocalizedColissimoUI(key: "k_home_title_key")
        
        sendColissimoLabel.text = LocalizedColissimoUI(key: "k_home_send_now_text_key")
        departureLabel.text = LocalizedColissimoUI(key: "K_home_departure_key")
        arrivalLabel.text = LocalizedColissimoUI(key: "K_home_arrival_key")
        weithLabel.text = LocalizedColissimoUI(key: "k_home_wight_key")
        startFromLabel.text = LocalizedColissimoUI(key: "k_home_weight_from_key")
        sendButton.setTitle(LocalizedColissimoUI(key: "k_home_send_button_key"), for: .normal)        
    }
    
    func setUpImages() {
        selectImageDeparture.image = ColissimoHomeServices.loadImage(name: "select.png")
        selectImageArrival.image = ColissimoHomeServices.loadImage(name: "select.png")
        clearButton.setImage(ColissimoHomeServices.loadImage(name: "clear.png"), for: .normal)
    }
    
    @IBAction func selectCountryClicked(_ sender: UIButton) {
        self.weightTextField.resignFirstResponder()
        switch sender.tag {
        case 1:
            countryPickerViewController?.type = .departure
            countryPickerContainerView.isHidden = false
        case 2:
            countryPickerViewController?.type = .arrival
            countryPickerContainerView.isHidden = false
        default:
            countryPickerViewController?.type = .empty
            countryPickerContainerView.isHidden = false
        }
    }
    
    @IBAction func clearWeightClicked() {
        weightTextField.text = ""
    }
    
    @IBAction func callNextStepClicked(_ sender: Any) {
        print("------- click next step --------")
        if self.weightTextField.text?.isEmpty == true {
            _ = self.weightTextField.delegate?.textFieldShouldReturn!(self.weightTextField)
        } else {
            if !self.containsColissimo {
                if presenter?.calculatePrice(weight: weightTextField.text ?? "") == true {
                    ColissimoManager.sharedManager.delegate?.homeViewDidCallStep2With()
                }
            } else {
                let alertController = UIAlertController(title: "Vous avez déjà un colissimo dans votre panier. Vous devez valider et payer pour pouvoir en réaliser un autre", message: "", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Accéder au panier", style: .default, handler: { _ in
                    print("GO TO CART")
                    CATransaction.begin()
                    let completion: (() -> Void) = {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowCartColissimo"), object: nil)
                    }
                    CATransaction.setCompletionBlock(completion)
                    self.dismiss(animated: true, completion: { })
                    CATransaction.commit()
                    
                }))
                
                alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(ColissimoHomeViewController.doneButtonAction))
        doneButton.tintColor = .black
        doneToolbar.items = [flexibleSpace, doneButton]
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        self.weightTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        //        self.weightTextField.resignFirstResponder()
        self.weightTextField.delegate = self
        _ = self.weightTextField.delegate?.textFieldShouldReturn!(self.weightTextField)
    }
}

// MARK: - ColissimoHomeDelegate
extension ColissimoHomeViewController: ColissimoHomeDelegate {
    func showErrorView(_ text: String) {
        let weight = presenter?.getTextsForWeight()
        weightTextField.text = weight?.0
        castWeightLabel.text = weight?.1
        
        if let errorView = ErrorMessageView.instanceFromNib() as? ErrorMessageView {
            let originY = self.calculateTopDistance()
            errorView.addInView(self.view, message: text, fromY: originY)
        }
    }
    
    func priceDidChange(price: String) {
        priceWaitingAvtivityIndicator.isHidden = true
        resultPriceLabel.isHidden = false
        resultPriceLabel.text = price
        
        let weight = presenter?.getTextsForWeight()
        weightTextField.text = weight?.0
        castWeightLabel.text = weight?.1
        
    }
    
    func setArrivalCountry(country: String) {
        priceWaitingAvtivityIndicator.isHidden = false
        resultPriceLabel.isHidden = true
        
        countryPickerContainerView.isHidden = true
        arrivalCountryLabel.text = country
    }
    
    func setDepartureCountry(country: String) {
        priceWaitingAvtivityIndicator.isHidden = false
        resultPriceLabel.isHidden = true
        
        countryPickerContainerView.isHidden = true
        departureCountryLabel.text = country        
    }
    
    func dismissPickerView() {
        countryPickerContainerView.isHidden = true
    }
    
    func setUpDefaultValues() {
        //
        departureCountryLabel.text = ColissimoData.shared.selectedSenderAddress?.name ?? presenter?.getTextForDepartureCountry()
        arrivalCountryLabel.text = ColissimoData.shared.selectedReceiverAddress?.name ?? presenter?.getTextForArrivalCountry()
        let weight = presenter?.getTextsForWeight()
        weightTextField.text = weight?.0
        castWeightLabel.text = weight?.1
        
        priceWaitingAvtivityIndicator.isHidden = true
        resultPriceLabel.isHidden = false
        resultPriceLabel.text = presenter?.getTextForPrice()
    }
    
    func setAdvantageCells(cells: [UITableViewCell]) {
        advantageCells = cells
        self.tableView.reloadData()
    }
    
    func setGuideCells(cells: [UITableViewCell]) {
        guideCells = cells
        self.tableView.reloadData()
    }
    
    func setGuideS(guides: [HomeGuideViewModel]) {
        self.guides = guides
    }
    
    func setPageViewCollectionImages(images: [UIImage]) {
        self.pageViewCollection.configureCell(items: images)
    }
}

// MARK: - UITableViewDataSource || UITableViewDelegate
extension ColissimoHomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return guideCells.count
        }
        else if section == 1 {
            return advantageCells.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = guideCells[indexPath.row] as? ColissimoHomeAddButtonCell {
                cell.delegate = self
                cell.nextStepButton.setTitle(LocalizedColissimoUI(key: "k_home_send_button_key"), for: .normal)
                cell.backgroundColor = UIColor.white
                self.enableButton(cell.nextStepButton, isEnabled: self.isDataLoaded)
                return cell
            }
            return guideCells[indexPath.row]
        }
        else if indexPath.section == 1 {
            if let cell = advantageCells[indexPath.row] as? ColissimoHomeAddButtonCell {
                cell.delegate = self
                cell.nextStepButton.setTitle(LocalizedColissimoUI(key: "k_home_send_button_key"), for: .normal)
                cell.backgroundColor = UIColor(red: 249/255, green: 245/255, blue: 241/255, alpha: 1)
                self.enableButton(cell.nextStepButton, isEnabled: self.isDataLoaded)
                return cell
            }
            return advantageCells[indexPath.row]
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.didSelectCell(tableView: tableView, indexPath: indexPath)
    }
}

extension ColissimoHomeViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var currentText = textField.text
        currentText = currentText?.replacingOccurrences(of: " Kg", with: "")
        currentText = currentText?.replacingOccurrences(of: ".", with: ",")
        textField.text = currentText
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //1- Weight validate
        _ = presenter?.calculatePrice(weight: textField.text ?? "")
        
        priceWaitingAvtivityIndicator.startAnimating()
        priceWaitingAvtivityIndicator.isHidden = false
        resultPriceLabel.isHidden = true
        let weight = presenter?.getTextsForWeight()
        weightTextField.text = weight?.0
        castWeightLabel.text = weight?.1
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
}

extension ColissimoHomeViewController: ColissimoHomeAddButtonCellDelegate {
    func callStep1Viewcontroller() {
        if !self.containsColissimo {
            ColissimoManager.sharedManager.delegate?.homeViewDidCallStep1With()
        } else {
            let alertController = UIAlertController(title: "Vous avez déjà un colissimo dans votre panier. Vous devez valider et payer pour pouvoir en réaliser un autre", message: "", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Accéder au panier", style: .default, handler: { _ in
                print("GO TO CART")
                CATransaction.begin()
                let completion: (() -> Void) = {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowCartColissimo"), object: nil)
                }
                CATransaction.setCompletionBlock(completion)
                self.dismiss(animated: true, completion: { })
                CATransaction.commit()
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
