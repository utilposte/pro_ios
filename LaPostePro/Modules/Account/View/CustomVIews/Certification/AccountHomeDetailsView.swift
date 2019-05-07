//
//  AccountHomeDetailsView.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 26/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class AccountHomeDetailsView: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.bottomRight, .bottomLeft], radius: 5)
    }

}
