//
//  FloatingView.swift
//  LPColissimoUI
//
//  Created by LaPoste on 16/10/2018.
//  Copyright © 2018 Khaled El Abed. All rights reserved.

import QuartzCore
import UIKit

@IBDesignable class FloatingView: UIView {
    var contentView: UIView?
    var onClickListner: () -> Void = { () -> Void in }
    
    var nibName: String = "FloatingView"
//    var data: HomeColissimoSavedData! {
//        didSet {
//            priceLabel.text = String(format: "%.2f €", data.price)
//            boxImageView.image = ColissimoHomeServices.loadImage(name: data.dimension.image)
//        }
//    }
    
    @IBInspectable var productImageNamed: String? {
        didSet {
            boxImageView.image = ColissimoHomeServices.loadImage(name: productImageNamed!)
        }
    }
    
    @IBInspectable var price: Double = 0.0 {
        didSet {
            priceLabel.text = String(format: "%.2f €", price)
        }
    }
    
    func setup(step: Int) {
//        price = data.price
        productImageNamed = "ic_standard_help_size"
    }
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var boxImageView: UIImageView!
    @IBOutlet var circleView: UIView!
    
    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 20.0
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if newValue > 1 {
                circlePathLayer.strokeEnd = 1
            } else if newValue < 0 {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
            
            animate()
        }
    }
    
    func configure() {
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 10
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = UIColor.lpGreen.cgColor
        circlePathLayer.lineCap = kCALineCapRound
        circleView.layer.insertSublayer(circlePathLayer, at: 1)
        circleView.backgroundColor = .white
        backgroundColor = .clear
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: circleView.bounds.midX, y: circleView.bounds.midY), radius: circleView.frame.height / 2, startAngle: CGFloat((3 * Double.pi) / 2), endAngle: -CGFloat(Double.pi * 3), clockwise: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.red
        addSubview(view)
        
        contentView = view
        contentView?.backgroundColor = UIColor.clear
        configure()
    }
    
    func loadViewFromNib() -> UIView? {
//        guard let nibName = nibName else { return nil }
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let nib = UINib(nibName: nibName, bundle: bundle)
                return nib.instantiate(
                    withOwner: self,
                    options: nil).first as? UIView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    override func layoutSubviews() {
        circleView.applyCircleShadow()
        circlePathLayer.backgroundColor = UIColor.clear.cgColor
        circlePathLayer.frame = circleView.bounds
        circlePathLayer.path = circlePath().cgPath
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onClickListner()
    }
    
    public func animate() {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        // Set the animation duration appropriately
        animation.duration = 1.2
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = circlePathLayer.strokeEnd
        animation.toValue = progress
        // Do a linear animation (i.e. the speed of the animation stays the same)
        // animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circlePathLayer.strokeEnd = progress
        // Do the actual animation
        circlePathLayer.add(animation, forKey: "animateCircle")
    }
}

extension UIView {
    func applyCircleShadow(shadowRadius: CGFloat = 2,
                           shadowOpacity: Float = 0.2,
                           shadowColor: CGColor = UIColor.black.cgColor,
                           shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: 2, height: 5)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}
