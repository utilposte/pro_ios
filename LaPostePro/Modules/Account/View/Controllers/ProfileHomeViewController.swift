//
//  ProfileHomeViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 14/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import ActiveLabel
import UIKit

class ProfileHomeViewController: UIViewController {
    enum ProfileHomeType {
        case personal
        case company
    }
    
    enum ActionType {
        case password
        case email
    }
    
    enum ProfileHome {
        case section(title: String, closure: (() -> ())?)
        case info(title: String, value: String)
        case action(image: UIImage, title: String, action: ActionType)
        case delete
        case condition
        case detail(expanded: Bool)
        
        var cellIdentifier: String {
            switch self {
            case .section:
                return "SectionTableViewCellID"
            case .info:
                return "InfoProfileTableViewCellID"
            case .action:
                return "ActionTableViewCellID"
            case .delete:
                return "DeleteAccountTableViewCellID"
            case .condition:
                return "ConditionProfileTableViewCellID"
            case .detail:
                return "ConditionDetailsTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .action:
                return 80
            case .delete:
                return 70
            default:
                return UITableViewAutomaticDimension
            }
        }
    }
    
    // MARK: IBoutlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var InfoSegmentedControl: UISegmentedControl!
    @IBOutlet var userInfoLabel: UILabel!
    
    @IBOutlet var companyLabel: UILabel!
    
    // MARK: Variables
    
    var profileHomeType: ProfileHomeType = .personal
    var sections = [ProfileHome]()
    var conditionExpanded: Bool = false
    var dataForm: UpdateFormModel?
    var needToGoBack = false
    var needToOpenDetails = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companyLabel.text = UserAccount.shared.customerInfo?.companyName
        self.userInfoLabel.text = "\(String(describing: UserAccount.shared.customerInfo?.firstName ?? "")) \(String(describing: UserAccount.shared.customerInfo?.lastName ?? ""))"
        self.setupTitleNavigationBar(backEnabled: true, title: "Votre profil", showCart: false)
        self.profileHomeType = .personal
        self.navigationController?.navigationBar.isHidden = false
        self.setupTableView()
        
        if self.InfoSegmentedControl.selectedSegmentIndex == 0 {
            self.setupPersonalInfos()
        } else {
            self.setupEnterpriseInfos()
        }
        
        // Send weborama tag
        let ccuId = UserAccount.shared.customerInfo?.displayUid?.sha256() ?? ""
        PixelWeboramaManager().sendWeboramaTag(tagToSend: Constants.accountWeboramaKey, ccuIDCryptedValue: ccuId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.companyLabel.text = UserAccount.shared.customerInfo?.companyName
        self.userInfoLabel.text = "\(String(describing: UserAccount.shared.customerInfo?.firstName ?? "")) \(String(describing: UserAccount.shared.customerInfo?.lastName ?? ""))"
        self.setupTitleNavigationBar(backEnabled: true, title: "Votre profil", showCart: false)
        
        if self.needToGoBack {
            self.needToGoBack = false
            self.navigationController?.popViewController(animated: true)
            
//            if let errorView = TopMessageView.instanceFromNib() as? TopMessageView {
//                if let window = UIApplication.shared.windows.first {
//                    let originY =  UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0)
//                    let error = "Votre demande a été prise en compte et sera traitée sous 30 jours."
//                    errorView.addInView(window, message: error, fromY: originY)
//                }
//            }
            
            return
        }
        
        if self.InfoSegmentedControl.selectedSegmentIndex == 0 {
            self.setupPersonalInfos()
            
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kInformations,
                                                                 chapter1: TaggingData.kYourProfile,
                                                                 chapter2: TaggingData.kPersonal,
                                                                 level2: TaggingData.kAccountLevel)
            
        } else {
            self.setupEnterpriseInfos()
            
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kInformations,
                                                                 chapter1: TaggingData.kYourProfile,
                                                                 chapter2: TaggingData.kEntreprise,
                                                                 level2: TaggingData.kAccountLevel)
        }
        self.tableView.reloadData()
        
        if needToOpenDetails {
            needToOpenDetails = false
            let viewController = R.storyboard.account.companyInformationViewControllerID()!
            viewController.formType = .update
            viewController.formPart = .enterprise
            viewController.dataForm = UserAccount.shared.userAccountToDataModel()
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    internal func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    private func setupPersonalInfos() {
        self.sections = [.section(title: "Mes informations", closure: nil),
                         .info(title: "Civilité", value: UserAccount.shared.customerInfo?.titleCode == "mrs" ? "Mme." : "M."),
                         .info(title: "Nom", value: UserAccount.shared.customerInfo?.lastName ?? "-"),
                         .info(title: "Prénom", value: UserAccount.shared.customerInfo?.firstName ?? "-"),
                         .info(title: "Téléphone", value: UserAccount.shared.customerInfo?.phone ?? "-"),
                         .info(title: "Adresse e-mail pro", value: UserAccount.shared.customerInfo?.displayUid ?? "-"),
                         .action(image: R.image.ic_btn_email()!, title: "Modifier l'adresse e-mail", action: .email),
                         .action(image: R.image.ic_btn_mdp()!, title: "Modifier le mot de passe", action: .password), .delete, .condition]
    }
    
    private func setupEnterpriseInfos() {
        self.sections = [.section(title: "Mon entreprise", closure: nil),
                         .info(title: "Raison sociale", value: UserAccount.shared.customerInfo?.companyName ?? "-"),
                         .info(title: "Type de société", value: UserAccount.shared.customerInfo?.companyTypeName ?? "-"),
                         .info(title: "SIRET", value: UserAccount.shared.customerInfo?.siret ?? "-"),
                         .info(title: "N° Client (Coclico)", value: UserAccount.shared.customerInfo?.coclicoClientNumber ?? "-"),
                         .info(title: "TVA intracommunautaire", value: UserAccount.shared.customerInfo?.tvaIntra ?? "-"),
                         .info(title: "RNA", value: UserAccount.shared.customerInfo?.rna ?? "-"),
                         .section(title: "Adresse postale", closure: nil),
                         .info(title: "Service", value: "-"),
                         .info(title: "Bâtiment - Immeuble", value: "-"),
                         .info(title: "N° et libellé de la voie", value: UserAccount.shared.customerInfo?.defaultAddress?.line2 ?? "-"),
                         .info(title: "Lieu-dit ou BP", value: "-"),
                         .info(title: "Code postal", value: UserAccount.shared.customerInfo?.defaultAddress?.postalCode ?? "-"),
                         .info(title: "Localité", value: UserAccount.shared.customerInfo?.defaultAddress?.town ?? "-"),
                         .info(title: "Pays", value: UserAccount.shared.customerInfo?.defaultAddress?.country?.name ?? ""),
                         .delete,
                         .condition ]
    }
    
    @IBAction func segmentedControlTapped(_ sender: Any) {
        if self.profileHomeType == .personal {
            self.profileHomeType = .company
            self.setupEnterpriseInfos()
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kInformations,
                                                                 chapter1: TaggingData.kYourProfile,
                                                                 chapter2: TaggingData.kEntreprise,
                                                                 level2: TaggingData.kAccountLevel)
        } else {
            self.profileHomeType = .personal
            self.setupPersonalInfos()
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kInformations,
                                                                 chapter1: TaggingData.kYourProfile,
                                                                 chapter2: TaggingData.kPersonal,
                                                                 level2: TaggingData.kAccountLevel)
        }
        
        self.tableView.reloadData()
    }
}

