//
//  CLRecapCell.swift
//  Pods
//
//  Created by LaPoste on 07/12/2018.
//

import UIKit

class CLRecapCell: UITableViewCell {

    @IBOutlet weak var recapImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var updateImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    func setupDetail(recap: Recap) {
        self.updateImageView.image = ColissimoHomeServices.loadImage(name: "edit_recap.png")
        if let image = recap.image {
            if let image = ColissimoHomeServices.loadImage(name: image) {
                self.recapImageView.image = image
            }
        }
        
        if let title = recap.title {
            self.titleLabel.text = title.uppercased()
            self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        }
        
        if let description = recap.description {
            self.descriptionLabel.text = description.uppercased()
            self.descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }
    
    func setupColisInfos(recap: Recap) {
        self.updateImageView.image = ColissimoHomeServices.loadImage(name: "edit_recap.png")
        if let image = recap.image {
            if let image = ColissimoHomeServices.loadImage(name: image) {
                self.recapImageView.image = image
            }
        }
        
        if let title = recap.title {
            self.titleLabel.text = title.uppercased()
            self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        if let description = recap.description {
            self.descriptionLabel.text = description.uppercased()
            self.descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        }
    }
    
    func setupAddressCell(title: String, description: String ,additionnal: String, image: String) {
        self.updateImageView.image = ColissimoHomeServices.loadImage(name: "edit_recap.png")
        self.titleLabel.text = title
        self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
        let attributedString = NSMutableAttributedString()
        
        let descriptionAttributed = NSAttributedString(string: description, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .semibold)])
        
        attributedString.append(descriptionAttributed)
        
        let additionnalAttributed = NSAttributedString(string: additionnal, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: .light), NSAttributedStringKey.foregroundColor: UIColor.lpOrange])
        
        attributedString.append(additionnalAttributed)
        self.descriptionLabel.attributedText = attributedString
        
        if let image = ColissimoHomeServices.loadImage(name: image) {
            self.recapImageView.image = image
        }
    }
}
