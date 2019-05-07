//
//  ErrorMessageView.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 30/10/2018.
//

import UIKit

class TopMessageView: UIView {

    let sizeHeight : CGFloat = 80.0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var centerMessageConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewWidthConstaint: NSLayoutConstraint!
    
    enum MessageType : Int {
        case success
        case error
        case info
        
        var image : UIImage? {
            switch self {
            case .success:
                return R.image.ic_message_checked()
            case .error:
                return R.image.ic_message_error()
            case .info :
                return R.image.ic_message_info()

            }

        }
    }
    
    var needToDissmiss = false
    
    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("TopMessageView", owner: nil, options: nil)?[0] as? TopMessageView ?? UIView()
    }
    
    func showInView(_ view: UIView, fromY: CGFloat) {
        view.addSubview(self)
        view.bringSubview(toFront: self)
        UIView.transition(with: self, duration: 1, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            var tmpFrame = self.frame
            tmpFrame.origin.y = fromY
            self.frame = tmpFrame
        }) { (success) in
            self.needToDissmiss = true
            self.perform(#selector(TopMessageView.autoDissmiss), with: nil, afterDelay: 4)
        }
    }
    
    func setView(title: String, message: String, type: MessageType) {
        let frame = CGRect(x: 0, y: -self.sizeHeight, width: UIScreen.main.bounds.size.width, height: sizeHeight)
        self.frame = frame
        viewWidthConstaint.constant = UIScreen.main.bounds.size.width
        self.messageLabel.text = message
        self.titleLabel.text = title
        closeImageView.image = type.image
    }
    
    func setView(message: NSAttributedString, type: MessageType) {
        let frame = CGRect(x: 0, y: -self.sizeHeight, width: UIScreen.main.bounds.size.width, height: sizeHeight)
        viewWidthConstaint.constant = UIScreen.main.bounds.size.width
        self.frame = frame
//        self.translatesAutoresizingMaskIntoConstraints = false
        centerMessageConstraint.constant = 30
        self.messageLabel.text = ""
        self.titleLabel.attributedText = message
        closeImageView.image = type.image
    }
    
    @objc func autoDissmiss() {
        if needToDissmiss == true {
            closeView()
        }
    }
    
    @IBAction func closeView() {
        needToDissmiss = false
        UIView.transition(with: self, duration: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.alpha = 0
//            var frame = self.frame
//            frame.origin.y = -self.sizeHeight
//            self.frame = frame
        }) { (success) in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
}

private extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
