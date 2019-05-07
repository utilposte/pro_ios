//
//  OrderDownloadTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 03/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderDownloadTableViewCell: UITableViewCell {

    @IBOutlet var buttonView: UIView!
    private var downloadClosure : (() -> ())?
    
    
    func configureCell(downloadClosure: @escaping () -> ()) {
        self.downloadClosure = downloadClosure
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.downloadTapped (_:)))
        self.buttonView.addGestureRecognizer(gesture)
    }

    @objc func downloadTapped(_ sender:UITapGestureRecognizer) {
        self.downloadClosure?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
