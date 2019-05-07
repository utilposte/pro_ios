//
//  ConfirmOrderTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit


protocol ConfirmOrderDelegate {
    func confirmButtonClicked()
}

class ConfirmOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!

    var delegate: ConfirmOrderDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    internal func configureConfirmOrderCell() {
        self.setupContainerView()
        self.setupArrowImageView()
    }

    func setupContainerView() {
        self.containerView.addRadius(value: self.containerView.frame.height / 10)
    }

    func setupArrowImageView() {
        self.arrowImageView.image = UIImage(named: "right-arrow")
        self.arrowImageView.tintImageColor(color: .white)
    }

    @IBAction func confirmOrderButtonClicked(_ sender: Any) {
        delegate?.confirmButtonClicked()
    }

}
