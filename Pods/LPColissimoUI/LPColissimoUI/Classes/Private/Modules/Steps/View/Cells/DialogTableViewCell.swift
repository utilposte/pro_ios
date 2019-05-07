//
//  DialogTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 20/11/2018.
//

import UIKit

class DialogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var triangleImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var triangleConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = 10
        self.containerView.backgroundColor = UIColor.init(red: 29/255, green: 179/255, blue: 132/255, alpha: 1)
    }
    
    func setupCell(title: String, content: String, firstSelected: Bool) {
        self.triangleImageView.image = ColissimoHomeServices.loadImage(name:"triangle.png")
        if firstSelected {
            triangleConstraint.constant = self.containerView.bounds.width * (-0.25)
        } else {
            triangleConstraint.constant = self.containerView.bounds.width * (0.25)
        }
        
        self.title.text = title
        self.content.text = content

        // CUSTOM
        self.title.textColor = .white
        self.title.numberOfLines = 0
        
        self.content.textColor = .white
        self.content.numberOfLines = 0
    }
    
}
