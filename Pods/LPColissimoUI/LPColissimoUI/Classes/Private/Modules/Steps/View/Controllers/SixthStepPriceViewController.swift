//
//  SixthStepPriceViewController.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 26/11/2018.
//

import UIKit
import LPColissimo

public class SixthStepPriceViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    var isNational = true
    
    // MARK: Enum
    enum SixthPriceStep {
        case title(title: NSMutableAttributedString)
        case price(firstTitle: String, secondTitle: String, type: SixthPrice)
        
        var cellIdentifier: String {
            switch self {
            case .title:    return "SixthPriceTableViewCellID"
            case .price:    return "DualSixthPriceTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .price:
                return 30
            case .title:
                return UITableViewAutomaticDimension
            }
        }
    }
    
    // MARK: Variables
    var availableSection: [SixthPriceStep] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupColisRegime()
        self.setupTableView()
        self.setupSection()
        self.setupCloseButton()
        self.setFooterView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kPopinTarifsIndemnisation,
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
    
    private func setupColisRegime() {
        guard let arrivalCountry = ColissimoData.shared.arrivalCountry else { return }
        
        let departureCountries = ["ad", "fr", "gp", "gf", "re", "mq", "yt", "mc", "bl", "mf", "pm"]
        if departureCountries.contains(arrivalCountry) {
            self.isNational = true
        } else {
            self.isNational = false
        }
    }
    
    private func setupTableView() {
        self.tableView.separatorColor = .white
        self.tableView.clipsToBounds = true
        self.tableView.layer.masksToBounds = true
        self.tableView.layer.cornerRadius = 10
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupCloseButton() {
        self.closeButton.setBackgroundImage(ColissimoHomeServices.loadImage(name: "IconCloseWhite.png"), for: .normal)
    }
    
    private func setupSection() {
        
        var title = ""
        
        if self.isNational {
            title = "Envoi Colissimo France et Outre-mer"
        } else {
            title = "Envoi Colissimo International"
        }

        let envoiAS = NSMutableAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lpOrange, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        
        self.availableSection.append(.title(title: envoiAS))
        
        let indemnisationAS = NSMutableAttributedString(string: "Indemnisation", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        
        self.availableSection.append(.title(title: indemnisationAS))
        
        let signatureAS = NSMutableAttributedString(string: "• Votre Colissimo est remis contre signature.", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lpGrey, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .light)])
        
        self.availableSection.append(.title(title: signatureAS))
        
        let perteAS = NSMutableAttributedString(string: "• En cas de perte ou d'avarie, vous bénéficiez d'une indemnisation adaptée à la valeur de votre envoi.", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lpGrey, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .light)])
        
        self.availableSection.append(.title(title: perteAS))
        
        var valeur = ""
        
        if self.isNational {
            valeur = "Valeur de l'objet: jusqu'à 200€"
        } else {
            valeur = "Valeur de l'objet: de 0,01 € à 1000€"
        }
        
        let valeurAS = NSMutableAttributedString(string: valeur, attributes: [NSAttributedStringKey.foregroundColor : UIColor.lpGrey, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        let recommandationAS = NSMutableAttributedString(string: "(Recommandation)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lpGrey, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        
        let valeurRecommandationAS = NSMutableAttributedString(attributedString: valeurAS)
        valeurRecommandationAS.append(recommandationAS)
        
        self.availableSection.append(.title(title: valeurRecommandationAS))
        
        var regime = ""
        if self.isNational {
            regime = "NationalInsurances"
        } else {
            regime = "InternationalInsurances"
        }
        
        if let objects = UserDefaults.standard.value(forKey: regime) as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [CLInsurance] {
                self.availableSection.append(.price(firstTitle: "Indemnisation", secondTitle: "Tarif net de l'option", type: .title))
                let objectsDecodedSorted = objectsDecoded.sorted(by: { $0.max < $1.max })
                for object in objectsDecodedSorted {
                    if !self.isNational {
                        self.availableSection.append(.price(firstTitle: "jusqu'à \(object.max)€", secondTitle: "\(object.price)€", type: .info))
                    } else {
                        if object.max < 200 {
                            self.availableSection.append(.price(firstTitle: "jusqu'à \(object.max)€", secondTitle: "\(object.price)€", type: .info))
                        } else if object.max == 200 {
                            self.availableSection.append(.price(firstTitle: "jusqu'à \(object.max)€", secondTitle: "\(object.price)€", type: .info))
                            
                            self.availableSection.append(.title(title: NSMutableAttributedString()))
                            
                            let valeurMoreAS = NSMutableAttributedString(string: "Valeur de l'objet: au-dela de 200€ et jusqu'à 1000€", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lpGrey, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
                            let justificatifAS = NSMutableAttributedString(string: "(sur présentation d'un justificatif)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lpGrey, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .light)])
                            
                            let valeurJustificatifAS = NSMutableAttributedString(attributedString: valeurMoreAS)
                            valeurJustificatifAS.append(justificatifAS)
                            
                            self.availableSection.append(.title(title: valeurJustificatifAS))
                            
                            self.availableSection.append(.title(title: NSMutableAttributedString()))
                            self.availableSection.append(.price(firstTitle: "Indemnisation", secondTitle: "Tarif net de l'option", type: .title))
                        } else if object.max > 200 {
                            self.availableSection.append(.price(firstTitle: "jusqu'à \(object.max)€", secondTitle: "\(object.price)€", type: .info))
                        }
                    }                    
                }
            }
        } else {
            print("an error occured")
        }
         
        self.tableView.reloadData()
    }
    
    // MARK: User Interaction
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SixthStepPriceViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableSection.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.availableSection[indexPath.row]
        switch item {
        case .title(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! SixthPriceTableViewCell
            cell.setupCell(title: title)
            return cell
        case .price(let firstTitle, let secondTitle, let type):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! DualSixthPriceTableViewCell
            cell.setupCell(firstTitle: firstTitle, secondTitle: secondTitle, type: type)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.availableSection[indexPath.row].rowHeight
    }
}
