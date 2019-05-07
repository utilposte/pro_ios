//
//  EmailHeaderCell.swift
//  Pods
//
//  Created by LaPoste on 28/11/2018.
//

import UIKit

class EmailHeaderCell: LPBaseCustomCell {

    @IBOutlet weak var mainText: UILabel!
    
    @IBOutlet weak var descText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(main: String, desc: String) {
        self.mainText.text = main
        self.descText.text = desc
    }
    
}
