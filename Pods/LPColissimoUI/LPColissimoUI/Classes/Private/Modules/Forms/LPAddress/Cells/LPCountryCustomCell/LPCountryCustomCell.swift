//
//  LPCountryCustomCell.swift
//  laposte
//
//  Created by Sofien Azzouz on 15/01/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

@objc protocol LPCountryCellDelegate: class {
    @objc func countryNameButtonClicked()
}

class LPCountryCustomCell: LPBaseCustomCell {
    
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!

    var delegate: LPCountryCellDelegate?
    
    func initCellWithCountryName(countryName: String?, isEnabled: Bool) {
        self.countryButton.setTitle(countryName, for: UIControlState.normal)
        if isEnabled == false {
            self.countryButton.isEnabled = false
            self.arrowImageView.isHidden = true
            self.countryButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    override func cellHeight() -> CGFloat {
        return 80
    }
    
    @IBAction func countryButtonClicked(_ sender: Any) {
        self.delegate?.countryNameButtonClicked()
    }
    
    
}

