//
//  LocationRootViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedLOC
import UIKit

enum SelectedType: Int {
    case postOffice = 1
    case retrieve = 2
    case depot = 3
    case postBox = 4
}

enum SearchType: Int {
    case location = 1
    case text = 2
}

protocol LocationDelegate {
    func applyFilter(pointType: String, day: String, hour: String)
}

class LocationRootViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet var postOfficeButton: UIButton!
    @IBOutlet var retrieveButton: UIButton!
    @IBOutlet var depotButton: UIButton!
    @IBOutlet var postBoxButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var containerView: UIView!
    @IBOutlet var displayModeButton: UIButton!
    @IBOutlet var hideDetailContainerButton: UIButton!
    
    // MARK: -  Params
    
    let locationViewModel = LocationViewModel()
    private var mapViewController: LocationMapViewController?
    private var listViewController: LocationListViewController?
    private var inactiveViewController: UIViewController?
    private var isMap = true
    
    private var needSearch: String?
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(inactiveViewController: inactiveViewController)
            updateActiveViewController()
        }
    }
    
    // MARK: - UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchNavigationBar(searchBar: self.searchBar)
        self.navigationItem.titleView = searchBar
        // SearchBar
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.backgroundColor = UIColor.groupTableViewBackground
        }
        self.initViews()
        
        // Send weborama tag
        let ccuId = UserAccount.shared.customerInfo?.displayUid?.sha256() ?? ""
        PixelWeboramaManager().sendWeboramaTag(tagToSend: Constants.localiserWeboramaKey, ccuIDCryptedValue: ccuId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kLocaliserHome,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kLocaliseLevel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.postOfficeButton.roundCorners(corners: [.bottomLeft, .topLeft], radius: 5)
        self.postBoxButton.roundCorners(corners: [.bottomRight, .topRight], radius: 5)
        
        let selectedButton = getSelectedButton(selectedType: locationViewModel.selectedType)
        self.selectListType(selectedButton)
        
        if self.needSearch != nil {
            self.searchBar.text = self.needSearch
            self.needSearch = nil
            self.searchBarSearchButtonClicked(self.searchBar)
        }
        self.hideDetail()
        self.hideDetailContainerButton.isHidden = true
    }
    
    private func initViews() {
        self.inactiveViewController = self.createListView()
        self.activeViewController = self.createMapView()
    }
    
    private func createMapView() -> LocationMapViewController {
        self.mapViewController = R.storyboard.location.locationMapViewController()
        self.mapViewController?.delegate = self
        self.mapViewController?.locationMapViewModel = locationViewModel
        self.setUpDetailView()
        return self.mapViewController!
    }
    
    private func createListView() -> LocationListViewController {
        self.listViewController = R.storyboard.location.locationListViewController()
        self.listViewController?.viewModel = self.locationViewModel
        self.listViewController?.verifyFilterViewVisibility(isHidden: true)
        return self.listViewController!
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            inActiveVC.willMove(toParentViewController: nil)
            inActiveVC.view.removeFromSuperview()
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // self.navigationController?.addChildViewController(activeVC)
            addChildViewController(activeVC)
            activeVC.view.frame = self.containerView.bounds
            self.containerView.addSubview(activeVC.view)
            activeVC.didMove(toParentViewController: self)
        }
    }
    
    // MARK: - Pan Gesture
    
    @IBOutlet var detailContainerView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var detailViewController: LocationDetailViewController? {
        didSet {
            didSetDetailViewController()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            guard let destionationViewController = segue.destination as? LocationDetailViewController else {
                return
            }
            self.detailViewController = destionationViewController
            self.navigationController?.navigationBar.layer.zPosition = -1
        }
    }
    
    func didSetDetailViewController() {
        self.detailViewController?.delegate = self
    }
    
    func setUpDetailView() {
        let downFrame = CGRect(x: 0, y: self.view.bounds.height + 180, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.detailContainerView.frame = downFrame
        self.detailViewController?.viewStatus = .hidden
    }
    
    func getSelectedButton(selectedType: SelectedType) -> UIButton {
        switch selectedType {
        case .postOffice:
            return self.postOfficeButton
        case .retrieve:
            return self.retrieveButton
        case .depot:
            return self.depotButton
        case .postBox:
            return self.postBoxButton
        }
    }
}

