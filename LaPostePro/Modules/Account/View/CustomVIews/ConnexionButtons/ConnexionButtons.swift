//
//  ConnexionButtons.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 19/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ConnexionButtonsDelegate {
    func forgotPassword()
    func connexion()
    func register()
}

class ConnexionButtons: UIView {

    @IBOutlet weak var connexionButton: UIButton!
    
    var delegate: ConnexionButtonsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        delegate?.forgotPassword()
    }
    
    @IBAction func connexionClicked(_ sender: Any) {
        delegate?.connexion()
    }
    @IBAction func registerClicked(_ sender: Any) {
        delegate?.register()
    }
    
}
