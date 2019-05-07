 //
//  LocationDetailViewController.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 02/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedLOC

enum ViewState : Int {
    case minimum = 0
    case normal  = 1
    case full    = 2
    case hidden  = 3
    case list    = 4
    case favorit = 5
}

enum CellType : Int {
    case minimumCell            = 0
    case mediumCell             = 1
    case waitingCell            = 2
    case houresCell             = 3
    case servicesCell           = 4
    case accessibilitiesCell    = 5
    case hourDayCell            = 6
    case hourDetailCell         = 7
    case titleHourLimitCell     = 8
    case titleDayCell           = 9
}

protocol LocationDetailViewControllerDelegate {
    func didPanTray(_ sender: UIPanGestureRecognizer, isPostalOffice: Bool, viewState: ViewState)
    func showCalendar(_ hours: [Any])
    func hideDetails()
}

class LocationDetailViewController: UIViewController {
    
    // MARK: - Params
    var delegate : LocationDetailViewControllerDelegate?
    var locationMapViewModel = LocationViewModel()
    
    
    var cellsArray = [[CellType]]()
    var hoursOpenDay = ""
    var limitHours = [(String, String)]()
    
    var isPostalOffice = true
    var isFromList = false
    var isFromFavorites = false
    
    var detailPostalOffice : LOCPostalOffice? {
        didSet {
            isPostalOffice = true
        }
    }
    var detailPostalBox : LOCPostBox? {
        didSet {
            isPostalOffice = false
        }
    }
    
