//
//  VericalSlider.swift
//  LPColissimoUI
//
//  Created by LaPoste on 17/10/2018.
//  Copyright © 2018 LaPoste. All rights reserved.
//

import UIKit

protocol VerticalSliderDelegate {
    func didValueChanged(step: Int)
}

@IBDesignable class VerticalSlider: UIControl {
    
    var delegate : VerticalSliderDelegate!
    
    /// These values can be set in our storyboard
    
    
    @IBInspectable public var minColor: UIColor = .blue
    @IBInspectable public var trackWidth: CGFloat = 20.0
    
    public var maxColor: UIColor = .white
    public var thumbColor: UIColor = .orange
    var thumbSize : CGSize = CGSize(width: 30, height: 50)
    
    public var minValue: CGFloat = 0.0
    public var maxValue: CGFloat = 2.0
    
    @IBInspectable public var value: CGFloat = 2 {
        didSet {
            if value > maxValue {
                value = maxValue
            }
            if value < minValue {
                value = minValue
            }
            updateThumbRect()
        }
    }
    
    /// Standard thumb size for UISlider
    
    
    lazy var trackLength: CGFloat = {
        return self.bounds.height - (self.thumbOffset * 2)
    }()
    
    lazy var thumbOffset: CGFloat = {
        return self.thumbSize.height / 2
    }()
    
    var thumbRect: CGRect!
    var thumbCenterRect : CGRect!
    var isMoving = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackWidth = self.bounds.width
        thumbSize =  CGSize(width: trackWidth*0.5, height: self.frame.height*0.09)
        updateThumbRect()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        trackWidth = self.bounds.width
        self.isUserInteractionEnabled = true
        contentMode = .redraw
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateThumbRect()
    }
    
    class override var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateThumbRect()
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        /// draw the max track
        self.drawBackground()
        
        /// draw the thumb
        self.drawThumb()
        
        context?.saveGState()
        context?.restoreGState()
    }
    
    func drawBackground(){
        let x = bounds.width / 2 - trackWidth / 2
        let maxTrackRect = CGRect(x: x, y: 0, width: trackWidth, height: self.frame.size.height)
        let maxTrack = UIBezierPath(roundedRect: maxTrackRect, cornerRadius: trackWidth/3)
        maxColor.setFill()
        maxTrack.fill()
        
        
        let circleH = trackWidth*0.2
        let centerX = (self.bounds.size.width-circleH)/2
        
        let rect = CGRect(x: centerX, y: thumbSize.height/2, width: circleH, height: circleH)
        let circle = UIBezierPath(ovalIn: rect)
        let circleColor : UIColor = .gray
        circleColor.setFill()
        circle.fill()
        
        
        let rect1 = CGRect(x: centerX, y: (bounds.height-(thumbSize.height)/2)/2, width: circleH, height: circleH)
        let circle1 = UIBezierPath(ovalIn: rect1)
        let circleColor1 : UIColor = .gray
        circleColor1.setFill()
        circle1.fill()
        
        let rect3 = CGRect(x: centerX, y: (bounds.height-thumbSize.height/2)-(thumbSize.height/2), width: circleH, height: circleH)
        let circle3 = UIBezierPath(ovalIn: rect3)
        let circleColor3 : UIColor = .gray
        circleColor3.setFill()
        circle3.fill()
        
    }
    
    func drawThumb(){
        
        let thumb = UIBezierPath(roundedRect: thumbRect, cornerRadius: thumbRect.size.width/3)
        thumbColor.setFill()
        thumb.fill()
        
        let circle = UIBezierPath(ovalIn: thumbCenterRect)
        let circleColor : UIColor = .white
        circleColor.setFill()
        circle.fill()
        
    }
    
    // MARK: - Standard Control Overrides
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        if thumbRect.contains(touch.location(in: self)) {
            isMoving = true
        }
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let location = touch.location(in: self)
        let step : CGFloat = 1
        if isMoving {
            let value = valueFromY(location.y)
            let roundValue = (round(value / step) * step)
            if value != minValue && value != maxValue {
                self.value = roundValue
                setNeedsDisplay()
            }
            
            if roundValue == minValue {
                delegate.didValueChanged(step :Int(maxValue))
            }else if roundValue == maxValue{
                delegate.didValueChanged(step :Int(minValue))
            }else if roundValue == maxValue/2 {
                delegate.didValueChanged(step :Int(maxValue/2))
            }
        }
        
        self.sendActions(for: UIControl.Event.valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        isMoving = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isMoving = true
        if(touches.first != nil){
            let _ =   self.continueTracking(touches.first!, with: event)
        }
        
    }
    // MARK: - Utility
    func valueFromY(_ y: CGFloat) -> CGFloat {
        let yOffset = bounds.height - thumbOffset - y
        return (yOffset * maxValue) / trackLength
    }
    
    func yFromValue(_ value: CGFloat) -> CGFloat {
        let y = (value * trackLength) / maxValue
        return bounds.height - thumbOffset - y
    }
    
    func updateThumbRect() {
        thumbRect = CGRect(origin: CGPoint(x: (self.bounds.size.width-thumbSize.width)/2, y: yFromValue(value) - (thumbSize.height / 2)), size: thumbSize)
        let circleH = trackWidth*0.2
        let centerSize =  CGSize(width: circleH, height: circleH)
        thumbCenterRect = CGRect(origin: CGPoint(x: (self.bounds.size.width-centerSize.width)/2, y: yFromValue(value) - (circleH / 2)), size: centerSize)
        setNeedsDisplay()
    }
    
    
    
}
