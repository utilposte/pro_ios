//
//  LocationDetailMediumCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 09/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedLOC
import MapKit
import RealmSwift
import Contacts

protocol LocationDetailMediumCellDelegate {
    func favoriteButtonDidTapped(postalOffice: LOCPostalOffice)
    func favoriteButtonDidDeleted(postalOffice: LOCPostalOffice)
}

class LocationDetailMediumCell: UITableViewCell {
    
    @IBOutlet weak var areaImageView: UIImageView!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var isOpenCercleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    //    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var itineraryButton: UIButton!
    @IBOutlet weak var saveInFavoritesLabel: UILabel!
    @IBOutlet weak var closedView: UIView!
    
    var isFavorites: Bool = false
    var delegate : LocationDetailCellDelegate?
    var mediumDelegate: LocationDetailMediumCellDelegate?
    
    var position : CLLocationCoordinate2D?
    var _postalOffice: LOCPostalOffice?
    var addressDict = [String : Any]()
    var routeString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpView(postalOffice : LOCPostalOffice) {
        self._postalOffice = postalOffice
        
        // PIN Image
        self.setUpImageWith(typeString: postalOffice.type, coordiante: postalOffice.position)
        // Open Status
        closedView.isHidden = false
        if let status = postalOffice.statut.statut, status.lowercased() == "ouvert" {
            closedView.isHidden = true
        }
        // Name
        titleLabel.text = postalOffice.name
        //        titleCellLabel.text = postalOffice.name
        // Type
        typeLabel.text = getPointType(postalOffice.type)
        
        // adress
        let addressString = "\(postalOffice.adresse ?? ""), \(postalOffice.codePostal ?? "") \(postalOffice.localite ?? "")"
        adressLabel.text = addressString
        
        itineraryButton.titleLabel?.lineBreakMode = .byWordWrapping
        itineraryButton.titleLabel?.numberOfLines = 0
        
        favoriteButton.titleLabel?.lineBreakMode = .byWordWrapping
        favoriteButton.titleLabel?.numberOfLines = 0
        
        
        // CHECK IF POSTALOFFICE IN IS FAVORITE
        if let codeSite = postalOffice.codeSite {
            do {
                let realm = try Realm()
                if realm.objects(PostalOffice.self).filter("codeSite == '\(codeSite)'").count > 0 {
                    
                    let textAttachment = NSTextAttachment()
                    textAttachment.image = UIImage(named: "ic_small_favorite")
                    let attachmentString = NSAttributedString(attachment: textAttachment)
                    
                    let myString = NSMutableAttributedString(string: "")
                    myString.append(attachmentString)
                    myString.custom(" Lieu présent dans vos favoris", font: UIFont.systemFont(ofSize: 14), color: UIColor.lpGrey)
                    self.saveInFavoritesLabel.attributedText = myString
                    
                    favoriteButton.setTitle(" Retirer\n des favoris", for: .normal)
                    favoriteButton.setImage(R.image.removeFavorites(), for: .normal)
                    self.isFavorites = true
                } else {
                    self.saveInFavoritesLabel.text = ""
                    favoriteButton.setTitle("Ajouter aux favoris", for: .normal)
                    favoriteButton.setImage(R.image.ic_addToFavorite(), for: .normal)
                    self.isFavorites = false
                }
            } catch let error as NSError {
                Logger.shared.debug(error.localizedDescription)
            }
        }
        
        itineraryButton.titleLabel?.lineBreakMode = .byWordWrapping
        itineraryButton.titleLabel?.numberOfLines = 0
        
        
        addressDict = [String(CNPostalAddressStreetKey) as String: postalOffice.adresse,
                       String(CNPostalAddressCityKey) as String: postalOffice.localite,
                       String(CNPostalAddressPostalCodeKey) as String: postalOffice.codePostal]
        routeString = "comgooglemaps://?daddr=\(postalOffice.adresse.replacingOccurrences(of: " ", with: "+")),\(postalOffice.codePostal.replacingOccurrences(of: " ", with: "+"))&center=\(postalOffice.latitude),\(postalOffice.longitude)"
        
    }
    
