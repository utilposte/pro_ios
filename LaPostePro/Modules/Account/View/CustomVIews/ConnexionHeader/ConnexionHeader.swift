//
//  ConnexionHeader.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 19/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ConnexionHeader: UIView {

    @IBOutlet weak var connexionHeaderLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupText()
    }
    
    private func setupText() {
        connexionHeaderLabel.attributedText = NSMutableAttributedString()
            .custom("Les solutions de La Poste dédiées aux ", font: UIFont.systemFont(ofSize: 24, weight: .regular), color: .white)
            .custom("Pros", font: UIFont.systemFont(ofSize: 24, weight: .semibold), color: .lpPurple)
    }

}
