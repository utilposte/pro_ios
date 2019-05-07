//
//  LPUsePositionButtonCustomCell.swift
//  laposte
//
//  Created by Sofien Azzouz on 10/01/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

@objc protocol LPUsePositionButtonCustomCellDelegate: class {
    @objc func useMyPositionClicked()
}

class LPUsePositionButtonCustomCell: LPBaseCustomCell {

    @IBOutlet weak var validateButtonContainer: UIView!
    
    override func awakeFromNib() {
        self.validateButtonContainer.layer.cornerRadius = 15
    }
    
    var delegate: LPUsePositionButtonCustomCellDelegate?

    override func interfaceInitialization() {
    }

    override func cellHeight() -> CGFloat {
            return 60
    }

    
    @IBAction func useMyPositionButtonClicked(_ sender: Any) {
        self.delegate?.useMyPositionClicked()
    }
    
}
