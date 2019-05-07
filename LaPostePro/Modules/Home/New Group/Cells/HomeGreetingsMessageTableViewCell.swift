//
//  HomeGreetingsMessageTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 11/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeGreetingsMessageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .lpBackgroundGrey
    }

    func setupCell(name: String, prefix: String, message: String) {
        self.textLabel?.attributedText = self.createTitleText(name: name, prefix: prefix)
        self.detailTextLabel?.text = message
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        self.detailTextLabel?.textColor = .lpGrey
        self.detailTextLabel?.numberOfLines = 2
    }

}

extension HomeGreetingsMessageTableViewCell {
    // MARK: created for test
    func createTitleText (name: String, prefix: String) -> NSMutableAttributedString {
        return  NSMutableAttributedString()
            .custom(prefix, font: UIFont.systemFont(ofSize: 28), color: .black)
            .custom(name, font: UIFont.boldSystemFont(ofSize: 28), color: .lpPurple)
    }
}