    var viewStatus = ViewState.hidden {
        didSet {
            refreshData()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var panContainerView: CustomPanView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var titlePostalOfficeLabel: UILabel!
    @IBOutlet weak var dissmissButton: UIButton!
    @IBOutlet weak var panViewImage: UIView!
    @IBOutlet weak var heightHeaderViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var topHeaderViewLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.isFromFavorites {
            self.viewStatus = .favorit
            self.title = detailPostalOffice?.name
        }
        self.modalPresentationStyle = .overCurrentContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // ATInternet
        if let detailPostalOffice = self.detailPostalOffice {
            let page = detailPostalOffice.libelleSite
            let type = locationMapViewModel.typeTagWith(detailPostalOffice.type)
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: page!,
                                                                 chapter1: type,
                                                                 chapter2: TaggingData.kFicheDetail,
                                                                 level2: TaggingData.kLocaliseLevel)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        delegate?.didPanTray(sender, isPostalOffice: isPostalOffice, viewState: viewStatus)
    }
    
    @IBAction func dissmissButtonClicked(_ sender: Any) {
        self.hideDetails()
    }
    
    
    func refreshData() {
        cellsArray = [[CellType]]()
        cellsArray.append([CellType]())
        if viewStatus == .hidden {
            return
        }
        titlePostalOfficeLabel.isHidden = false
        topHeaderViewLayoutConstraint.constant = 0
        switch viewStatus {
        case .minimum:
            dissmissButton.isHidden = true
            panViewImage.isHidden = false
            heightHeaderViewLayoutConstraint.constant = 40
            titlePostalOfficeLabel.isHidden = true
            cellsArray[0].append(CellType.minimumCell)
        case .normal:
            dissmissButton.isHidden = true
            panViewImage.isHidden = false
            heightHeaderViewLayoutConstraint.constant = 80
            titlePostalOfficeLabel.text = detailPostalOffice?.name
            cellsArray[0].append(CellType.mediumCell)
        case .full, .list:
            topHeaderViewLayoutConstraint.constant = 50
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            dissmissButton.isHidden = false
            panViewImage.isHidden = true
            heightHeaderViewLayoutConstraint.constant = 70
            titlePostalOfficeLabel.text = detailPostalOffice?.name
            cellsArray[0].append(CellType.mediumCell)
            cellsArray[0].append(CellType.waitingCell)
            getDetailsPOstalOffice()
            
        case .favorit:
            dissmissButton.isHidden = true
            panViewImage.isHidden = true
            topHeaderViewLayoutConstraint.constant = 0
            heightHeaderViewLayoutConstraint.constant = 20
            titlePostalOfficeLabel.text = ""//detailPostalOffice?.name
            cellsArray[0].append(CellType.mediumCell)
            cellsArray[0].append(CellType.waitingCell)
            getDetailsPOstalOffice()
            
            
        default: break
        }
        self.detailTableView.reloadData()
    }
    
    
    func getDetailsPOstalOffice() {
        if isPostalOffice == true && detailPostalOffice != nil {
            locationMapViewModel.getPostOfficeDetails(codeSite: (detailPostalOffice?.codeSite)!) { postOffice in
                
                guard let detail = postOffice else {
                    return
                }
                self.detailPostalOffice = detail
                
                self.cellsArray = [[CellType]]()
                self.cellsArray.append([CellType]())
                self.cellsArray.append([CellType]())
                self.cellsArray[0].append(CellType.mediumCell)
                
                if let horaires = detail.horaires {
                self.cellsArray[0].append(CellType.houresCell)
                    if horaires.count > 0 {
                        if let hours = ((horaires[0] as? [String: Any])?["horaires"]  as? [String]) {
                            if hours.count > 0 {
                                    self.hoursOpenDay = hours[0]
                                    if hours.count == 2 {
                                            self.hoursOpenDay = self.hoursOpenDay + "\n" + hours[1]
                                    }
                                    self.hoursOpenDay = self.hoursOpenDay.replacingOccurrences(of: "-", with: " à ", options: .literal, range: nil)
                                self.hoursOpenDay = self.hoursOpenDay.replacingOccurrences(of: ":", with: "h")
                                self.cellsArray[0].append(CellType.titleDayCell)
                                self.cellsArray[0].append(CellType.hourDetailCell)
                            }
                        }

                        
                        
                        
                        if let limitHours = ((detail.horaires[0] as? [String: Any])?["heures_limites"] as? Dictionary<String, AnyObject>)
                        {
                            self.cellsArray[0].append(CellType.titleHourLimitCell)
                            self.limitHours  = self.listRowHoursFor(limitHours: limitHours)
                            
                            for _ in self.limitHours {
                                self.cellsArray[1].append(CellType.hourDetailCell)
                            }
                        }
                    }
                }
                self.cellsArray.append([CellType]())
                
                if let services = detail.services {
                    if services.count > 0 {
                        self.cellsArray[2].append(CellType.servicesCell)
                    }
                }
                if let accessibilities = detail.accessibilite {
                    if accessibilities.count > 0 {
                        self.cellsArray[2].append(CellType.accessibilitiesCell)
                    }
                }
                self.detailTableView.reloadData()
            }
        }
    }

    func listRowHoursFor(limitHours: Dictionary<String, AnyObject>) -> [(String, String)] {
        var limits = [(String, String)]()
        for key in limitHours.keys {
            if let data = limitHours[key] as? [String] {
                if data.count >= 2 {
                    let title  = data[0].replacingOccurrences(of: "<br />", with: "", options: .literal, range: nil)
                    let detail = data[1].replacingOccurrences(of: ":", with: "h", options: .literal, range: nil)
                    limits.append((title, detail))
                }
            }
        }
        
        return limits
    }
    
}

extension LocationDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .minimumCell {
            let cell = self.detailTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationDetailMinimumCell, for: indexPath)
            if isPostalOffice == true {
                cell?.configureView(officeDetail: detailPostalOffice!)
                // ATInternet
                if let detailPostalOffice = self.detailPostalOffice {
                    let page = detailPostalOffice.libelleSite
                    let type = locationMapViewModel.typeTagWith(detailPostalOffice.type)
                    ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: page!,
                                                                         chapter1: type,
                                                                         chapter2: TaggingData.kResume,
                                                                         level2: TaggingData.kLocaliseLevel)
                }
            }
            else {
                cell?.configureView(boxDetail: detailPostalBox!)
                // ATInternet
                if let detailPostalOffice = self.detailPostalOffice {
                    let page = detailPostalOffice.libelleSite
                    let type = locationMapViewModel.typeTagWith(detailPostalOffice.type)
                    ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: page!,
                                                                         chapter1: TaggingData.kBal,
                                                                         chapter2: TaggingData.kResume,
                                                                         level2: TaggingData.kLocaliseLevel)
                }
            }
            cell?.delegate = self
            return cell!
        }
        if cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .mediumCell {
            let cell = self.detailTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationDetailMediumCell, for: indexPath)
            if isPostalOffice == true {
                cell?.setUpView(postalOffice: detailPostalOffice!)
                cell?.mediumDelegate = self
            }
            else {
                cell?.setUpView(postalBox: detailPostalBox!)
            }
            
