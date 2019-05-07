//
//  FormalitiesPickerTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 30/11/2018.
//

import UIKit

protocol FormalitiesPickerTableViewCellDelegate: class {
    func labelDidTapped(cell: FormalitiesPickerTableViewCell)
}

class FormalitiesPickerTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var chevronButton: UIImageView!
    
    weak var delegate: FormalitiesPickerTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(title: String, value: String) {
        self.chevronButton.image = ColissimoHomeServices.loadImage(name: "select.png")
        
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(FormalitiesPickerTableViewCell.labelTapped))
        
        self.titleLabel.text = title
        self.pickerLabel.addGestureRecognizer(gestureRecognizer)
        self.pickerLabel.text = value
        self.pickerLabel.isUserInteractionEnabled = true
    }
    
    @objc func labelTapped() {
        self.delegate?.labelDidTapped(cell: self)
    }

}
