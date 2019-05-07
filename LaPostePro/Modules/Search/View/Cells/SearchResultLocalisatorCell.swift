//
//  SearchResultLocalisatorCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 19/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import MapKit
import LPSharedLOC

class SearchResultLocalisatorCell: UITableViewCell {

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationAdressLabel: UILabel!
    @IBOutlet weak var closedView: UIView!
    
    var postalOffice : LOCPostalOffice?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func configureCellWith(item : LOCPostalOffice) -> SearchResultLocalisatorCell? {
        
        let nibArray = Bundle.main.loadNibNamed("SearchResultLocalisatorCell", owner: self, options: nil)
        let cell = nibArray?.first as? SearchResultLocalisatorCell
        cell?.setUpImageWith(coordiante: item.position)
        cell?.postalOffice = item
        cell?.locationTitleLabel.text = item.name
        cell?.locationAdressLabel.text = "\(item.adresse ?? ""), \(item.localite ?? "") \(item.codePostal ?? "")"
        cell?.closedView.isHidden = (item.statut.statut.lowercased() == "ouvert")
        return cell
    }
    
    func setUpImageWith(coordiante: CLLocationCoordinate2D) {
//        self.position = coordiante
        let rect = self.locationImageView.bounds
        self.getAreaImage(coordiante: coordiante).start(completionHandler: { (snapshot, error) in
            self.locationImageView.image = snapshot?.image
            guard let snapshot = snapshot, error == nil else {
                return
            }
            UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.width, height: rect.height), true, 0)
            snapshot.image.draw(at: .zero)
            let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            let pinImage = R.image.ic_pin_bp()!
            
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
                self.locationImageView.image = image
            }
        })
    }
    
    func getAreaImage(coordiante: CLLocationCoordinate2D) -> MKMapSnapshotter {
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        let region = MKCoordinateRegionMakeWithDistance(coordiante, 1000, 1000)
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: self.locationImageView.bounds.width, height: self.locationImageView.bounds.height)
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        return MKMapSnapshotter(options: mapSnapshotOptions)
    }
}
