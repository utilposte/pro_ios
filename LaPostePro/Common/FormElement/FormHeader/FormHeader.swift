//
//  InscriptionFormHeader.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 12/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class FormHeader: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(title: String, detail: String) {
        super.init(frame: CGRect.zero)
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
    
    func setup(with title: String, and detail: String) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
}
