//
//  ColissimoHomeGuideDetailCell.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 22/10/2018.
//

import UIKit

class ColissimoHomeGuideDetailCell: UITableViewCell {

    @IBOutlet weak var guideDetailTextLabel: UILabel!
    @IBOutlet weak var guideDetailImageViewContainer : UIView!
    
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var equalImagesConstraint: NSLayoutConstraint!
    var guide : HomeGuideDetailViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setUpCellWith(guide : HomeGuideDetailViewModel) {
        self.guide = guide
        guideDetailTextLabel.text = guide.text
//        setUpImage()
        if let image = ColissimoHomeServices.loadImage(name: guide.images [0]) {
            imageView1.image = image
        }
        if guide.images.count == 2 {
            if let image = ColissimoHomeServices.loadImage(name: guide.images [1]) {
                imageView2.image = image
                imageView2.isHidden = false
            }
        }
        else {
            imageView2.image = nil
            imageView2.isHidden = true
        }
        
    }
}
