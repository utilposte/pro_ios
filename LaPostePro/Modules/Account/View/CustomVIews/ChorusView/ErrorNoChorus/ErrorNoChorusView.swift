//
//  ErrorNoChorusView.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 15/02/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class ErrorNoChorusView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let noChorusText = "Merci de vérifier votre inscription sur le portail Chorus Pro afin que l'on puisse transmettre vos factures vers votre compte Chorus.\nSi votre inscription est active, merci de vérifier la conformité de votre SIRET avec votre type de société."
    let noChorusBoldText = ["Merci de vérifier votre inscription sur le portail Chorus Pro","Si votre inscription est active"]
    @IBOutlet weak var messageLabel: UILabel!
    
    class func getErrorNoChorusView() -> ErrorNoChorusView? {
        return Bundle.main.loadNibNamed("ErrorNoChorusView", owner: self, options: nil)?.first as? ErrorNoChorusView
    }
    
    override func awakeFromNib() {
        messageLabel.attributedText = attributedText(withString: noChorusText, boldString: noChorusBoldText, font: messageLabel
            .font ?? UIFont())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func attributedText(withString string: String, boldString: [String], font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        for bold in boldString {
            let range = (string as NSString).range(of: bold)
            attributedString.addAttributes(boldFontAttribute, range: range)
        }
        return attributedString
    }
    
    
}
