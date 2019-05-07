//
//  CLRecapViewController.swift
//  Pods
//
//  Created by LaPoste on 07/12/2018.
//

import UIKit
import LPColissimo

struct Recap {
    var title: String?
    var description: String?
    var image: String?
    var recapType: CLRecapType?
}

enum CLRecapType {
    case colissimo // First Step
    case destinations // Second Step
    case weight // Third Step
    case sender // Fourth Step
    case receiver // Fifth Step
    case deposit // Sixth Step
    case delivery // Sixth Step
}

public class CLRecapViewController: UIViewController {
    
    var availableSections : [RecapTableView] = []
    var router = CLRouter()
    
    enum RecapTableView {
        
        case colisInfo(recap: Recap)
        case detail(recap: Recap)
        case address(title: String, description: String, additionnal: String, image: String, recapType: CLRecapType)
        case price(price: Double)
        case button
        
        var cellIdentifier: String {
            switch self {
            case .detail, .address, .colisInfo:
                return "CLRecapCell"
            case .button:
                return "CLRecapButtonCellID"
            case .price:
                return "CLRecapPriceTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .address, .colisInfo, .detail, .price:
                return UITableViewAutomaticDimension
            case .button:
                return 130
            }
        }
    }
    
    @IBOutlet weak var headerView: CLHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()        
        self.headerView.setup(title: "Récapitulatif", icon: "ic_step_6.png", step: nil)
        self.setupTableView()
        self.setupSection()
        self.setFooterView()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE7Recapitulatif,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
        ColissimoDataCopy.shared.copy(from: ColissimoData.shared)
    }
    
    func setFooterView() {
        if let footer = ColissimoManager.sharedManager.delegate?.getFooterView() {
            let view: UIView = UIView(frame: footer.bounds)
            view.addSubview(footer)
            self.tableView.tableFooterView = view
        }
    }
    
    func setupTableView() {
        self.tableView.allowsSelection = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupSection() {
        
        // COLIS INFO
        if let weight = ColissimoData.shared.weight, let receiverAddress = ColissimoData.shared.receiverAddress {
            let colisInfoTitle = "Colissimo \(ColissimoData.shared.dimension.title) - \(String(format: "%.3f", weight)) kg"
            
            var civility = ""
            if receiverAddress.civility.lowercased() == "mr" {
                civility = "Mr"
            } else {
                civility = "Mme"
            }
            
            var colisInfoDescription = ""
            if receiverAddress.firstName != "" && receiverAddress.lastName != "" {
                colisInfoDescription = "Pour \(civility) \(receiverAddress.firstName) \(receiverAddress.lastName)"
                
            } else {
                colisInfoDescription = ""
            }
            
            self.availableSections.append(.colisInfo(recap: Recap(title: colisInfoTitle, description: colisInfoDescription, image: ColissimoData.shared.dimension.image, recapType: CLRecapType.colissimo)))
        }
        
        // COUNTRY
        if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress, let selectedReceiverAddress = ColissimoData.shared.selectedReceiverAddress {
            self.availableSections.append(.detail(recap: Recap(title: "DÉPART - ARRIVÉE", description: "\(String(describing: selectedSenderAddress.name ?? ""))\n\(String(describing: selectedReceiverAddress.name ?? ""))", image: "ic_recap_depart-arrivee", recapType: CLRecapType.destinations)))
        }
        
        // WEIGHT
        if let weight = ColissimoData.shared.weight {
            self.availableSections.append(.detail(recap: Recap(title: "POIDS", description: "\(String(format: "%.3f", weight)) kg", image: "ic_recap_poids", recapType: CLRecapType.weight)))
        }
        
        // SENDER
        if let senderAddress = ColissimoData.shared.senderAddress {
            if senderAddress.email.isEmpty {
                self.availableSections.append(.address(title: "EXPÉDITEUR", description: senderAddress.toString(), additionnal: "", image: "ic_recap_expediteur", recapType: CLRecapType.sender))
            } else {
                self.availableSections.append(.address(title: "EXPÉDITEUR", description: senderAddress.toString(), additionnal: "\nSuivi du colis: \(senderAddress.email)", image: "ic_recap_expediteur", recapType: CLRecapType.sender))
            }
        }
        
        // RECEIVER
        if let receiverAddress = ColissimoData.shared.receiverAddress {
            self.availableSections.append(.detail(recap: Recap(title: "DESTINATAIRE", description: receiverAddress.toString(), image: "ic_recap_destinataire", recapType: CLRecapType.receiver)))
        }
        
        // ENVOI COLIS
        if let depositMode = ColissimoData.shared.depositMode {
            var depositModeString = ""
            if depositMode == "BUREAU_POSTE" {
                depositModeString = "En bureau de poste"
            } else {
                depositModeString = "En boite aux lettres"
            }
            
            self.availableSections.append(.detail(recap: Recap(title: "L'ENVOI DE VOTRE COLIS", description: depositModeString, image: "ic_recap_mode-depot", recapType: CLRecapType.deposit)))
        }
        
        
        // DELIVERY
        
        var deliveryModeString = ""
        if let deliveryMode = ColissimoData.shared.deliveryMode {
            if deliveryMode == "BOITE_LETTRE" {
                deliveryModeString = "En boite aux lettres"
            } else {
                deliveryModeString = "En main propre"
            }
            
            
            self.availableSections.append(.detail(recap: Recap(title: "MODE DE LIVRAISON", description: deliveryModeString, image: "ic_recap_mode-livraison@3x", recapType: CLRecapType.delivery)))
        }
        
        if let price = ColissimoData.shared.price {
            self.availableSections.append(.price(price: price))
        }
        
        self.availableSections.append(.button)
        self.tableView.reloadData()
    }
    
    func convertDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "Fr-fr")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let _date = date else { return "" }
        return dateFormatter.string(from: _date)
    }
}