extension ProfileHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.row]
        switch item {
        case .section(let title, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! SectionTableViewCell
            cell.setupCell(title: title)
            cell.delegate = self
            return cell
        case .info(let title, let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! InfoProfileTableViewCell
            cell.setupCell(info: title, value: value)
            return cell
        case .action(let image, let title, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ActionTableViewCell
            cell.setupCell(image: image, title: title)
            return cell
        case .condition:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ConditionProfileTableViewCell
            cell.setupCell()
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! DeleteAccountTableViewCell
            cell.delegate = self
            return cell
        case .detail(let expanded):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ConditionDetailsTableViewCell
            cell.setupCell(expanded: expanded)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.sections[indexPath.row]
        switch item {
        case .detail:
            self.conditionExpanded = !self.conditionExpanded
            self.tableView.reloadData()
        case .action(_, _, let type):
            switch type {
            case .email:
                let viewController = R.storyboard.account.updateEmailViewControllerID()!
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            case .password:
                let viewController = R.storyboard.account.updatePasswordViewControllerID()!
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.sections[indexPath.row]
        return item.rowHeight
    }
}

extension ProfileHomeViewController: SectionTableViewCellDelegate {
    func buttonDidTapped(isAdress: Bool, cell: SectionTableViewCell) {
        switch self.profileHomeType {
        case .personal:
            let viewController = R.storyboard.account.firstPartViewControllerID()!
            viewController.formType = .update
            self.navigationController?.pushViewController(viewController, animated: true)
        case .company:
            let viewController = R.storyboard.account.companyInformationViewControllerID()!
            viewController.formType = .update
            if isAdress {
                viewController.formPart = .address
            } else {
                viewController.formPart = .enterprise
            }
            viewController.dataForm = UserAccount.shared.userAccountToDataModel()
            
            if isAdress == true, UserAccount.shared.customerInfo?.isCertified() == true {
                showContactAlert()
            }
            else {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func showContactAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Veuillez contacter le service client pour la modification de votre adresse", message: nil
        , dismissActionTitle: "Annuler") { }
        let alertAction: UIAlertAction = UIAlertAction(title: "Appeler", style: .default) { (action) in
            let number: String = "0969321321 "
            if let url = URL(string: "tel://\(number)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true) { }
    }
}

extension ProfileHomeViewController: DeleteAccountTableViewCellDelegate {
    func deleteAccount() {
        let profileType = self.profileHomeType == .personal ? TaggingData.kPersonal : TaggingData.kEntreprise
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kSupprimer,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kYourProfile,
                                                              chapter2: profileType,
                                                              level2: TaggingData.kAccountLevel)
        
//        let webView =
        needToGoBack = true
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! WebViewController
        vc.url = WebViewURL.contact3.rawValue
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
