//
//  CertificationContainerView.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 24/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class CertificationContainerView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .topRight], radius: 10)
    }

}