extension CLRecapViewController : UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableSections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.availableSections[indexPath.row]
        
        switch item {
        case .detail(let recap):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CLRecapCell
            cell.setupDetail(recap: recap)
            return cell
        case .address(let title, let description, let additionnal, let image, _):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CLRecapCell
            cell.setupAddressCell(title: title, description: description, additionnal: additionnal, image: image)
            return cell
        case .colisInfo(let recap):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CLRecapCell
            cell.setupColisInfos(recap: recap)
            return cell
        case .price(let price):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CLRecapPriceTableViewCell
            cell.setupCell(price: price)
            return cell
        case .button:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CLRecapButtonCell
            cell.delegate = self
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.availableSections[indexPath.row].rowHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        
        let item = self.availableSections[indexPath.row]        
        
        switch item {
        case .detail(let recap), .colisInfo(let recap):
            switch recap.recapType {
            case .colissimo?, .destinations?:
                self.router.popTo(step: .first, navigation: navigationController)
            case .weight?:
                self.router.popTo(step: .third, navigation: navigationController)
            case .receiver?:
                self.router.popTo(step: .fifth, navigation: navigationController)
            case .deposit?, .delivery?:
                self.router.popTo(step: .sixth, navigation: navigationController)
            default:
                break
            }
        case .address(let title, let description, let additionnal, let image, let recap):
            switch recap {
            case .sender:
                self.router.popTo(step: .fourth, navigation: navigationController)
            default:
                break
            }
        default:
            break
        }
    }
}

extension CLRecapViewController : CLRecapButtonCellDelegate{
    
