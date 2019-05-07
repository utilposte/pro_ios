//
//  HashTagCollectionViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 13/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol HashTagCollectionViewCellDelegate: class {
    func crossButtonDidTapped(indexPath: IndexPath)
}

class HashTagCollectionViewCell: UICollectionViewCell {
    weak var delegate: HashTagCollectionViewCellDelegate?
    var currentIndexPath: IndexPath?
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!

    @IBAction func crossButtonTapped(_ sender: Any) {
        guard let indexPath = currentIndexPath else { return }
        self.delegate?.crossButtonDidTapped(indexPath: indexPath)
    }

}
