//
//  AccountHomeViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 05/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM
import RealmSwift
import LPColissimo
import LPColissimoUI

enum AccountHomeEntries {
    case detailed
    case certification
    case chorus
    case rubric(title: String)
    case disconnect
    
    var rowHeight: CGFloat {
        switch self {
        case .detailed:
            return 138
        case .certification:
            if UserAccount.shared.customerInfo?.showCertified() == true {
                return 20
            }
            return 84
        case .rubric:
            return 78
        case .disconnect:
            return 80
        case .chorus:
            return UITableViewAutomaticDimension
        }
    }
}

class AccountHomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var entrepriseNameLabel: UILabel!
    @IBOutlet weak var certificationLabel: UILabel!
    @IBOutlet weak var welcomingLabel: UILabel!
    @IBOutlet weak var certificationImageView: UIImageView!
    
    private enum AccountHomeChorusStatus {
        case noChorus
        case noServiceCodeChorus
        case noNeedChorus
    }
    
    var headings: [AccountHomeEntries] = []
    var entries: [String] = []
    var order : HYBOrderHistory? = nil
    var totalOrder : Int? = nil
    var totalFavorites = 0
    private var chorusStatus = AccountHomeChorusStatus.noNeedChorus
    lazy var loaderManager = LoaderViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupHeader()
        self.setupHeadings()
        self.setupLogoNavigationBarModal()
        self.fetchFavoritesCount()
        MessageManager.shared.addChatButton(self)
        self.loaderManager.showLoderView()
        let orderViewModel = OrderViewModel()
        orderViewModel.resetPagination()
        orderViewModel.getOrders { orders in
            
            self.loaderManager.hideLoaderView()
            if (orders != nil && orders?.0 != nil && orders?.0.count != nil)  {
                if (orders?.0.count)! > 0 {
                    self.order = orders!.1[0][0]
                }
            }
            self.totalOrder = orderViewModel.totalOrder()
            self.checkChorus()
            self.setupHeader()
            self.setupHeadings()
            self.tableView.reloadData()
        }
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kHome,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kAccountLevel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MessageManager.shared.hideChatButton()
    }
    
    func checkChorus() {
        if UserAccount.shared.customerInfo?.companyTypeCode == "publicSector", !(UserAccount.shared.customerInfo?.siret?.isEmpty ?? false) {
            self.loaderManager.showLoderView()
            AccountNetworkManager().checkChorus(with: UserAccount.shared.customerInfo?.siret ?? "") { (isChorusPartner, serviceList) in
                self.loaderManager.hideLoaderView()
                if isChorusPartner == false {
                    self.chorusStatus = .noChorus
                } else if UserAccount.shared.customerInfo?.serviceCode == nil, (serviceList ?? [Service]()).count > 0 {
                    self.chorusStatus = .noServiceCodeChorus
                } else {
                    self.chorusStatus = .noNeedChorus
                }
                self.setupHeadings()
                self.tableView.reloadData()
            }
        } else {
            chorusStatus = .noNeedChorus
            self.setupHeadings()
            self.tableView.reloadData()
        }
    }
    
    func fetchFavoritesCount() {
        let realm = try! Realm()
        let productFavorite = ProductFavorite()
        let placeFavorites = realm.objects(PostalOffice.self)
        
        self.totalFavorites = productFavorite.fetchAll() + placeFavorites.count
    }
    
    func setupHeader() {
        entrepriseNameLabel.text = UserAccount.shared.customerInfo?.companyName
        if UserAccount.shared.customerInfo?.isCustomerProCertified == true {
            certificationLabel.text = "Certifié"
            certificationImageView.image = R.image.ic_certificat_true()
        }
        certificationLabel.text = UserAccount.shared.customerInfo?.getStatusFrom()
//        if (UserAccount.shared.customerInfo?.certifiedEtatCode) != nil {
//            certificationLabel.text = UserAccount.shared.customerInfo?.getStatusFrom()
//        }
        
        let formattedString = NSMutableAttributedString()
        if let customerInfo = UserAccount.shared.customerInfo, let firstname = customerInfo.firstName, let lastname = customerInfo.lastName {
            let name = "\(firstname) \(lastname)"
            formattedString
                .normal("Bienvenue ")
                .custom(name, font: UIFont.systemFont(ofSize: 24, weight: .semibold), color: .white)
            welcomingLabel.attributedText = formattedString
        }
    }
    
    func setupHeadings() {
        self.headings = [AccountHomeEntries]()
        self.headings.append(.certification)
        
        if chorusStatus != .noNeedChorus {
            self.headings.append(.chorus)
        }
        
        if self.order == nil {
            self.headings.append(.rubric(title: "Commandes"))
        }
        else {
            self.headings.append(.detailed)
        }
        self.headings.append(.rubric(title: "Besoin d'aide ?"))
        //self.headings.append(.rubric(title: "Carnet d'adresses"))
        self.headings.append(.rubric(title: "Favoris"))
        self.headings.append(.disconnect)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showProfileButtonTapped(_ sender: Any) {
        let viewController = R.storyboard.account.profileHomeViewControllerID()!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AccountHomeViewController: UITableViewDelegate, UITableViewDataSource, DisconnectTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.headings[indexPath.row] as AccountHomeEntries
        return item.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch headings[indexPath.row] {
            case .disconnect:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.disconnectTableViewCellID, for: indexPath)!
                cell.delegate = self
                return cell
            case .certification:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.certificationTableViewCellID, for: indexPath)!
                return cell
            case .rubric(let title):
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.accountHomeTableViewCellID, for: indexPath)!
                cell.titleLabel.text = title
                cell.delegate = self as AccountHomePageCellsDelegate
                if indexPath.row != 0 {
                    cell.setupAsTitledCell()
                    switch title {
                        case "Besoin d'aide ?":
                            cell.iconImageView.image = R.image.ic_entry_help()
                            cell.quantityLabel.isHidden = true
                        case "Commandes":
                            cell.iconImageView.image = R.image.ic_entry_archive()
                            cell.quantityLabel.isHidden = true
                            break
                        //case "Carnet d'adresses":
                            //    cell.iconImageView.image = R.image.ic_entry_addressbook()
                            //    cell.quantityLabel.text = "20"
                        default:
                            cell.iconImageView.image = R.image.ic_entry_favorite()
                            if self.totalFavorites == 0 {
                                cell.quantityLabel.text = ""
                            } else {
                                cell.quantityLabel.text = "\(self.totalFavorites)"
                        }
                    }
                }
            return cell
        case .detailed:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.accountHomeTableViewCellID, for: indexPath)!
            cell.iconImageView.image = R.image.ic_entry_archive()
            cell.quantityLabel.isHidden = false
            cell.quantityLabel.text = self.totalOrder == nil ? "" : "\(self.totalOrder!)"
            cell.descriptionLabel.text = "Commande n° " + self.order!.code!
            cell.statusLabel.text = self.order!.statusDisplayUI()
            let date = self.order!.placed.getDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "FR-fr")
            dateFormatter.dateFormat = "dd LLLL YYYY"
            if date != nil {
                cell.dateLabel.text = dateFormatter.string(from: date!)
            }
            else {
                cell.dateLabel.text = ""
            }
            cell.setupAsDetailedCell()
            return cell
        case .chorus:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.accountHomeChorusCell, for: indexPath)!
            cell.setUpCell(isChorus: (chorusStatus == .noServiceCodeChorus))
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.headings[indexPath.row] {
        case .rubric(let title):
            switch title {
            case "Favoris":
                let viewController = R.storyboard.account.favoritesViewControllerID()!
                self.navigationController?.pushViewController(viewController, animated: true)
                break
            case "Commandes":
                let viewController = R.storyboard.order.historyOrdersViewController()!
                self.navigationController?.pushViewController(viewController, animated: true)
                break
            case "Besoin d'aide ?":
                self.needHelpTapped()
                break
            case "Carnet d'adresses":
                break
            default:
                break
            }
        case .detailed:
            let viewController = R.storyboard.order.historyOrdersViewController()!
            viewController.searchString = ""
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        default:
            break
        }
    }
    
    func didTappedDisconnect() {
        self.emptyShortCutItem()
        let viewController = R.storyboard.account.disconnectionViewControllerID()!
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }

    func emptyShortCutItem() {
        UIApplication.shared.shortcutItems = []
    }
}

extension AccountHomeViewController: AccountHomePageCellsDelegate, AccountHomeChorusCellDelegate {
    func callProfileViewcontroller() {
        let viewController = R.storyboard.account.profileHomeViewControllerID()!
        viewController.needToOpenDetails = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func needHelpTapped() {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kBesoinAide,
                                                              pageName: nil,
                                                              chapter1: nil,
                                                              chapter2: nil,
                                                              level2: TaggingData.kAccountLevel)
        
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! WebViewController
        vc.webViewType = .needHelp
        vc.url = WebViewURL.pro.rawValue
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}
