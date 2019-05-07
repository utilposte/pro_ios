//
//  LocationDetailMinimumCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 07/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedLOC
import Contacts

class LocationDetailMinimumCell: UITableViewCell {

    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var isOpenCercleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var closedView: UIView!
    
    var delegate : LocationDetailCellDelegate?
    
    var position : CLLocationCoordinate2D?
    var addressDict = [String : Any]()
    var routeString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureView(officeDetail : LOCPostalOffice) {
        self.position = officeDetail.position
        titleLabel.text = officeDetail.name ?? ""
        // Open Status
        closedView.isHidden = false
        if let status = officeDetail.statut.statut, status.lowercased() == "ouvert" {
            closedView.isHidden = true
        }
        // Name
        titleLabel.text = officeDetail.name
        // adress
        let addressString = "\(officeDetail.adresse ?? ""), \(officeDetail.codePostal ?? "") \(officeDetail.localite ?? "")"
        adressLabel.text = addressString
        
        addressDict = [String(CNPostalAddressStreetKey) as String: officeDetail.adresse,
                       String(CNPostalAddressCityKey) as String: officeDetail.localite,
                       String(CNPostalAddressPostalCodeKey) as String: officeDetail.codePostal]
        routeString = "comgooglemaps://?daddr=\(officeDetail.adresse.replacingOccurrences(of: " ", with: "+")),\(officeDetail.codePostal.replacingOccurrences(of: " ", with: "+"))&center=\(officeDetail.latitude),\(officeDetail.longitude)"
    }
    
    func configureView(boxDetail : LOCPostBox) {
        self.position = boxDetail.position
        // Name
        titleLabel.text = boxDetail.lb_com
        
        // adress
        let addressString = "\(boxDetail.va_no_voie ?? "") \(boxDetail.lb_voie_ext ?? "")\n\(boxDetail.co_postal ?? "")"
        adressLabel.text = addressString
        
        // No Status
        closedView.isHidden = true
        
        let address = "\(boxDetail.va_no_voie ?? "") \(boxDetail.lb_voie_ext ?? ""))"
        addressDict = [String(CNPostalAddressStreetKey) as String: address,
                       String(CNPostalAddressCityKey) as String: boxDetail.co_insee_com,
                       String(CNPostalAddressPostalCodeKey) as String: boxDetail.co_postal]
        routeString = "comgooglemaps://?daddr=\(address.replacingOccurrences(of: " ", with: "+")),\(boxDetail.co_insee_com.replacingOccurrences(of: " ", with: "+"))&center=\(boxDetail.latitude),\(boxDetail.longitude)"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func showItinerary() {
        if let position = self.position {
            delegate?.showItinirary(postalOfficeCoordinate: position, addressDict: addressDict, routeString: routeString)
        }
    }
}
