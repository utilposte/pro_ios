//
//  LPCivilityCustomCell.swift
//  laposte
//
//  Created by Sofien Azzouz on 10/01/2018.
//  Copyright © 2018 laposte. All rights reserved.
//
import LPSharedMCM

protocol LPCivilityCustomCellDelegate: class {
    func civilityChanged(gender: String?)
}

class LPCivilityCustomCell: LPBaseCustomCell {
    
    @IBOutlet weak var userFemaleButton: UIButton!
    @IBOutlet weak var userMaleButton: UIButton!

    var delegate: LPCivilityCustomCellDelegate?

    // MARK: - Overriden methods
    override func interfaceInitialization() {
        self.userMaleButton.layer.borderWidth = 1.0
        self.userMaleButton.layer.borderColor = BORDER_GREY_COLOR.cgColor
        self.userFemaleButton.layer.borderWidth = 1.0
        self.userFemaleButton.layer.borderColor = BORDER_GREY_COLOR.cgColor
        // unselect female by default
        self.userFemaleButton.backgroundColor = UIColor.white
    }

    func initCellWithGender(gender: String?) {
        self.selectOption(gender)
    }

    override func cellHeight() -> CGFloat {
        return 60
    }

    func selectOption(_ gender: String?) {
        
        if gender == HybrisNewAddressUserTitleFirstOptionCode {
            userFemaleButton.backgroundColor = BACKGROUND_GREY_COLOR
            userMaleButton.backgroundColor = UIColor.white
        } else {
            self.userMaleButton.backgroundColor = BACKGROUND_GREY_COLOR
            userFemaleButton.backgroundColor = UIColor.white
        } 

        delegate?.civilityChanged(gender: gender)
    }

    @IBAction func userMaleClicked(_ sender: Any) {
        selectOption(HybrisNewAddressUserTitleSecondOptionCode)
    }
    
    @IBAction func userFemaleClicked(_ sender: Any) {
        selectOption(HybrisNewAddressUserTitleFirstOptionCode)
    }
}

