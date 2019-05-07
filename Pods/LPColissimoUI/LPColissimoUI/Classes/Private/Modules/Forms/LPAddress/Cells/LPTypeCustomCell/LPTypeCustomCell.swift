//
//  LPTypeCustomCell.swift
//  laposte
//
//  Created by Lassad Tiss on 14/03/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

import UIKit

protocol LPTypeCustomCellDelegate: class {
    func didChangedAddressType(isPro: Bool?)
}

class LPTypeCustomCell: LPBaseCustomCell {

    @IBOutlet weak var normalAddressButton: UIButton!
    @IBOutlet weak var proAddressButton: UIButton!
    
    var delegate: LPTypeCustomCellDelegate?
    
    override func interfaceInitialization() {
        self.normalAddressButton.layer.borderWidth = 1.0
        self.normalAddressButton.layer.borderColor = BORDER_GREY_COLOR.cgColor
        self.proAddressButton.layer.borderWidth = 1.0
        self.proAddressButton.layer.borderColor = BORDER_GREY_COLOR.cgColor
        self.normalAddressButton.backgroundColor = UIColor.white
    }
    
    func initCellWithType(isPro: Bool?) {
        self.selectAddressType(isPro)
    }
    
    override func cellHeight() -> CGFloat {
        return 60
    }
    
    func selectAddressType(_ isPro: Bool?) {
        if isPro! {
            proAddressButton.backgroundColor = BACKGROUND_GREY_COLOR
            normalAddressButton.backgroundColor = UIColor.white
        } else {
            normalAddressButton.backgroundColor = BACKGROUND_GREY_COLOR
            proAddressButton.backgroundColor = UIColor.white
        }
        delegate?.didChangedAddressType(isPro: isPro)
    }
    
    @IBAction func selectProAddress(_ sender: UIButton) {
        selectAddressType(true)
    }
    
    @IBAction func selectNormalAddress(_ sender: UIButton) {
        selectAddressType(false)
    }
    
}
