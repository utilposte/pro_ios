//
//  SearchShipmentCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 25/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedSUIVI


class SearchShipmentCell: UITableViewCell {

    @IBOutlet weak var numberShipmentLabel: UILabel!
    @IBOutlet weak var shipmentImageView: UIImageView!
    @IBOutlet weak var statusShipmentLabel: UILabel!
    @IBOutlet weak var dateShipmentLabel: UILabel!
    
    var responseTrack : ResponseTrack?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func configureCellWith(shipment : CacheShipmentTrack) -> SearchShipmentCell? {
        guard let code = shipment.code else { return nil}
        if let currentTrack = CacheShipmentTrack.getResponseTrack(code: code) {
            return SearchShipmentCell.configureCellWith(shipment: currentTrack)
        }
        return nil
    }
    
    class func configureCellWith(shipment : ResponseTrack) -> SearchShipmentCell? {
        let nibArray = Bundle.main.loadNibNamed("SearchShipmentCell", owner: self, options: nil)
        let cell = nibArray?.first as? SearchShipmentCell
        cell?.setUpCellWith(shipment: shipment)
        cell?.refreshShipment()
        return cell
    }
    
    private func refreshShipment() {
        guard let code = self.responseTrack?.num else {
            return
        }
        TrackManager.shared.setHost("https://www.laposte.fr")
        TrackManager.shared.getShipmentFor(trackCode: code, completion:{ success, responseFollow in
            if success, let shipment = responseFollow {
                _ = CacheShipmentTrack.save(responseTrack: shipment)
                self.setUpCellWith(shipment: shipment)
            }
        })
    }
    
    private func setUpCellWith(shipment : ResponseTrack) {
        self.responseTrack = shipment
        
        if shipment.shipment?.product == "colis" || shipment.shipment?.product == "colissimo" {
            self.shipmentImageView.image = R.image.colissimo()!
        }
        else if shipment.shipment?.product == "chronopost" {
            self.shipmentImageView.image = R.image.chronopost()!
        }
        else {
            self.shipmentImageView.image = R.image.letters()!
        }
        self.numberShipmentLabel.text   = "Suivi n° \(shipment.num ?? "")"
        let events: [DetailEventTrack]  = (shipment.shipment?.events?.event)!
        self.statusShipmentLabel.text   = events.first?.label ?? ""
        self.dateShipmentLabel.text     = " - \(events.first?.date ?? "")"
    }
    
}
