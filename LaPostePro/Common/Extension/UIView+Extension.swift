//
//  UIView+Extension.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 16/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

/////////////////////////
///      Border       ///
/////////////////////////

extension UIView {
    enum ViewSide {
        case left, right, top, bottom
    }
    func addBorder(withColor color: CGColor, andThickness thickness: CGFloat, andCornerRaduis radius: CGFloat) {
        self.layer.borderWidth = thickness
        self.layer.borderColor = color
        self.layer.cornerRadius = radius
    }
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: thickness, height: frame.height)
        case .right: border.frame = CGRect(x: frame.maxX, y: frame.maxY, width: thickness, height: frame.height)
        case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        }

        layer.addSublayer(border)
    }
}

/////////////////////////
///      Radius       ///
/////////////////////////

extension UIView {
    func addRadius(value: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = value
    }

    func addRadius(value: CGFloat, color: CGColor, width: CGFloat) {
        self.layer.cornerRadius = value
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

/////////////////////////
///   IBInspectable   ///
/////////////////////////
@IBDesignable
class CustomView: UIView {
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func openWebView(for url: String) {
        let viewController = R.storyboard.webView.webViewControllerID()!
        viewController.url = url
        self.parentViewController?.navigationController?.setNavigationBarHidden(false, animated: false)
        self.parentViewController?.navigationController?.navigationBar.tintColor = .lpGrey
        self.parentViewController?.navigationController!.pushViewController(viewController, animated: true)
    }
}

