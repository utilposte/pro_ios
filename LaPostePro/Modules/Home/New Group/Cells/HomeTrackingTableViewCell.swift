//
//  HomeTrackingTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 08/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedSUIVI

protocol HomeTrackingTableViewCellDelegate {
    func showTrackView()
    func showScanView()
    func showTrackDetail(track: ResponseTrack)
}

class HomeTrackingTableViewCell: UITableViewCell {

    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationToTrackModuleButton: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emptyTrackView: UIView!
    @IBOutlet weak var openTrackViewButton: UIButton!
    
    var delegate : HomeTrackingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setUpCell(tracks : [ResponseTrack], showMore : Bool) {
        clearOldTracks()
        if tracks.count == 0 {
            emptyTrackView.isHidden = false
            cellHeightConstraint.constant = 200
        }
        else {
            emptyTrackView.isHidden = true
            let width   : CGFloat = containerView.bounds.size.width
            var height  : CGFloat = 70
            var originY = 0
            for track in tracks {
                if let trackView = HomeTrackView.getTrackView(track, width: Int(width), originY : originY) {
                    originY = originY+107
                    height  = height+107
                    trackView.delegate = self
                    containerView.addSubview(trackView)
                    Logger.shared.debug("viewAdded : \(originY) :: \(height)")
                }
                else {
                    emptyTrackView.isHidden = false
                    cellHeightConstraint.constant = 200
                    return
                }
            }
            if showMore == true {
                openTrackViewButton.isHidden = false
                height = height+30
            }
            cellHeightConstraint.constant = height
        }
    }
    
    func clearOldTracks() {
        openTrackViewButton.isHidden = true
        cellHeightConstraint.constant = 200
        let views = containerView.subviews
        for view in views {
            if view.classForCoder == HomeTrackView.classForCoder() {
                view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func showTrackView(_ sender: UIButton) {
        var clickLibelle = TaggingData.kNouveauColis
        if sender == openTrackViewButton {
            clickLibelle = TaggingData.kTousLesSuivis
        }
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: clickLibelle,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kHomeConnected,
                                                              chapter2: TaggingData.kSuivre,
                                                              level2: TaggingData.kHomeLevel)
        delegate?.showTrackView()
    }
    
    @IBAction func showScanView(_ sender: UIButton) {
        delegate?.showScanView()
    }
}


extension HomeTrackingTableViewCell: HomeTrackViewDelegate {
    func showTrackDetail(track: ResponseTrack) {
        delegate?.showTrackDetail(track: track)
    }
}

