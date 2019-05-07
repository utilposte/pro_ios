//
//  FollowListViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 02/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedSUIVI
import RealmSwift
import UIKit

class FollowListViewController: UIViewController {
    enum FollowList {
        case noTrack
        case addTrack
        case noCurrentTrack
        case help
        case addAnotherTrack
        case separator
        case track(shipment: CacheShipmentTrack)
        
        var cellIdentifier: String {
            switch self {
            case .noTrack:
                return "NoTrackingTableViewCellID"
            case .addTrack:
                return "AddTrackTableViewCellID"
            case .noCurrentTrack:
                return "NoCurrentTrackTableViewCellID"
            case .help:
                return "HelpTableViewCellID"
            case .addAnotherTrack:
                return "AddAnotherTrackTableViewCellID"
            case .track:
                return "TrackTableViewCellID"
            case .separator:
                return "SeparatorTrackTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .noTrack:
                return 330
            case .separator:
                return 0
            default:
                return UITableViewAutomaticDimension
            }
        }
    }
    
    @IBOutlet var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var stackviewContainer: UIView!
    @IBOutlet var tableView: UITableView!
    internal var containsTrack = false
    internal var shipmentsArray = [CacheShipmentTrack]()
    internal var currentTrack = [FollowList]()
//    internal var pastTrack = [FollowList]()
    internal var sections = [[FollowList]]()
    internal var pastIsCollapsed = true
    @IBOutlet var typeView: UIView!
    @IBOutlet var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        // START HIDE FITLER
        self.stackviewContainer.isHidden = true
        self.stackViewHeightConstraint.constant = 0
        // END HIDE FILTER
        self.setupLogoNavigationBar()
//        self.pastTrack = []
        self.currentTrack = []
        self.setupTableView()
        self.typeView.clipsToBounds = true
        self.typeView.layer.masksToBounds = true
        self.typeView.addBorder(toSide: .right, withColor: UIColor.black.cgColor, andThickness: 1)
        self.stackviewContainer.layer.applyShadow(color: .black, alpha: 0.2, x: 0, y: 1, blur: 0.5, spread: 0.5)
        self.fetchAllShipments()
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kTrackingHome,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kTrackingLevel)
        // Send weborama tag
        let ccuId = UserAccount.shared.customerInfo?.displayUid?.sha256() ?? ""
        PixelWeboramaManager().sendWeboramaTag(tagToSend: Constants.trackingWeboramaKey, ccuIDCryptedValue: ccuId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchAllShipments() {
        let realm = try! Realm()
        let shipments = realm.objects(CacheShipmentTrack.self)
        if shipments.isEmpty {
            self.stackviewContainer.isHidden = true
            self.stackViewHeightConstraint.constant = 0
            self.containsTrack = false
            self.sections = []
            self.setupNoShipments()
        } else {
//            self.stackviewContainer.isHidden = false
//            self.stackViewHeightConstraint.constant = 60
            self.containsTrack = true
            self.sections = []
            for shipment in shipments {
                self.updateTrackList(code: shipment.code ?? "")
            }
            let updatedShipments = realm.objects(CacheShipmentTrack.self).sorted(byKeyPath: "lastUpdate", ascending: false)
            self.setupShipments(shipments: updatedShipments)
        }
        self.tableView.reloadData()
    }
    
    private func setupNoShipments() {
        self.sections.append([.noTrack, .addTrack])
    }
    
    private func setupShipments(shipments: Results<CacheShipmentTrack>) {
        for shipment in shipments {
            let currentTrack = CacheShipmentTrack.getResponseTrack(code: shipment.code ?? "")
//            if currentTrack?.shipment?.isFinal == true {
//                self.pastTrack.append(.track(shipment: shipment))
//            } else {
            self.currentTrack.append(.track(shipment: shipment))
//            }
        }
        
        if self.currentTrack.isEmpty {
            self.sections.append([.noCurrentTrack, .separator])
        } else {
            self.currentTrack.insert(.addAnotherTrack, at: 0)
//            self.currentTrack.append(.separator)
            self.sections.append(self.currentTrack)
        }
//        self.sections.append(self.pastTrack)
        self.sections.append([.help])
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func updateTrackList(code: String) {
        TrackManager.shared.setHost("https://www.laposte.fr")
        TrackManager.shared.getShipmentFor(trackCode: code, completion: { success, responseFollow in
            if responseFollow != nil, success {
                _ = CacheShipmentTrack.save(responseTrack: responseFollow!)
            } else if responseFollow != nil, !success {
                Logger.shared.debug("Error - An Error Occured for retrieving track")
            } else {
                Logger.shared.debug("Error - An Error Occured for retrieving track")
            }
        })
    }
}

extension FollowListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let navigationController = R.storyboard.search.instantiateInitialViewController()
        let searchViewController = navigationController?.viewControllers.first as? SearchViewController
        searchViewController?.searchType = .follow
        searchViewController?.openerViewController = self
        self.present(navigationController!, animated: true) {}
        return false
    }
}

extension FollowListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.section][indexPath.row]
        switch item {
        case .noTrack:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! NoTrackingTableViewCell
            return cell
        case .addTrack:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AddTrackTableViewCell
            cell.delegate = self
            return cell
        case .noCurrentTrack:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! NoCurrentTrackTableViewCell
            cell.delegate = self
            return cell
        case .help:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HelpTableViewCell
            return cell
        case .addAnotherTrack:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AddAnotherTrackTableViewCell
            return cell
        case .track(let shipment):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! TrackTableViewCell
            cell.setupCell(shipment: shipment)
            return cell
        case .separator:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! SeparatorTrackTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.sections[indexPath.section][indexPath.row]
        switch item {
        case .help:
            let viewController = R.storyboard.webView.webViewControllerID()!
            viewController.url = "https://aide.laposte.fr/professionnel/categorie/suivi-de-courrier-et-colis/"
            self.navigationController?.pushViewController(viewController, animated: true)
        case .track(let shipment):
            let viewController = R.storyboard.follow.followDetailViewControllerID()!
            if let code = shipment.code {
                viewController.responseTrack = CacheShipmentTrack.getResponseTrack(code: code)
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        case .addAnotherTrack:
            let viewController = R.storyboard.follow.scanFollowCodeViewController()!
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
    func goToScanController() {
        let viewController = R.storyboard.follow.scanFollowCodeViewController()!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FollowListViewController: AddTrackTableViewCellDelegate {
    func trackButtonDidTapped() {
        self.goToScanController()
    }
}

extension FollowListViewController: NoCurrentTrackTableViewCellDelegate {
    func searchButtonDidTapped() {
        self.goToScanController()
    }
}

extension FollowListViewController: TrackTableHeaderFooterViewDelegate {
    func toggleSection(_ header: TrackTableHeaderFooterView, section: Int) {
        // Toggle collapse
        if section == 1 {
            self.pastIsCollapsed = !self.pastIsCollapsed
            header.setCollapsed(self.pastIsCollapsed)
            self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        }
    }
}
