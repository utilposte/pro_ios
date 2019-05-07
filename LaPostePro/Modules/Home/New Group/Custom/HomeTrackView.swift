//
//  HomeTrackView.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 01/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedSUIVI

protocol HomeTrackViewDelegate {
    func showTrackDetail(track : ResponseTrack)
}

class HomeTrackView: UIView {

    @IBOutlet weak var numberShipmentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shipmentImageView: UIImageView!
    var responseTrack : ResponseTrack?
    var delegate : HomeTrackViewDelegate?
    lazy var loaderManager = LoaderViewManager()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    class func getTrackView(_ shipment : ResponseTrack, width : Int, originY : Int) -> HomeTrackView? {
        let nibArray = Bundle.main.loadNibNamed("HomeTrackView", owner: self, options: nil)
        if let view = nibArray?.first as? HomeTrackView {
            view.frame = CGRect(x: 0, y: originY, width: width, height: 107)
            view.setNeedsUpdateConstraints()
            view.setNeedsLayout()
            view.layoutIfNeeded()
            view.responseTrack = shipment
            
            let status = (shipment.shipment?.isFinal ?? false) ? "Livré" : "En cours"
            view.statusLabel.attributedText = NSMutableAttributedString()
            .bold(status, size: 14)
            
            
            if shipment.shipment?.product == "colis" || shipment.shipment?.product == "colissimo" {
                view.shipmentImageView.image = R.image.colissimo()!
                view.numberShipmentLabel.text   = "Suivi du colis n° \(shipment.num ?? "")"
            }
            else if shipment.shipment?.product == "chronopost" {
                view.shipmentImageView.image = R.image.chronopost()!
                view.numberShipmentLabel.text   = "Suivi du colis n° \(shipment.num ?? "")"
            }
            else {
                view.shipmentImageView.image = R.image.letters()!
                view.numberShipmentLabel.text   = "Suivi n° \(shipment.num ?? "")"
            }
            return view
        }
        return nil
    }
    
    @IBAction func showTrackDetail() {
        guard let code = self.responseTrack?.num else {
            return
        }
        self.loaderManager.showLoderView()
        TrackManager.shared.setHost("https://www.laposte.fr")
        TrackManager.shared.getShipmentFor(trackCode: code, completion:{ success, responseFollow in
            self.loaderManager.hideLoaderView()
            if success, let shipment = responseFollow {
                _ = CacheShipmentTrack.save(responseTrack: shipment)
                self.delegate?.showTrackDetail(track: shipment)
            }
            else {
                self.delegate?.showTrackDetail(track: self.responseTrack!)
            }
        })
        
    }
    
    
}
