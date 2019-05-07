//
//  LocationMapViewController.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedLOC
import MapKit
import UIKit

protocol LocationParametersDelegate {
    func checkListWithType(type: SelectedType, text: String)
    func checkListWithType(type: SelectedType)
    
    func showDetailWith(postalOffice: LOCPostalOffice)
    func showDetailwith(postalBox: LOCPostBox)
    func hideDetail()
}

class LocationMapViewController: BaseViewController {
    // MARK: - Params
    
    var locationManager: CLLocationManager?
    let clusterManager = ClusterManager()
    var locationMapViewModel: LocationViewModel?
    var delegate: LocationParametersDelegate?
    var timer: Timer?
    var checkWithUserLocation = true
    var nextRegionChangeWasFromUserInteraction = false
    var oldAnnotationView: MKAnnotationView?
    var resultList = [LOCPostalOffice]() {
        didSet {
            Logger.shared.debug("LocationMapView OFFICE")
            self.refreshMap()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    var resultPostBoxList = [LOCPostBox]() {
        didSet {
            Logger.shared.debug("LocationMapView POSTBOX")
            self.refreshBoxMap()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var filterButton: UIButton!
    
    // MARK: - UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        determineCurrentLocation()
        self.setupLogoNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.navigationController?.navigationBar.layer.zPosition = -1;
        self.initViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIView setView
    
    func initViews() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.showsCompass = false
        self.mapView.tintColor = UIColor.lpDeepBlue
        
        // clusterManager
        self.clusterManager.cellSize = nil
        self.clusterManager.maxZoomLevel = 17
        self.clusterManager.minCountForClustering = 3
        self.clusterManager.clusterPosition = .nearCenter
        
        // filter button
        self.setupFilterButton()
    }
    
    private func setupFilterButton() {
        if self.locationMapViewModel?.isResultFiltred() ?? false {
            self.filterButton.setImage(R.image.fullFilter(), for: .normal)
        } else {
            self.filterButton.setImage(R.image.emptyFilter(), for: .normal)
        }
    }
    
    // MARK: - Utils Data
    
    func getPostalOfficeFromCoordinate(_ coordinate: CLLocationCoordinate2D) -> LOCPostalOffice? {
        for detail in self.resultList {
            if detail.position.longitude == coordinate.longitude, detail.position.latitude == coordinate.latitude {
                return detail
            }
        }
        return nil
    }
    
    func getPostalBoxFromCoordinate(_ coordinate: CLLocationCoordinate2D) -> LOCPostBox? {
        for detail in self.resultPostBoxList {
            if detail.longitude == coordinate.longitude, detail.latitude == coordinate.latitude {
                return detail
            }
        }
        return nil
    }
    
    func refreshMap() {
        Logger.shared.debug("LocationMapView refreshMap PO -> \(self.resultList.count) PB -> \(self.resultPostBoxList.count)")
        self.oldAnnotationView = nil
        switch self.locationMapViewModel!.selectedType {
        case .retrieve, .depot:
            self.filterButton.isHidden = false
        default:
            self.filterButton.isHidden = true
        }
//        if !self.resultList.isEmpty {
            self.clearAnnotations()
            var annotations = [Annotation]()
            for detail in self.resultList {
//                self.resultPostBoxList.removeAll()
                let annotation = Annotation()
                annotation.coordinate = detail.position
                annotation.title = detail.name
                annotation.style = .color(UIColor.lpDeepBlue, radius: 25)
                annotations.append(annotation)
            }
            self.clusterManager.add(annotations)
            Logger.shared.debug("LocationMapView Anotations -> \(annotations.count)")
            if var region = locationMapViewModel?.regionForAnnotations(annotations: annotations) {
                region = self.mapView.regionThatFits(region)
                self.mapView.setRegion(region, animated: true)
                self.clusterManager.reload(mapView: self.mapView)
            }
//        }
    }
    
    func refreshBoxMap() {
        Logger.shared.debug("LocationMapView refreshBoxMap PO -> \(self.resultList.count) PB -> \(self.resultPostBoxList.count)")
        self.oldAnnotationView = nil
//        if !self.resultPostBoxList.isEmpty {
//            self.resultList.removeAll()
            self.clearAnnotations()
            var annotations = [Annotation]()
            for detail in self.resultPostBoxList {
                let annotation = Annotation()
                annotation.coordinate = detail.position
                annotation.title = "Boîtes à lettres"
                annotation.style = .color(UIColor.lpDeepBlue, radius: 25)
                annotations.append(annotation)
            }
            self.clusterManager.add(annotations)
            Logger.shared.debug("LocationMapView Anotations -> \(annotations.count)")
            if var region = locationMapViewModel?.regionForAnnotations(annotations: annotations) {
                region = self.mapView.regionThatFits(region)
                self.mapView.setRegion(region, animated: true)
                self.clusterManager.reload(mapView: self.mapView)
//            }
        }
    }
    
    // MARK: - @IBAction
    
    @IBAction func centerToUserLocation(_ sender: Any) {
        if let location = self.locationManager {
            self.locationMapViewModel?.checkUserLocationpermissions(locationManager: location) { alertController in
                self.present(alertController, animated: true, completion: nil)
            }
            if let locationAllow = locationMapViewModel?.checkUserLocationpermissions(locationManager: location), locationAllow {
                self.checkWithUserLocation = true
                self.nextRegionChangeWasFromUserInteraction = true
                let center = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        guard let filterViewController = R.storyboard.location.locationFilterViewController() else { return }
        switch self.locationMapViewModel?.selectedType {
        case .postOffice?:
            filterViewController.filterType = .pointTypeBp
        case .retrieve?:
            filterViewController.filterType = .pointType
        case .depot?:
            filterViewController.filterType = .pointType
        default:
            filterViewController.filterType = nil
        }
        filterViewController.setFilterSelected(pointType: (self.locationMapViewModel?.pointTypeSelectedValue)!, day: (self.locationMapViewModel?.daySeletedValue)!, hour: (self.locationMapViewModel?.hourSelectedValue)!)
        filterViewController.delegate = self
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
}

extension LocationMapViewController: CLLocationManagerDelegate {
    func determineCurrentLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationMapViewModel?.checkUserLocationpermissions(locationManager: self.locationManager!) { alertController in
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[0] as CLLocation
        
        if self.checkWithUserLocation == true {
            if self.locationMapViewModel?.selectedLocation == nil {
                self.locationMapViewModel?.selectedLocation = location
            }
            self.manageLocation(location: location)
        }
    }
    
    func manageLocation(location: CLLocation) {
        if self.locationMapViewModel?.searchType == .text {
            return
        }
        if location.distance(from: (self.locationMapViewModel?.selectedLocation)!) > 2500 {
            self.locationMapViewModel?.selectedLocation = location
            self.resultList = [LOCPostalOffice]()
            self.resultPostBoxList = [LOCPostBox]()
            self.locationMapViewModel?.clearData()
        }
        
        if self.locationMapViewModel?.selectedType == SelectedType.postBox {
            if self.resultPostBoxList.isEmpty {
                self.delegate?.checkListWithType(type: (self.locationMapViewModel?.selectedType)!)
                self.filterButton.isHidden = true
            }
        } else if self.resultList.isEmpty {
            self.delegate?.checkListWithType(type: (self.locationMapViewModel?.selectedType)!)
        }
    }
    
    func clearAnnotations() {
        self.clusterManager.remove(self.clusterManager.annotations)
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
}

extension LocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        if let annotation = annotation as? ClusterAnnotation {
            guard let style = annotation.style else { return nil }
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view as? BorderedClusterAnnotationView {
                view.annotation = annotation
                view.style = style
                view.configure()
            } else {
                view = BorderedClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, style: style, borderColor: .clear)
            }
            return view
        } else {
            if self.locationMapViewModel?.selectedType == SelectedType.postBox {
                let reuseIdentifier = "LPB_pin"
                
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                
                annotationView?.image = R.image.ic_pin_letterbox()
                return annotationView
            } else if let postalOffice = self.getPostalOfficeFromCoordinate(annotation.coordinate) {
                let reuseIdentifier = "\(postalOffice.type ?? "LP")_pin"
                
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                
                annotationView?.image = self.locationMapViewModel?.getImageFromType(postalOffice.type)
                return annotationView
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.delegate?.hideDetail()
        if let view = mapView.subviews.first {
            for recognizer in view.gestureRecognizers! {
                if recognizer.state == .began || recognizer.state == .ended {
                    self.nextRegionChangeWasFromUserInteraction = true
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.clusterManager.reload(mapView: mapView) { finished in
            Logger.shared.debug("\(finished)")
        }
        if self.nextRegionChangeWasFromUserInteraction == true {
            self.nextRegionChangeWasFromUserInteraction = false
            let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.callMoveMapUpdateDate(timer:)), userInfo: location, repeats: false)
            } else {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.callMoveMapUpdateDate(timer:)), userInfo: location, repeats: false)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            zoomRect = mapView.mapRectThatFits(zoomRect, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20))
            mapView.setVisibleMapRect(zoomRect, animated: true)
        } else {
            mapView.deselectAnnotation(annotation, animated: true)
            if let oldAnnotationView = oldAnnotationView, let oldAnnotation = oldAnnotationView.annotation {
                if self.locationMapViewModel?.selectedType == SelectedType.postBox {
                    oldAnnotationView.image = R.image.ic_pin_letterbox()
                } else {
                    if let detailPostalOffice = getPostalOfficeFromCoordinate(oldAnnotation.coordinate) {
                        oldAnnotationView.image = self.locationMapViewModel?.getImageFromType(detailPostalOffice.type)
                    }
                }
            }
            self.oldAnnotationView = view
            if self.locationMapViewModel?.selectedType == SelectedType.postBox {
                if let detailPostalBox = getPostalBoxFromCoordinate(annotation.coordinate) {
                    self.delegate?.showDetailwith(postalBox: detailPostalBox)
                    view.image = R.image.ic_pin_letterbox_focus()
                }
            } else {
                if let detailPostalOffice = getPostalOfficeFromCoordinate(annotation.coordinate) {
                    view.image = self.locationMapViewModel?.getSelectedImageFromType(detailPostalOffice.type)
                    self.delegate?.showDetailWith(postalOffice: detailPostalOffice)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
    
    @objc func callMoveMapUpdateDate(timer: Timer) {
        if let location = timer.userInfo as? CLLocation {
            self.checkWithUserLocation = false
            if self.locationMapViewModel?.selectedLocation == nil {
                self.locationMapViewModel?.selectedLocation = location
            }
            self.manageLocation(location: location)
        }
    }
}

extension LocationMapViewController: LocationDelegate {
    func applyFilter(pointType: String, day: String, hour: String) {
        self.locationMapViewModel?.getList(pointType: pointType,
                                           day: day,
                                           hour: hour,
                                           onCompletetion: {
                                               self.locationMapViewModel?.setDayFilterIndex(with: day)
                                               self.locationMapViewModel?.setHourFilterIndex(with: hour)
                                               self.locationMapViewModel?.setPointTypeFilterIndex(with: pointType)
                                               self.setupFilterButton()
                                               self.resultList = self.locationMapViewModel?.getResultList() ?? self.resultList
        })
    }
}
