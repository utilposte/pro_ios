//
//  SearchHistoryCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 18/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
protocol SearchHistoryCellDelegate: class {
    func didRemoveSearchText(text: String)
}

class SearchHistoryCell: UITableViewCell {
    @IBOutlet var searchTextLabel: UILabel!
    @IBOutlet var removeButton: UIButton!

    weak var delegate: SearchHistoryCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(text: String, canRemove: Bool) {
        searchTextLabel.text = text
        removeButton.isHidden = !canRemove
    }

    @IBAction func removeSearchTextClicked(_ sender: Any) {
        delegate?.didRemoveSearchText(text: searchTextLabel.text ?? "")
    }
}
