//
//  ErrorMessageView.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 30/10/2018.
//

import UIKit

class ErrorMessageView: UIView {

    let sizeHeight : CGFloat = 80.0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var closeImageView: UIImageView!
    var needToDissmiss = false
    
    class func instanceFromNib() -> UIView {
        let podBundle = Bundle(for: self.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return UINib(nibName: "ErrorMessageView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? ErrorMessageView ?? UIView()
            }
        }
        return UIView()
    }
    
    func addInView(_ view: UIView, message: String, fromY: CGFloat) {
        let frame = CGRect(x: 0, y: -sizeHeight, width: UIScreen.main.bounds.size.width, height: sizeHeight)
        self.frame = frame
        self.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.text = message
        self.closeImageView.image = UIImage.loadImage(name: "IconCloseWhite.png")
        view.addSubview(self)
        view.bringSubview(toFront: view)
        UIView.transition(with: self, duration: 1, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            var tmpFrame = self.frame
            tmpFrame.origin.y = fromY
            self.frame = tmpFrame
        }) { (success) in
            self.needToDissmiss = true
            self.perform(#selector(ErrorMessageView.autoDissmiss), with: nil, afterDelay: 5)
        }
    }
    
    @objc func autoDissmiss() {
        if needToDissmiss == true {
            closeView()
        }
    }
    
    @IBAction func closeView() {
        needToDissmiss = false
        UIView.transition(with: self, duration: 1, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            var frame = self.frame
            frame.origin.y = -self.sizeHeight
            self.frame = frame
        }) { (success) in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
}
