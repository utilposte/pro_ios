//
//  LocationFilterListTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 06/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class LocationFilterListTableViewCell: UITableViewCell {

    //IBOUTLETS
    @IBOutlet weak var hourButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIView!
    
    //PROPRETIES
    var delegate: LocationFilterDelegate?
    var itemSelectedIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonContainerView.cornerRadius = 5
        buttonContainerView.borderColor = .lpGrayShadow
        buttonContainerView.borderWidth = 1
    }
    
    @IBAction func hourButtonClicked(_ sender: Any) {
        delegate?.hourFilterButtonClicked()
    }
    
    func setupCell() {
        hourButton.setTitle(Constants.hoursList[itemSelectedIndex], for: .normal)
    }
    
    func resetContent() {
        hourButton.setTitle(Constants.hoursList[0], for: .normal)
        itemSelectedIndex = 0
    }
    
}