    func buttonDidTapped() {
        LoadingOverlay.shared.showOverlay(view: self.view)
        guard let senderAddress = ColissimoData.shared.senderAddress else { return }
        guard let receiverAddress = ColissimoData.shared.receiverAddress else { return }
        guard let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress else { return }
        guard let selectedReceiverAddress = ColissimoData.shared.selectedReceiverAddress else { return }
        guard let arrivalCountry = ColissimoData.shared.arrivalCountry else { return }
        //        guard let data = self.data else { return }
        
        var dict: [String: Any] = [String: Any]()
        var receiverIsPro = false
        
        if let receiverAddress = ColissimoData.shared.receiverAddress, receiverAddress.companyName == "" {
            receiverIsPro = false
        } else {
            receiverIsPro = true
        }
        
        let isAppPro = true
        
        var colisRegime = ""
        let departureCountries = ["ad", "fr", "gp", "gf", "re", "mq", "yt", "mc", "bl", "mf", "pm"]
        if departureCountries.contains(arrivalCountry) {
            colisRegime = "NATIONAL"
        } else {
            colisRegime = "INTERNATIONNAL"
        }
        
        if let dateDepot = ColissimoData.shared.dateDepot {
            if dateDepot == "" {
                let currentDate = Date()
                let currentDateFormatter = DateFormatter()
                currentDateFormatter.dateFormat = "dd/MM/yyyy"
                ColissimoData.shared.dateDepot = self.convertDate(date: currentDateFormatter.string(from: currentDate))
            } else {
                ColissimoData.shared.dateDepot = self.convertDate(date: dateDepot)
            }
        }
        
        var general = [
            "deliveryAddress": [
                "title": receiverAddress.civility,
                "titleCode": receiverAddress.civility,
                "firstName": receiverAddress.firstName,
                "lastName": receiverAddress.lastName,
                "companyName": receiverAddress.companyName,
                "line1": receiverAddress.civility,
                "line2": receiverAddress.street,
                "town": receiverAddress.locality.replacingOccurrences(of: "-", with: " "),
                "postalCode": receiverAddress.postalCode,
                "phone": receiverAddress.phone,
                "email": receiverAddress.email,
                
                "building": "",
                "appartment": "",
                "pobox": "",
                "pro": "\(receiverIsPro)",
                "region": "",
                
                "country": [
                    "isocode": receiverAddress.countryIsoCode.lowercased(),
                    "name": receiverAddress.countryName
                ],
                
                "shippingAddress": false,
                "visibleAddressBook": false,
                "streetNumber": "\(receiverAddress.street)",
            ],
            
            "expediteurAddress":
                [
                    "title": senderAddress.civility,
                    "titleCode": senderAddress.civility,
                    "firstName": senderAddress.firstName,
                    "lastName": senderAddress.lastName,
                    "companyName": senderAddress.companyName,
                    "line1": senderAddress.civility,
                    "line2": senderAddress.street,
                    "town": senderAddress.locality.replacingOccurrences(of: "-", with: " "),
                    "postalCode": senderAddress.postalCode,
                    "phone": senderAddress.phone,
                    "email": senderAddress.email,
                    
                    "building": "",
                    "appartment": "",
                    "pobox": "",
                    "pro": "\(isAppPro)",
                    "region": "",
                    
                    "country": [
                        "isocode": senderAddress.countryIsoCode.lowercased(),
                        "name": senderAddress.countryName
                    ],
                    "shippingAddress": false,
                    "visibleAddressBook": false,
                    //                    "streetNumber": senderAddress.formattedAddress,
                    "streetNumber": "\(senderAddress.street)",
            ],
            
            "TotalNetPriceColis": [
                "currencyIso": "EUR",
                "value": ColissimoData.shared.price ?? 0,
                "priceType": "BUY",
                "formattedValue": "\(ColissimoData.shared.price ?? 0) EUR"
            ],
            
            "totalNetPriceAssurance": [
                "currencyIso": "EUR",
                "value": ColissimoData.shared.totalNetPriceAssurance ?? 0,
                "priceType": "BUY",
                "formattedValue": "\(ColissimoData.shared.totalNetPriceAssurance ?? 0) EUR"
            ],
            
            "totalNetPriceSurcout": [
                "currencyIso": "EUR",
                "value": ColissimoData.shared.totalNetPriceSurcout ?? 0,
                "priceType": "BUY",
                "formattedValue": "\(ColissimoData.shared.totalNetPriceSurcout ?? 0) EUR"
            ],
            
            ] as [String : Any]
        
        general["avecAssurance"] = ColissimoData.shared.totalNetPriceAssurance == 0 ? false : true
        general["avecSiganture"] = ColissimoData.shared.withSignature ?? false
        general["toIsoCode"] = selectedReceiverAddress.isocode
        general["fromIsoCode"] = selectedSenderAddress.isocode
        general["colisRegime"] = colisRegime
        general["typeColis"] = ColissimoData.shared.dimension.title.uppercased() == "TUBE" ? "ROULEAU" : ColissimoData.shared.dimension.title.uppercased()
        general["modeDepot"] = ColissimoData.shared.depositMode ?? ""
        general["modeLivraison"] = ColissimoData.shared.deliveryMode ?? ""
        general["dateDepot"] = ColissimoData.shared.dateDepot ?? "" // NEED TO FORMAT DATE
        general["emailDestinataire"] = receiverAddress.email
        general["refColis"] = ""
        general["poidsColis"] = ColissimoData.shared.weight ?? 0
        general["indemnitePlus"] = ColissimoData.shared.indemnitePlus ?? false
        general["typeSupplColis"] = ColissimoData.shared.dimension.title.uppercased() == "TUBE" ? "ROULEAU" : ColissimoData.shared.dimension.title.uppercased()
        general["insuredValue"] = ColissimoData.shared.insuredValue ?? 0
        general["id"] = ColissimoData.shared.productCodeColis ?? ""
        general["labelAssuranceColis"] = ""
        general["livraisonAvecSignature"] = ColissimoData.shared.withSignature ?? false
        general["nameColisFavoris"] = ""
        general["region"] = ""
        general["suiviEmail"] = ["VEILLE_LIVRAISON"]
        
        // JSON FOR CUSTOM FORMALITIES
        var formalitesDouaniereDict: [String: Any] = [String: Any]()
        
        formalitesDouaniereDict["natureEnvoi"] = ["code": ColissimoData.shared.formalityChoice?.code ?? "", "nom": ColissimoData.shared.formalityChoice?.name ?? ""]
        formalitesDouaniereDict["returnReason"] = ColissimoData.shared.returnReason
        
        var formaliteDict = [[String: Any]]()
        if !ColissimoData.shared.articles.isEmpty {
            // SELL ARTICLE CASE
            for article in ColissimoData.shared.articles {
                formaliteDict.append(["descriptionArticle": article.description ?? "", "poidsNet": article.weight ?? 0, "quantite": article.quantity ?? 0, "valeurUnitaire": article.unitValue ?? 0])
            }
            
            //            general["contenusColis"] = formaliteDict
            formalitesDouaniereDict["contenusColis"] = formaliteDict
            general["formalitesDouaniere"] = formalitesDouaniereDict
        } else if !ColissimoData.shared.sellArticles.isEmpty {
            // NORMAL ARTICLE CASE
            for sellArticle in ColissimoData.shared.sellArticles {
                formaliteDict.append(["descriptionArticle": sellArticle.description ?? "", "poidsNet": sellArticle.weight ?? 0, "quantite": sellArticle.quantity ?? 0, "valeurUnitaire": sellArticle.unitValue ?? 0, "paysOrigine": ["isocode": sellArticle.originCountry?.isocode] ?? ["" : ""], "numeroTarifaire": sellArticle.tarifSH ?? ""])
            }
            //            general["contenusColis"] = formaliteDict
            formalitesDouaniereDict["contenusColis"] = formaliteDict
            general["formalitesDouaniere"] = formalitesDouaniereDict
        } else if !ColissimoData.shared.otherArticles.isEmpty {
            for otherArticle in ColissimoData.shared.otherArticles {
                formaliteDict.append(["descriptionArticle": otherArticle.description ?? "", "poidsNet": otherArticle.weight ?? 0, "quantite": otherArticle.quantity ?? 0, "valeurUnitaire": otherArticle.unitValue ?? 0])
            }
            //            general["contenusColis"] = formaliteDict
            formalitesDouaniereDict["contenusColis"] = formaliteDict
            general["formalitesDouaniere"] = formalitesDouaniereDict
        }
        dict = ["listColissimo" :[general]]
        print(String(data: try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted), encoding: .utf8)!)
        
        ColissimoAPIClient.sharedInstance.addToCart(user: senderAddress.email, fields: "FULL", parameters: dict) { (cartResult, error) in
            LoadingOverlay.shared.hideOverlayView()
            if let _error = error {
                let alertError = UIAlertController.init(title: "Erreur", message: "Une erreur est survenue", preferredStyle: .alert)
                alertError.addAction(UIAlertAction.init(title: "Fermer", style: .cancel, handler: nil))
                self.navigationController?.present(alertError, animated: true, completion: nil)
            } else {
                if let _cartResult = cartResult {
                    // PUT REDIRECT CONFIRMATION VIEW CONTROLLER CODE HERE
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                    ColissimoManager.sharedManager.delegate?.redirectToCart()
                } else {
                    let alertError = UIAlertController.init(title: "Erreur", message: "Une erreur est survenue", preferredStyle: .alert)
                    alertError.addAction(UIAlertAction.init(title: "Fermer", style: .cancel, handler: nil))
                    self.navigationController?.present(alertError, animated: true, completion: nil)
                }
            }
        }
    }
}

public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator.activityIndicatorViewStyle = .white
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
