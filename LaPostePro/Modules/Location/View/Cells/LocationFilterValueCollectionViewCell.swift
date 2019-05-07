//
//  LocationFilterValueCollectionViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 03/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class LocationFilterValueCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var selectedCellImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    let viewModel = LocationFilterViewModel()
    
    func setup(with type: FilterType, index: Int, isSelected: Bool) {
        selectedCellImageView.isHidden = !isSelected
        if isSelected {
            setCellAsSelected()
        } else {
            containerView.borderColor = .lpGrayShadow
        }
        valueLabel.text = viewModel.getFilterItemText(type: type, index: index)
        containerView.borderWidth = 1
        containerView.cornerRadius = 5
    }
    
    private func setCellAsSelected() {
        valueLabel.textColor = .lpDeepBlue
        valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        containerView.borderColor = .lpPurple
    }
    override func prepareForReuse() {
        valueLabel.textColor = .lpGrey
        containerView.borderColor = .lpGrayShadow
        valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
}
