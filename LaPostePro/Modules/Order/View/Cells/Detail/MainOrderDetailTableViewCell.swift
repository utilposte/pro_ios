//
//  MainOrderDetailTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 31/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class MainOrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var refLabel: UILabel!
    @IBOutlet weak var dateAndStatusLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var mainButtonView: UIView!
    @IBOutlet weak var mainButtonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainButtonViewTopConstraint: NSLayoutConstraint!
    
    var mainActionClosure : (() -> ())? = nil

    func configureCell(mainActionClosure: @escaping () -> (), needMainButton: Bool = true) {
        
        if needMainButton {
            self.mainActionClosure = mainActionClosure
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.mainButtonTapped (_:)))
            self.mainButtonView.addGestureRecognizer(gesture)
            self.mainButtonViewHeightConstraint.constant = 44
            self.mainButtonViewTopConstraint.constant = 20
        }
        else {
            self.mainButtonViewHeightConstraint.constant = 0
            self.mainButtonViewTopConstraint.constant = 0
            self.mainButtonView.isHidden = true
        }
    }
    
    @objc func mainButtonTapped(_ sender:UITapGestureRecognizer) {
        self.mainActionClosure?()
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCommandeIdentique,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kMyOrders,
                                                              chapter2: TaggingData.kOrderDetails,
                                                              level2: TaggingData.kAccountLevel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
}