    func setUpView(postalBox : LOCPostBox) {
        self.setUpImageWith(typeString: "BAL", coordiante: postalBox.position)
        // Name
        titleLabel.text = postalBox.lb_com
        //        titleCellLabel.text = postalBox.lb_com
        
        // adress
        let addressString = "\(postalBox.va_no_voie ?? "") \(postalBox.lb_voie_ext ?? "")\n\(postalBox.co_postal ?? "") \(postalBox.co_insee_com ?? "")"
        adressLabel.text = addressString
        
        // No Status
        closedView.isHidden = true
        
        let address = "\(postalBox.va_no_voie ?? "") \(postalBox.lb_voie_ext ?? ""))"
        addressDict = [String(CNPostalAddressStreetKey) as String: address,
                       String(CNPostalAddressCityKey) as String: postalBox.co_insee_com,
                       String(CNPostalAddressPostalCodeKey) as String: postalBox.co_postal]
        routeString = "comgooglemaps://?daddr=\(address.replacingOccurrences(of: " ", with: "+")),\(postalBox.co_insee_com.replacingOccurrences(of: " ", with: "+"))&center=\(postalBox.latitude),\(postalBox.longitude)"
        
    }
    
    
    func setUpImageWith(typeString : String?, coordiante: CLLocationCoordinate2D) {
        self.position = coordiante
        let rect = self.areaImageView.bounds
        self.getAreaImage(coordiante: coordiante).start(completionHandler: { (snapshot, error) in
            self.areaImageView.image = snapshot?.image
            guard let snapshot = snapshot, error == nil else {
                return
            }
            UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.width, height: rect.height), true, 0)
            snapshot.image.draw(at: .zero)
            let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            let pinImage = self.getImageFromType(typeString)
            
            var point = snapshot.point(for: coordiante)
            
            if rect.contains(point) {
                let pinCenterOffset = pinView.centerOffset
                point.x -= pinView.bounds.size.width / 2
                point.y -= pinView.bounds.size.height / 2
                point.y += pinCenterOffset.y
                pinImage.draw(at: point)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            DispatchQueue.main.async {
                self.areaImageView.image = image
            }
        })
    }
    
    // TO MOVE TO VIEWMODEL
    func getImageFromType(_ typeString : String?) -> UIImage {
        guard let type = typeString else {
            return R.image.ic_pin_bp()!
        }
        if type == "A2P" {
            return R.image.ic_pin_shop()!
        }
        else if type == "CDI" {
            return R.image.ic_pin_pickup()!
        }
        else if type == "BAL" {
            return R.image.ic_pin_letterbox()!
        }
        return R.image.ic_pin_bp()!
    }
    
    func getPointType(_ typeString: String?) -> String {
        guard let type = typeString else {
            return "BUREAU DE POSTE"
        }
        switch type.lowercased() {
        case "bp":
            return "BUREAU DE POSTE"
        case "a2p":
            return "COMMERCE"
        case "cdi":
            return "COMMERCE"
        case "box":
            return "BOITE A LETTRES"
        default:
            return "BUREAU DE POSTE"
        }
    }
    
    
    func getAreaImage(coordiante: CLLocationCoordinate2D) -> MKMapSnapshotter {
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        let region = MKCoordinateRegionMakeWithDistance(coordiante, 1000, 1000)
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: self.areaImageView.bounds.width, height: self.areaImageView.bounds.height)
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        return MKMapSnapshotter(options: mapSnapshotOptions)
    }
    
    @IBAction func hideDetails() {
        delegate?.hideDetails()
    }
    
    @IBAction func showItinerary() {
        Logger.shared.verbose("showItinerary --> Medium")
        if let position = self.position {
            delegate?.showItinirary(postalOfficeCoordinate: position, addressDict: addressDict, routeString: routeString)
        }
    }
    
    @IBAction func addToFavorite() {
        if let postalOffice = self._postalOffice {
            if self.isFavorites {
                self.mediumDelegate?.favoriteButtonDidDeleted(postalOffice: postalOffice)
            } else {
                self.mediumDelegate?.favoriteButtonDidTapped(postalOffice: postalOffice)
            }
        }
    }
    
}

