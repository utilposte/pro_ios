//
//  LPValidateCustomCell.swift
//  laposte
//
//  Created by Sofien Azzouz on 15/01/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

@objc protocol LPValidateCellDelegate: class {
    @objc func validateFormButtonClicked()
}

class LPValidateCustomCell: LPBaseCustomCell {
    
    @IBOutlet weak var validateButton: UIButton!
    var buttonBackgroundColor : UIColor!
    
    var delegate: LPValidateCellDelegate?

    override func interfaceInitialization() {
        super.interfaceInitialization()
        //self.validateButton.backgroundColor = UIColor.lightGray
        self.validateButton.isEnabled = false
        self.validateButton.layer.cornerRadius = 5.0;
        validateButton.setTitle("Suivant", for: .normal)
        
        //self.validateButton?.setTitle("Suivant",.normal)
    }
    
    func initCellWithColor(color: UIColor?) {
        self.buttonBackgroundColor = color
    }
    
    override func cellHeight() -> CGFloat {
        return 80
    }


    @IBAction func validateButtonClicked(_ sender: Any) { 
        self.delegate?.validateFormButtonClicked()
    }
    
    func activateValidationButton (hasError : Bool) {
        if (!hasError) {
            self.validateButton.backgroundColor = self.buttonBackgroundColor
            self.validateButton.isEnabled = true
        } else {
            self.validateButton.backgroundColor = UIColor.lightGray
            self.validateButton.isEnabled = false
        }
    }

}

