//
//  ShareAndFavorisActionTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 15/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ShareAndFavorisActionTableViewCellDelegate: class {
    func addToFavorites()
}

class ShareAndFavorisActionTableViewCell: UITableViewCell {

    @IBOutlet weak var addFavorisView: UIView!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    weak var delegate: ProductDetailDelegate?
    weak var shareDelegate: ShareAndFavorisActionTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        addFavorisView.layer.cornerRadius = 5
        shareView.layer.cornerRadius = 5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shareViewClicked))
        shareView.addGestureRecognizer(tapGesture)
        
        let favoritesTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoritesViewClicked))
        addFavorisView.addGestureRecognizer(favoritesTapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func shareViewClicked() {
        if delegate != nil {
            delegate?.shareProduct()
        }
    }
    
    @objc func favoritesViewClicked() {
        if shareDelegate != nil {
            shareDelegate?.addToFavorites()
        }
    }

}
