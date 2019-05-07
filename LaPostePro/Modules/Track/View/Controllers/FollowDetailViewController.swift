//
//  FollowDetailViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedSUIVI
import LPSharedMCM

class FollowDetailViewController: UIViewController {
    
    // MARK: OUTLET
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: PROPERTIES
    internal var sections: [FollowDetail] = []
    var responseTrack: ResponseTrack?
    
    enum FollowDetail {
        case trackingNumber(number: String)
        case orderDate(date: String, status: Bool)
        case course(label: String)
        case chronopostLink
        case stepTracking(title: String, desc: String, isLast: Bool)
        case deliveryType(type: String)
        case deliveryMode(mode: String)
        case separator
        case help
        case titleStep(delivered: Bool)
        case alert
        case ghost
        
        var cellIdentifier: String {
            switch self {
            case .trackingNumber:
                return "TrackingNumberTableViewCellID"
            case .orderDate:
                return "OrderDateTableViewCellID"
            case .course:
                return "CourseTableViewCellID"
            case .chronopostLink:
                return "ChronopostLinkTableViewCellID"
            case .stepTracking:
                return "StepTrackingTableViewCellID"
            case .deliveryType:
                return "DeliveryTypeTableViewCellID"
            case .deliveryMode:
                return "DeliveryModeTableViewCellID"
            case .separator:
                return "SeparatorTableViewCellID"
            case .help:
                return "HelpTableViewCellID"
            case .titleStep:
                return "TitleFollowStepTableViewCellID"
            case .alert:
                return "AlertFollowDetailTableViewCellID"
            case .ghost:
                return "GhostTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .chronopostLink:
                return 70
            case .deliveryMode:
                return 85
            case .separator:
                return 7
            case .ghost:
                return 44
            default:
                return UITableViewAutomaticDimension
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleNavigationBar(backEnabled: true, title: "Détail du suivi", showCart: false)
        self.setupTableView()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kTrackingDetails,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kTrackingLevel)
    }

    
    private func setupView() {
        self.sections = []
        //self.sections.append(.alert)
        if let num = responseTrack?.num {
            self.sections.append(.trackingNumber(number: num))
        }
        self.sections.append(.orderDate(date: responseTrack?.shipment?.phDate ?? "", status: responseTrack?.shipment?.isFinal ?? false))
        
        if responseTrack?.shipment?.product == "chronopost" {
            if let label = responseTrack?.shipment?.events?.event?.first?.label {
                self.sections.append(.course(label: label))
            }
        }
        
        
        if let events = responseTrack?.shipment?.events?.event, !events.isEmpty {
            var i = 0
            self.sections.append(.titleStep(delivered: responseTrack?.shipment?.isFinal ?? false))
            for event in events {
                i += 1
                if i == events.count {
                    self.sections.append(.stepTracking(title: event.date ?? "", desc: event.label ?? "", isLast: true))
                } else {
                    self.sections.append(.stepTracking(title: event.date ?? "", desc: event.label ?? "", isLast: false))
                }
            }
            self.sections.append(.ghost)
        }
        
        if let _ = responseTrack?.shipment?.urlDetail {
            self.sections.append(.chronopostLink)
        }
        if let product = responseTrack?.shipment?.product {
            self.sections.append(.deliveryType(type: product))
        }
        if let deliveryMode = responseTrack?.shipment?.deliveryMode {
            self.sections.append(.deliveryMode(mode: deliveryMode))
        }
        self.sections.append(.separator)
        self.sections.append(.help)
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func getChronopostUrlForTrackingStatus() -> String {
        if (self.responseTrack?.shipment?.urlDetail != nil) {
            let url = (self.responseTrack?.shipment?.urlDetail)!
            return url.replacingOccurrences(of: "fr_FR", with: "fr")
        } else {
            return ""
        }
    }
}

extension FollowDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.row]
        switch item {
        case .trackingNumber(let numberTrack):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! TrackingNumberTableViewCell
            cell.setupCell(trackingNumber: numberTrack)
            return cell
        case .orderDate(let date, let status):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! OrderDateTableViewCell
            cell.setupCell(date: date, status: status)
            return cell
        case .course(let label):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CourseTableViewCell
            cell.setupCell(label: label)
            return cell
        case .stepTracking(let title, let desc, let last):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! StepTrackingTableViewCell
            cell.setupCell(title: title, desc: desc, last: last)
            return cell
        case .chronopostLink:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ChronopostLinkTableViewCell
            return cell
        case .deliveryType(let type):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! DeliveryTypeTableViewCell
            cell.setupCell(type: type)
            return cell
        case .deliveryMode(let deliveryMode):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! DeliveryModeTableViewCell
            cell.setupCell(deliveryMode: deliveryMode)
            return cell
        case .separator:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! SeparatorTableViewCell
            return cell
        case .help:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HelpTableViewCell
            return cell
        case .titleStep(let delivered):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! TitleFollowStepTableViewCell
            cell.setupCell(delivered: delivered)
            return cell
        case .alert:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AlertFollowDetailTableViewCell
            return cell
        case .ghost:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! GhostTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.sections[indexPath.row]
        return item.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.sections[indexPath.row]
        switch item {
        case .help:
            let viewController = R.storyboard.webView.webViewControllerID()!
            if responseTrack?.shipment?.product == "colis" || responseTrack?.shipment?.product == "colissimo" {
                viewController.url = "https://aide.laposte.fr/professionnel/categorie/suivi-de-courrier-et-colis/"
            } else if responseTrack?.shipment?.product == "chronopost" {
                viewController.url = "https://www.chronopost.fr/fr/aide"
            } else {
                viewController.url = "https://aide.laposte.fr/professionnel/categorie/suivi-de-courrier-et-colis/"
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        case .chronopostLink:
            if let url = URL(string: getChronopostUrlForTrackingStatus()) {
                let viewController = R.storyboard.webView.webViewControllerID()!
                viewController.url = url.absoluteString
                self.navigationController?.pushViewController(viewController, animated: true)
                //                UIApplication.shared.open(url)
            }
        default:
            break
        }
    }
}
