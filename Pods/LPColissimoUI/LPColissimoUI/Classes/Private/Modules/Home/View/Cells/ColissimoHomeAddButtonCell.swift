//
//  ColissimoHomeAddButtonCell.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 23/10/2018.
//

import UIKit

protocol ColissimoHomeAddButtonCellDelegate: class {
    func callStep1Viewcontroller()
}

class ColissimoHomeAddButtonCell: UITableViewCell {

    @IBOutlet weak var nextStepButton: UIButton!
    weak var delegate: ColissimoHomeAddButtonCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func nextStepButtonClicked(_ sender: Any) {
        delegate?.callStep1Viewcontroller()
    }
}
