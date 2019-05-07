//
//  ResultHeaderView.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 20/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ResultHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var showAllButton: UIButton!
    var showAllClosure : (() -> ())?
    
    
    @IBAction func showAllTapped(_ sender: Any) {
        showAllClosure?()
    }
    
    class func getHeaderWithText(_ title : String) -> ResultHeaderView? {
        let nibArray = Bundle.main.loadNibNamed("ResultHeaderView", owner: self, options: nil)
        if let view = nibArray?.first as? ResultHeaderView {
            view.titleLabel.text = title
            return view
        }
        return nil
    }
}
