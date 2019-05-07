//
//  TopCornerView.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class TopCornerRaduisView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .topRight], radius: 10)
    }

}

class TopBottomRadiusView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .bottomLeft], radius: 100)
    }
    
}