//            if self.isFromFavorites {
//                cell?.heightCloseButtonConstraint.constant = 0
//            } else {
//                cell?.heightCloseButtonConstraint.constant = 50
//            }
            cell?.delegate = self
            return cell!
        }
        if cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .waitingCell {
            let cell = self.detailTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationDetailWaitingCell, for: indexPath)
            return cell!
        }
        
        if cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .houresCell {
            let cell = self.detailTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationDetailHoursCell, for: indexPath)
            cell?.hours = detailPostalOffice?.horaires
            cell?.retreiveDepositeHours = detailPostalOffice?.horaireRetraitDepot
            cell?.delegate = self
            return cell!
        }
        if cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .servicesCell {
            guard let list = detailPostalOffice?.services as? [String] else {
                return UITableViewCell()
            }
            let cell = self.detailTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationDetailServicesListCell, for: indexPath)
            cell?.setUpList(list, isServices: true)
            return cell!
        }
        if cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .accessibilitiesCell {
            guard let list = detailPostalOffice?.accessibilite as? [String] else {
                return UITableViewCell()
            }
            let cell = self.detailTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationDetailServicesListCell, for: indexPath)
            cell?.setUpList(list, isServices: false)
            return cell!
        }
        
        if cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .titleDayCell || cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .titleHourLimitCell {
            let cell = UITableViewCell()
            cell.textLabel?.text = cellsArray[indexPath.section][indexPath.row] == .titleDayCell ? "Horaires d'ouverture" : "Heures limites de dépôt"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell.selectionStyle = .none
            return cell
        }
        
        if cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .hourDetailCell {
            let cell = self.detailTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationCalendarTableViewCellID, for: indexPath)
            if(indexPath.section == 0) {
                cell?.workingHoursLabel.text = self.hoursOpenDay
                cell?.titleLabel.text = "Aujourd'hui"
            }

            if(indexPath.section == 1) {
                cell?.workingHoursLabel.text = self.limitHours[indexPath.row].1
                cell?.titleLabel.text = self.limitHours[indexPath.row].0
            }
            
            return cell!
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if(cellsArray.count > indexPath.section && cellsArray[indexPath.section][indexPath.row] == .hourDetailCell) {
            return 55
        }
        
        return UITableViewAutomaticDimension
    }
}

extension LocationDetailViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        Logger.shared.debug("gestureRecognizer :: \(gestureRecognizer.description)")
        return true
    }
}

extension LocationDetailViewController : LocationDetailCellDelegate {
    
    
    func showItinirary(postalOfficeCoordinate: CLLocationCoordinate2D, addressDict: [String : Any], routeString: String) {
        
        // ATInternet
        if let detailPostalOffice = self.detailPostalOffice {
            let type = locationMapViewModel.typeTagWith(detailPostalOffice.type)
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCommentSYRendre,
                                                                  pageName: nil,
                                                                  chapter1: type,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kLocaliseLevel)
        }
        

        
        let alert = locationMapViewModel.showItinerairy(postalOfficeCoordinate: postalOfficeCoordinate, addressDict: addressDict, routeString: routeString)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showHours(hours: [Any]) {
        let calendarViewController = R.storyboard.location.locationCalendarViewController()!
        calendarViewController.postalOfficeHours = hours
        if let detailPostalOffice = self.detailPostalOffice {
            calendarViewController.typeTag = locationMapViewModel.typeTagWith(detailPostalOffice.type)
        }
        self.presentRightTransition(calendarViewController) { }
    }
    
    func showRetieveDeposteHours(hours: [Any]) {
        let calendarViewController = R.storyboard.location.locationDetailHoursViewController()!
        calendarViewController.retrieveDepotHours = hours
        if let detailPostalOffice = self.detailPostalOffice {
            calendarViewController.typeTag = locationMapViewModel.typeTagWith(detailPostalOffice.type)
        }
        self.presentRightTransition(calendarViewController) { }
    }
    
    func hideDetails() {
        if viewStatus == .list {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.delegate?.hideDetails()
        }
    }
}

extension LocationDetailViewController: LocationDetailMediumCellDelegate {
    func favoriteButtonDidTapped(postalOffice: LOCPostalOffice) {
        // ATInternet
        if let detailPostalOffice = self.detailPostalOffice {
            let type = locationMapViewModel.typeTagWith(detailPostalOffice.type)
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAjoutFavoris,
                                                                  pageName: nil,
                                                                  chapter1: type,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kLocaliseLevel)
        }
        
        let postalOfficeRLM = PostalOffice()
        postalOfficeRLM.addPostalOffice(from: postalOffice) { isSuccess in
            if !isSuccess {
                let alertController = UIAlertController(title: "Vos Favoris", message: "Ce bureau de poste n'a pas pu etre ajouté à vos favoris", dismissActionTitle: "Fermer", dismissActionBlock: {})
                self.present(alertController!, animated: true, completion: nil)
            }
        }
        
        self.detailTableView.reloadData()
    }
    
    func favoriteButtonDidDeleted(postalOffice: LOCPostalOffice) {
        let postalOfficeRLM = PostalOffice()
        postalOfficeRLM.deletePostalOffice(codeSite: postalOffice.codeSite, completion: { isSuccess in
            if !isSuccess {
                let alertController = UIAlertController(title: "Vos Favoris", message: "Ce bureau de poste n'a pas pu être retiré de vos favoris", dismissActionTitle: "Fermer", dismissActionBlock: {})
                self.present(alertController!, animated: true, completion: nil)
            }
        })
        if self.isFromFavorites {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.detailTableView.reloadData()
        }
    }
}
