//
//  LocationListViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import Contacts

class LocationListViewController: BaseViewController {
    
    //IBOUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterButton: UIButton!
    
    //PROPRETIES
    var viewModel: LocationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.favoriteButton.cornerRadius = favoriteButton.frame.height / 2
        self.filterView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 0, y: 1, blur: 5, spread: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch (viewModel?.selectedType)! {
        case .postBox:
            verifyFilterViewVisibility(isHidden: true)
            setupFilterButton()
        default:
            verifyFilterViewVisibility(isHidden: false)
        }
    }
    
    private func setupFilterButton() {
        //filter button
        if (viewModel?.isResultFiltred() ?? false) {
            filterButton.setImage(R.image.fullFilter(), for: .normal)
        } else {
            filterButton.setImage(R.image.emptyFilter(), for: .normal)
        }
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        guard let filterViewController = R.storyboard.location.locationFilterViewController() else { return }
        switch viewModel?.selectedType {
        case .postOffice?:
            filterViewController.filterType = .pointTypeBp
        case .retrieve?:
            filterViewController.filterType = .pointType
        case .depot?:
            filterViewController.filterType = .pointType
        default:
            filterViewController.filterType = nil
        }
        filterViewController.setFilterSelected(pointType: (viewModel?.pointTypeSelectedValue)!, day: (viewModel?.daySeletedValue)!, hour: (viewModel?.hourSelectedValue)!)
        filterViewController.delegate = self
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    func verifyFilterViewVisibility(isHidden: Bool) {
        if isHidden {
            if self.filterViewHeightConstraint != nil {
                self.filterViewHeightConstraint.constant = 0
                filterView.clipsToBounds = true
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            filterView.clipsToBounds = false
            self.filterViewHeightConstraint.constant = 60
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getListCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTableViewCell", for: indexPath) as! LocationListTableViewCell
        cell.viewModel = self.viewModel
        cell.setup(index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let postalOffice = viewModel?.getPostalOffice(index: indexPath.row) {
            guard let detailViewController = R.storyboard.location.locationDetailViewController() else {
                return
            }
            detailViewController.detailPostalOffice = postalOffice
            detailViewController.delegate = self
            detailViewController.modalPresentationStyle = .overCurrentContext
            detailViewController.locationMapViewModel = viewModel!
//            self.presentRightTransition(detailViewController) {
//                detailViewController.viewStatus = .list
//            }
            self.present(detailViewController, animated: true) {
                detailViewController.viewStatus = .list
            }
            
        }
        else if let boxDetail = viewModel?.getPostalBox(index: indexPath.row) {
            
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCommentSYRendre,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kBal,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kLocaliseLevel)

            
            let address = "\(boxDetail.va_no_voie ?? "") \(boxDetail.lb_voie_ext ?? ""))"
            let addressDict : [String : Any] = [String(CNPostalAddressStreetKey) as String: address,
                           String(CNPostalAddressCityKey) as String: boxDetail.co_insee_com,
                           String(CNPostalAddressPostalCodeKey) as String: boxDetail.co_postal]
            let routeString = "comgooglemaps://?daddr=\(address.replacingOccurrences(of: " ", with: "+")),\(boxDetail.co_insee_com.replacingOccurrences(of: " ", with: "+"))&center=\(boxDetail.latitude),\(boxDetail.longitude)"
            
            if let alert = viewModel?.showItinerairy(postalOfficeCoordinate: boxDetail.position, addressDict: addressDict , routeString: routeString) {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension LocationListViewController: LocationDetailViewControllerDelegate {
    func didPanTray(_ sender: UIPanGestureRecognizer, isPostalOffice: Bool, viewState: ViewState) {
        //
    }
    
    
    func showCalendar(_ hours: [Any]) {
//        let calendarViewController = R.storyboard.location.locationCalendarViewController()!
//        calendarViewController.postalOfficeHours = hours
//        self.presentRightTransition(calendarViewController) { }
    }
    
    func hideDetails() {
        //
    }
    
    
}


extension LocationListViewController: LocationDelegate {
    func applyFilter(pointType: String, day: String, hour: String) {
        viewModel?.getList(pointType: pointType,
                           day: day,
                           hour: hour,
                           onCompletetion: {
                            self.viewModel?.setDayFilterIndex(with: day)
                            self.viewModel?.setHourFilterIndex(with: hour)
                            self.viewModel?.setPointTypeFilterIndex(with: pointType)
                            self.setupFilterButton()
                            self.tableView.reloadData()
        })
    }
}