extension LocationRootViewController: LocationParametersDelegate {
    func checkListWithType(type: SelectedType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        switch type {
        case .postOffice:
            if let latittude = locationViewModel.selectedLocation?.coordinate.latitude,
                let longitude = locationViewModel.selectedLocation?.coordinate.longitude {
                self.locationViewModel.getListPostOffice(latitude: latittude, longitude: longitude) { result in
                    self.updatePostalOfficeList(result)
                }
                
                if let location = self.locationViewModel.selectedLocation {
                    let geoCoder = CLGeocoder.init()
                    geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                        print(placemarks?.first?.postalCode)
                        if let postalCode = placemarks?.first?.postalCode {
                         self.locationViewModel.getPostOfficesPro(place: postalCode)
                        }
                    }
                }
            }
        case .depot:
            if self.locationViewModel.isResultFiltred() {
                let filterViewModel = LocationFilterViewModel()
                locationViewModel.getList(pointType: filterViewModel.getPointTypeFilterValue(type: .pointType,
                                                                                             index: locationViewModel.pointTypeSelectedValue),
                                          day: filterViewModel.getDayFilterValue(index: locationViewModel.daySeletedValue),
                                          hour: filterViewModel.getHourFilterValue(index:
                    locationViewModel.hourSelectedValue)) {
                    self.mapViewController?.resultList = self.locationViewModel.getResultList()
                    self.listViewController?.tableView.reloadData()
                }
            } else {
                if let latittude = locationViewModel.selectedLocation?.coordinate.latitude,
                    let longitude = locationViewModel.selectedLocation?.coordinate.longitude {
                    self.locationViewModel.getListDepot(latitude: latittude, longitude: longitude) { result in
                        self.updatePostalOfficeList(result)
                    }
                }
            }
        case .retrieve:
            if self.locationViewModel.isResultFiltred() {
                let filterViewModel = LocationFilterViewModel()
                locationViewModel.getList(pointType: filterViewModel.getPointTypeFilterValue(type: .pointType,
                                                                                             index: locationViewModel.pointTypeSelectedValue),
                                          day: filterViewModel.getDayFilterValue(index: locationViewModel.daySeletedValue),
                                          hour: filterViewModel.getHourFilterValue(index:
                    locationViewModel.hourSelectedValue)) {
                    self.mapViewController?.resultList = self.locationViewModel.getResultList()
                    self.listViewController?.tableView.reloadData()
                }
            } else {
                if let latittude = locationViewModel.selectedLocation?.coordinate.latitude,
                    let longitude = locationViewModel.selectedLocation?.coordinate.longitude {
                    self.locationViewModel.getListRetreive(latitude: latittude, longitude: longitude) { result in
                        self.updatePostalOfficeList(result)
                    }
                }
            }
        case .postBox:
            if let latittude = locationViewModel.selectedLocation?.coordinate.latitude,
                let longitude = locationViewModel.selectedLocation?.coordinate.longitude {
                self.locationViewModel.getListPostBox(latitude: latittude, longitude: longitude) { result in
                    self.updatePostBoxList(result)
                }
            }
        }
    }
    
    func checkListWithType(type: SelectedType, text: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        switch type {
        case .postOffice:
            self.locationViewModel.getListPostOffice(searchText: text, onCompletion: { result in
                self.updatePostalOfficeList(result)
            })
        case .depot:
            self.locationViewModel.getListDepot(searchText: text, onCompletion: { result in
                self.updatePostalOfficeList(result)
            })
        case .retrieve:
            self.locationViewModel.getListRetreive(searchText: text, onCompletion: { result in
                self.updatePostalOfficeList(result)
            })
        case .postBox:
            self.locationViewModel.getListPostBox(searchText: text, onCompletion: { result in
                self.updatePostBoxList(result)
            })
        }
        
        self.hideDetail()
    }
    
    private func updatePostalOfficeList(_ result: [LOCPostalOffice]) {
        if !result.isEmpty {
            self.mapViewController?.resultList = result
            self.listViewController?.tableView.reloadData()
        }
    }
    
    private func updatePostBoxList(_ result: [LOCPostBox]) {
        if !result.isEmpty {
            self.mapViewController?.resultPostBoxList = result
            self.listViewController?.tableView.reloadData()
        }
    }
    
    func showDetailWith(postalOffice: LOCPostalOffice) {
        let downFrame = CGRect(x: 0, y: self.view.bounds.height - 170, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.detailContainerView.frame = downFrame
        self.detailViewController?.detailPostalOffice = postalOffice
        self.detailViewController?.viewStatus = .minimum
    }
    
    func showDetailwith(postalBox: LOCPostBox) {
        let downFrame = CGRect(x: 0, y: self.view.bounds.height - 170, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.detailContainerView.frame = downFrame
        self.detailViewController?.detailPostalBox = postalBox
        self.detailViewController?.viewStatus = .minimum
    }
    
    func hideDetail() {
        let downFrame = CGRect(x: 0, y: self.view.bounds.height + 160, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.detailContainerView.frame = downFrame
        self.detailViewController?.viewStatus = .hidden
    }
}

extension LocationRootViewController: LocationDetailViewControllerDelegate {
    func showCalendar(_ hours: [Any]) {
        self.hideDetails()
        //        let calendarViewController = R.storyboard.location.locationCalendarViewController()!
        //        calendarViewController.postalOfficeHours = hours
        //        self.presentRightTransition(calendarViewController) { }
    }
    
    func hideDetails() {
        self.hideDetail()
    }
    
    func didPanTray(_ sender: UIPanGestureRecognizer, isPostalOffice: Bool, viewState: ViewState) {
        let translation = sender.translation(in: view)
        let originY = detailContainerView.frame.origin.y
        let velocity = sender.velocity(in: view)
        
        if !isPostalOffice, velocity.y < 0, viewState != .hidden {
            return
        }
        
        if sender.state == UIGestureRecognizerState.began {
            self.hideDetailContainerButton.isHidden = false
            self.trayOriginalCenter = self.detailContainerView.center
        } else if sender.state == UIGestureRecognizerState.changed {
            if (originY > -CGFloat((self.navigationController?.navigationBar.frame.size.height)!) && velocity.y < 0) || (originY < UIScreen.main.bounds.height - 160 && velocity.y > 0) {
                self.detailContainerView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayOriginalCenter.y + translation.y)
                if originY > self.view.bounds.height - 200 {
                    self.hideDetailContainerButton.alpha = 0
                } else {
                    let baseY = self.view.bounds.height - 200
                    let persentAlpha = 0.5 - ((originY / baseY) * 0.5)
                    hideDetailContainerButton.alpha = persentAlpha
                    //                    hideDetailContainerButton
                }
            } else {}
        } else if sender.state == UIGestureRecognizerState.ended {
            _ = CGRect(x: 0, y: -CGFloat((self.navigationController?.navigationBar.frame.size.height)!), width: UIScreen.main.bounds.width, height: self.view.frame.size.height + 64)
            // Calculate the originY on the containerView
            var origin: CGFloat = 120
            let cellSize: CGFloat = 470
            let diff = self.view.bounds.height - cellSize
            if diff > 0 {
                origin = diff
            }
            let middleFrame = CGRect(x: 0, y: origin, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            let downFrame = CGRect(x: 0, y: self.view.bounds.height - 170, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            let hideFrame = CGRect(x: 0, y: self.view.bounds.height + 160, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            if originY > self.view.bounds.height - 44 {
                Logger.shared.verbose("HIDE")
                self.hideDetailContainerButton.isHidden = true
                self.hideDetailContainerButton.alpha = 0
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.detailContainerView.frame = hideFrame
                    self.detailViewController?.viewStatus = .hidden
                })
            } else if originY > self.view.bounds.height - 200 {
                Logger.shared.verbose("DOWN")
                self.hideDetailContainerButton.isHidden = true
                self.hideDetailContainerButton.alpha = 0
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.detailContainerView.frame = downFrame
                    self.detailViewController?.viewStatus = .minimum
                })
            } else if originY < 120 {
                Logger.shared.verbose("UP")
                self.hideDetailContainerButton.isHidden = true
                self.hideDetailContainerButton.alpha = 0
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    if self.detailViewController?.isPostalOffice == true {
                        self.detailContainerView.frame = hideFrame
                        self.detailViewController?.viewStatus = .hidden
                        if let tmpDetailViewController = R.storyboard.location.locationDetailViewController() {
                            if let boxOffice = self.detailViewController?.detailPostalOffice {
                                tmpDetailViewController.detailPostalOffice = boxOffice
                                tmpDetailViewController.delegate = self
                                tmpDetailViewController.modalPresentationStyle = .overCurrentContext
                                self.present(tmpDetailViewController, animated: false) {
                                    tmpDetailViewController.viewStatus = .list
                                }
                            }
                        }
                    } else {
                        self.detailContainerView.frame = middleFrame
                        self.detailViewController?.viewStatus = .normal
                    }
                })
            } else {
                Logger.shared.verbose("MIDDLE")
                self.hideDetailContainerButton.alpha = 0.5
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.detailContainerView.frame = middleFrame
                    self.detailViewController?.viewStatus = .normal
                })
            }
        }
    }
    
    @IBAction func displayModeButtonClicked(_ sender: Any) {
        self.hideDetail()
        if self.isMap {
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kVueListe,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kLocaliserHome,
                                                                  chapter2: TaggingData.kGeolocalisation,
                                                                  level2: TaggingData.kLocaliseLevel)
            
            self.inactiveViewController = mapViewController
            self.activeViewController = listViewController
            self.displayModeButton.setImage(R.image.ic_mode_map(), for: .normal)
        } else {
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kVueCarte,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kLocaliserHome,
                                                                  chapter2: TaggingData.kGeolocalisation,
                                                                  level2: TaggingData.kLocaliseLevel)
            
            self.inactiveViewController = listViewController
            self.activeViewController = mapViewController
            self.displayModeButton.setImage(R.image.ic_mode_list(), for: .normal)
        }
        self.isMap = !self.isMap
    }
    
    @IBAction func hideContainerButtonClicked(_ sender: Any) {
        self.hideDetailContainerButton.isHidden = true
        self.hideDetailContainerButton.alpha = 0
        let hideFrame = CGRect(x: 0, y: self.view.bounds.height + 160, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.detailContainerView.frame = hideFrame
            self.detailViewController?.viewStatus = .hidden
        })
    }
    
    @IBAction func selectListType(_ sender: UIButton) {
        self.postOfficeButton.isSelected = false
        self.retrieveButton.isSelected = false
        self.depotButton.isSelected = false
        self.postBoxButton.isSelected = false
        
        self.postOfficeButton.backgroundColor = UIColor.clear
        self.retrieveButton.backgroundColor = UIColor.clear
        self.depotButton.backgroundColor = UIColor.clear
        self.postBoxButton.backgroundColor = UIColor.clear
        
        sender.isSelected = true
        sender.backgroundColor = UIColor.lpDeepBlue
        
        if (sender.tag != SelectedType.postBox.rawValue) {
            if sender.tag != self.locationViewModel.selectedType.rawValue {
                self.resetFilters()
            }
        }
        self.mapViewController?.filterButton.isHidden = true
        
        switch sender.tag {
        case SelectedType.postOffice.rawValue:
            self.locationViewModel.selectedType = SelectedType.postOffice
            if !self.isMap {
                self.listViewController?.verifyFilterViewVisibility(isHidden: false)
            } else {
                self.mapViewController?.filterButton.isHidden = false
            }
        case SelectedType.retrieve.rawValue:
            self.locationViewModel.selectedType = SelectedType.retrieve
            if !self.isMap {
                self.listViewController?.verifyFilterViewVisibility(isHidden: false)
            } else {
                self.mapViewController?.filterButton.isHidden = false
            }
        case SelectedType.depot.rawValue:
            self.locationViewModel.selectedType = SelectedType.depot
            if !self.isMap {
                self.listViewController?.verifyFilterViewVisibility(isHidden: false)
            } else {
                self.mapViewController?.filterButton.isHidden = false
            }
        case SelectedType.postBox.rawValue:
            self.locationViewModel.selectedType = SelectedType.postBox
            if !self.isMap {
                self.listViewController?.verifyFilterViewVisibility(isHidden: true)
            }
        default:
            Logger.shared.verbose("Default")
        }
        self.hideDetail()
        if self.locationViewModel.searchType == .text {
            self.checkListWithType(type: self.locationViewModel.selectedType, text: self.searchBar.text ?? "")
        } else if self.locationViewModel.selectedLocation != nil {
            self.checkListWithType(type: self.locationViewModel.selectedType)
        }
    }
    
    private func resetFilters() {
        if self.isMap {
            self.mapViewController?.applyFilter(pointType: "", day: "", hour: "")
        } else {
            self.listViewController?.applyFilter(pointType: "", day: "", hour: "")
        }
    }
    
    //    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
    //        if let inActiveVC = inactiveViewController {
    //            inActiveVC.willMove(toParentViewController: nil)
    //            inActiveVC.view.removeFromSuperview()
    //            inActiveVC.removeFromParentViewController()
    //        }
    //    }
    //
    //    private func updateActiveViewController() {
    //        if let activeVC = activeViewController {
    //            addChildViewController(activeVC)
    //            activeVC.view.frame = containerView.bounds
    //            containerView.addSubview(activeVC.view)
    //            activeVC.didMove(toParentViewController: self)
    //        }
    //    }
}

extension LocationRootViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.locationViewModel.searchType = .location
                self.checkListWithType(type: self.locationViewModel.selectedType)
            } else {
                self.locationViewModel.searchType = .text
                self.checkListWithType(type: self.locationViewModel.selectedType, text: searchText)
            }
        } else {
            self.locationViewModel.searchType = .location
            self.checkListWithType(type: self.locationViewModel.selectedType)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let navigationViewController = R.storyboard.search.instantiateInitialViewController()!
        let searchViewController = navigationViewController.viewControllers[0] as! SearchViewController
        searchViewController.searchType = .localisator
        searchViewController.openerViewController = self
        self.present(navigationViewController, animated: true)
        return false
    }
    
    func searchLocator(_ text: String) {
        self.needSearch = text
    }
}

private extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = maskLayer
    }
}
