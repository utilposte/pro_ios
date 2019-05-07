//
//  UsePosition.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 12/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol UsePositionDelegate {
    func usePositionToGetAddress()
}

class UsePosition: UIView {
    
    @IBOutlet weak var usePositionButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    var delegate: UsePositionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        separatorView.backgroundColor = .lpGrayShadow
        usePositionButton.cornerRadius = 5
        usePositionButton.borderColor = UIColor.lpGrayShadow
        usePositionButton.borderWidth = 1
    }
    
    @IBAction func usePositionButtonClicked(_ sender: Any) {
        delegate?.usePositionToGetAddress()
    }
    
}
