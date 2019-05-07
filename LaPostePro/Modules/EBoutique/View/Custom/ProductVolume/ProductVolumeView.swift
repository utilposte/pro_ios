//
//  ProductVolumeView.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 17/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ProductVolumeView: UIView {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("ProductVolumeView", owner: nil, options: nil)![0] as? ProductVolumeView ?? UIView()
    }
    
    func setUpView(volumePrice : VolumePrice, y : Int) {
        self.frame = CGRect(x: 0, y: y, width: Int(UIScreen.main.bounds.width-40), height: 50)
        durationLabel.text = volumePrice.range
        priceLabel.text = volumePrice.price
        
        if ((y/50) % 2 == 0 ){
            self.backgroundColor = .white
        }
    }
}
