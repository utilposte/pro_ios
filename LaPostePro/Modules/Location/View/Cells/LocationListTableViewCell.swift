//
//  LocationListTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedLOC
import MapKit

@objc protocol LocationListTableViewCellDelegate {
    @objc optional func crossButtonDidTapped(office: PostalOffice)
}

class LocationListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var areaImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var disponibilityLabel: UILabel!
    @IBOutlet weak var disponibilityView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var closedView: UIView!

    weak var delegate: LocationListTableViewCellDelegate?
    
    var viewModel: LocationViewModel?
    var imageArea: MKMapSnapshotter?
    
    var postalOffice: PostalOffice?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.areaImageView.contentMode = .center
        self.areaImageView.image = R.image.locatorInactive()
    }
    
    func setup(index: Int) {
        let rect = self.areaImageView.bounds
        self.areaImageView.image = R.image.locatorInactive()
        imageArea = viewModel?.getAreaImage(index: index)
        imageArea?.start(completionHandler: { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 140, height: 140), true, 0)
            snapshot.image.draw(at: .zero)
            
            //check index item in array due to async image creation (app may crash if user change point type before image creation)
            if (self.viewModel?.isCellDidExist(index: index) ?? false) {
                let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                let pinImage = self.viewModel?.getImageFromType(self.viewModel?.getPointType(index: index))
                
                var point = snapshot.point(for: (self.viewModel?.getPointPosition(index: index).location.coordinate) ?? CLLocationCoordinate2DMake(0, 0))
                
                if rect.contains(point) {
                    let pinCenterOffset = pinView.centerOffset
                    point.x -= pinView.bounds.size.width / 2
                    point.y -= pinView.bounds.size.height / 2
                    point.x += pinCenterOffset.x
                    point.y += pinCenterOffset.y
                    pinImage?.draw(at: point)
                }
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                // do whatever you want with this image, e.g.
                
                DispatchQueue.main.async {
                    self.areaImageView.image = image
                }
            } else {
                self.areaImageView.image = R.image.locatorInactive()
            }
        })
        if let type = viewModel?.getPointType(type: viewModel?.getPointType(index: index) ?? "") {
            typeLabel.text = type
        }
        if let name = viewModel?.getPointName(index: index) {
            nameLabel.text = name
        }
        if let street = viewModel?.getPointStreet(index: index) {
            streetLabel.text = street
        }
        if let town = viewModel?.getPointTown(index: index) {
            townLabel.text = town
        }
        
        // Open Status
        closedView.isHidden = false
        if let disponibility = viewModel?.getPointStatus(index: index).lowercased() , disponibility == "ouvert"{
            closedView.isHidden = true
        }
        
        if viewModel?.selectedType == .postBox {
           closedView.isHidden = true
        }
    }
    
    func setupCellFavorites(office: PostalOffice) {
        self.postalOffice = office
        let favoriteViewModel = FavoriteViewModel()
        
        let rect = self.areaImageView.bounds
        self.areaImageView.image = R.image.locatorInactive()
        self.imageArea = favoriteViewModel.getAreaImage(office: office)
        self.imageArea?.start(completionHandler: { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 140, height: 140), true, 0)
            snapshot.image.draw(at: .zero)
            
            //check index item in array due to async image creation (app may crash if user change point type before image creation)
            let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            let pinImage = favoriteViewModel.getImageFromType(favoriteViewModel.getPointType(type: office.type ?? "BUREAU DE POSTE"))
            var point = snapshot.point(for: (CLLocationCoordinate2DMake(CLLocationDegrees(exactly: office.latitude)!, CLLocationDegrees(exactly: office.longitude)!)).location.coordinate)
            
            if rect.contains(point) {
                let pinCenterOffset = pinView.centerOffset
                point.x -= pinView.bounds.size.width / 2
                point.y -= pinView.bounds.size.height / 2
                point.x += pinCenterOffset.x
                point.y += pinCenterOffset.y
                pinImage.draw(at: point)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // do whatever you want with this image, e.g.
            
            DispatchQueue.main.async {
                self.areaImageView.image = image
            }
        })
//        if let type = office.type {
            typeLabel.text = office.type ?? "BUREAU DE POSTE"
//        }
        
        if let name = office.name {
            nameLabel.text = name
        }
        
        if let adresse = office.adresse {
            streetLabel.text = adresse
        }
        
        if let city = office.localite, let postalCode = office.codePostal {
            townLabel.text = "\(postalCode) \(city)"
        }
        
        // Open Status
        self.disponibilityLabel.isHidden = false
        self.disponibilityView.isHidden = false
        if closedView == nil {
            if let status = office.statut, status.lowercased() == "ouvert" {
                self.disponibilityLabel.isHidden = true
                self.disponibilityView.isHidden = true
            }
            if let selectedType = viewModel?.selectedType, selectedType == .postBox {
                self.disponibilityLabel.isHidden = true
                self.disponibilityView.isHidden = true
            }
        }
        
    }
    
    @IBAction func crossButtonTapped(_ sender: Any) {
        if self.postalOffice?.isInvalidated == false {
            if let office = self.postalOffice {
                self.delegate?.crossButtonDidTapped!(office: office)
            }
        }
    }
    
    override func prepareForReuse() {
        self.areaImageView.image = R.image.locatorInactive()
        self.imageArea?.cancel()
    }
}
