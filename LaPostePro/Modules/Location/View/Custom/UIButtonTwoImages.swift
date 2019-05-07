//
//  UIButtonTwoImages.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 06/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonTwoImages: UIButton {

    @IBInspectable var leftHandImage: UIImage? {
        didSet {
            leftHandImage = leftHandImage?.withRenderingMode(.alwaysOriginal)
            setupImages()
        }
    }
    @IBInspectable var rightHandImage: UIImage? {
        didSet {
            rightHandImage = rightHandImage?.withRenderingMode(.alwaysTemplate)
            setupImages()
        }
    }
    
    func setupImages() {
        if let leftImage = leftHandImage {
            self.setImage(leftImage, for: .normal)
            self.imageView?.contentMode = .scaleAspectFill
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: self.frame.width - (self.imageView?.frame.width)!-20)
//            let leftImageView = UIImageView(image: leftImage)
//            leftImageView.tintColor = UIColor.white
//            leftImageView.contentMode = .scaleAspectFill
//
//            let height  : CGFloat = 15.0
//            let width   : CGFloat = 18.0
//            let xPos    : CGFloat = 20.0
//            let yPos    = (self.frame.height - height) / 2
//
//            leftImageView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
//            self.addSubview(leftImageView)
            
        }
        
        if let rightImage = rightHandImage {
            let rightImageView = UIImageView(image: rightImage)
            rightImageView.tintColor = UIColor.white
            rightImageView.contentMode = .scaleAspectFill
            
            let height : CGFloat = 5.0
            let width  : CGFloat = 8.0
            let xPos = self.frame.width - width - 20
            let yPos = (self.frame.height - height) / 2
            
            rightImageView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
            self.addSubview(rightImageView)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
