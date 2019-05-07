//
//  AccountHomeChorusCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 15/02/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

protocol AccountHomeChorusCellDelegate {
    func callProfileViewcontroller()
}

class AccountHomeChorusCell: UITableViewCell {


    let noChorusText = "Merci de vérifier votre inscription sur le portail Chorus Pro afin que l'on puisse transmettre vos factures vers votre compte Chorus.\nSi votre inscription est active, merci de vérifier la conformité de votre SIRET avec votre type de société."
    let noChorusBoldText = ["Merci de vérifier votre inscription sur le portail Chorus Pro","Si votre inscription est active"]
    
    let chorusText = "Vous avez rendu le code service lié à votre entité obligatoire.\nMerci de valider votre code service dans le formulaire de vos informations personnelles afin de recevoir votre facture et de la retrouver sur votre compte Chorus Pro"
    let chorusClickableText = "formulaire de vos informations personnelles"
    
    var delegate : AccountHomeChorusCellDelegate?
    
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(isChorus :Bool) {
        if isChorus {
            messageLabel.attributedText = clickableAttributedText(withString: chorusText, boldString: chorusClickableText, font: messageLabel
                .font ?? UIFont())
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
            messageLabel.addGestureRecognizer(gesture)
        }
        else {
            messageLabel.attributedText = attributedText(withString: noChorusText, boldString: noChorusBoldText, font: messageLabel
            .font ?? UIFont())
        }
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
    
    func clickableAttributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
//        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
//        let underlineFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle:  NSUnderlineStyle.styleSingle.rawValue]

        let colorFontAttribute : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor:  UIColor.lpPurple.cgColor]
        let range = (string as NSString).range(of: boldString)
//        attributedString.addAttributes(boldFontAttribute, range: range)
//        attributedString.addAttributes(underlineFontAttribute, range: range)
        attributedString.addAttributes(colorFontAttribute, range: range)
        return attributedString
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (messageLabel.text)!
        let goToProfile = (text as NSString).range(of: chorusClickableText)
        
        if gesture.didTapAttributedTextInLabel(label: messageLabel, inRange: goToProfile) {
            delegate?.callProfileViewcontroller()
        }
    }
    
}
//
//extension UITapGestureRecognizer {
//
//    func didTapAttributedText(label: UILabel, inRange targetRange: NSRange) -> Bool {
//        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
//        let layoutManager = NSLayoutManager()
//        let textContainer = NSTextContainer(size: CGSize.zero)
//        let textStorage = NSTextStorage(attributedString: label.attributedText!)
//
//        // Configure layoutManager and textStorage
//        layoutManager.addTextContainer(textContainer)
//        textStorage.addLayoutManager(layoutManager)
//
//        // Configure textContainer
//        textContainer.lineFragmentPadding = 0.0
//        textContainer.lineBreakMode = label.lineBreakMode
//        textContainer.maximumNumberOfLines = label.numberOfLines
//        let labelSize = label.bounds.size
//        textContainer.size = labelSize
//
//        // Find the tapped character location and compare it to the specified range
//        let locationOfTouchInLabel = self.location(in: label)
//        let textBoundingBox = layoutManager.usedRect(for: textContainer)
//        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
//
//        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
//                                                         locationOfTouchInLabel.y - textContainerOffset.y)
//        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//
//        return NSLocationInRange(indexOfCharacter, targetRange)
//    }
//
//}
