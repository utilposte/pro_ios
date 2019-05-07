//
//  LPBaseCustomCell.swift
//  laposte
//
//  Created by Sofien Azzouz on 10/01/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

class LPBaseCustomCell: UITableViewCell {
    var isMandatory = false
    var inputText = ""
    var cellType: FormKeys?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.interfaceInitialization()
    }
    func interfaceInitialization() {
    }
    
    func setDelegate(vc: UIViewController) {
        
    }
    
    func cellHeight() -> CGFloat {
        return 85
    }
    
    func showErrorMsg(errorMsg: String) {
    }
    
    func hideErrorMsg() {
    }

}
