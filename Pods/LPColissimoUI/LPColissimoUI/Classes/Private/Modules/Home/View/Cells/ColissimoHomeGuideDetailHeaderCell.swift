//
//  ColissimoHomeGuideDetailHeaderCell.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 22/10/2018.
//

import UIKit

class ColissimoHomeGuideDetailHeaderCell: UITableViewCell {

    @IBOutlet weak var guideDetailTitleLabel: UILabel!
    @IBOutlet weak var guideDetailExpandedImage : UIImageView!
    
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
        guideDetailTitleLabel.text = guide.title
        if guide.isExpanded == true {
            guideDetailExpandedImage.image = ColissimoHomeServices.loadImage(name: "up-arrow.png")
        }
        else {
            guideDetailExpandedImage.image = ColissimoHomeServices.loadImage(name: "down-arrow.png")
        }

    }
}
