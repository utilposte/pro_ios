//
//  NSMutableAttributedString+Extension.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 14/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    @discardableResult func custom(_ text: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: font, .foregroundColor: color]
        let customString = NSMutableAttributedString(string: text, attributes: attrs)
        append(customString)
        return self
    }

    @discardableResult func image(_ image: UIImage , font: UIFont) -> NSMutableAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let ratio = image.size.width / image.size.height
        let newHeight = font.capHeight * 1.5
        let newWidth = ratio * newHeight

        let newY = ((font.capHeight) - newHeight)  / 2
        imageAttachment.bounds = CGRect(x: 0, y:newY, width:newWidth , height: newHeight)
        
        let imageString = NSAttributedString(attachment: imageAttachment)

        append(imageString)
        return self
    }
    
    @discardableResult func bold(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: size)]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        append(boldString)
        return self
    }

    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        return self
    }
}
