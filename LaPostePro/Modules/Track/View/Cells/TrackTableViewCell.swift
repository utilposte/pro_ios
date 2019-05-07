//
//  TrackTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 03/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import Foundation
import LPSharedSUIVI

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateStatusLabel: UILabel!
    @IBOutlet weak var trackNumber: UILabel!
    @IBOutlet weak var deliveryModeImage: UIImageView!
    @IBOutlet weak var moreDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.borderColor = UIColor.lpGrayShadow.cgColor
        self.containerView.layer.borderWidth = 1
        self.moreDetailsLabel.text = "Plus de détails"
    }
    
    func setupCell(shipment: CacheShipmentTrack) {
        guard let code = shipment.code else { return }
        let currentTrack = CacheShipmentTrack.getResponseTrack(code: code)
        if currentTrack?.shipment?.product == "colis" || currentTrack?.shipment?.product == "colissimo" {
            self.deliveryModeImage.image = R.image.colissimo()!
        } else if currentTrack?.shipment?.product == "chronopost" {
            self.deliveryModeImage.image = R.image.chronopost()!
        } else {
            self.deliveryModeImage.image = R.image.letters()!
        }
        self.trackNumber.text = "Suivi n° \(currentTrack?.num ?? "")"
        let events: [DetailEventTrack] = (currentTrack?.shipment?.events?.event)!
        self.dateStatusLabel.text = events.first?.label ?? ""
    }
}
