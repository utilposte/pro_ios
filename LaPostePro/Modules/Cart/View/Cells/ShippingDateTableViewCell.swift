//
//  ShippingDateTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ShippingDateTableViewCell: UITableViewCell {
    @IBOutlet var shippingDateLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
//        self.setupContainerView()
    }

    private func setupContainerView() {
        self.shadowView.roundCorners([.bottomLeft], radius: 5)
        self.containerView.addRadius(value: 5, color: UIColor.lightGray.cgColor, width: 1)
    }

    internal func configureShippingDateCell(fromDate: String, toDate: String) {
        self.shippingDateLabel.attributedText = NSMutableAttributedString()
            .custom("Date de livraison estimée entre le ", font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
            .custom(fromDate, font: UIFont.boldSystemFont(ofSize: 15), color: .lpDeepBlue)
            .custom(" et le ", font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
            .custom(toDate, font: UIFont.boldSystemFont(ofSize: 15), color: .lpDeepBlue)
            .custom(" en Colissimo", font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
    }
}
