//
//  ColissimoHomeGuideCell.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 22/10/2018.
//

import UIKit

class ColissimoHomeGuideCell: UITableViewCell {

    @IBOutlet weak var guideTitleLabel: UILabel!
    @IBOutlet weak var guideSubtitleLabel: UILabel!
    @IBOutlet weak var isExpandedCell: UIView!
    
    var guide : HomeGuideViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCellWith(guide : HomeGuideViewModel) {
        self.guide = guide
        guideTitleLabel.text = guide.title
        guideSubtitleLabel.text = guide.subTitle
        isExpandedCell.isHidden = guide.isExpanded
    }
    
}
