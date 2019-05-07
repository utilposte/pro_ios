//
//  ReusableGauge.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 06/11/2018.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

struct Point {
    var x: CGFloat
    var g: CGFloat
}


protocol ReusableGaugeDelegate: class {
    func valueDidChange(value: Float)
    func endEditing(value: Float)
}

class ReusableGauge: UIControl {
    
    var minimumValue: Float = 0
    var maximumValue: Float = 1
    var isContinuous = true
    
    // BEGIN TEST
    var rectForProgressBarLine: CGRect?
    var pointArray: [Point] = []
    var pathForProgressBarLine: UIBezierPath?
    var rectForProgressBarStroke: CGRect?
    var pathForProgressBarStroke: UIBezierPath?
    // END TEST
    
    weak var delegate: ReusableGaugeDelegate?
    
    var value: Float = 10 / 30000
    var maxValue = 30000
    
    func setvalue(_ newValue: Float, animated: Bool = false) {
        value = min(maximumValue, max(minimumValue, newValue))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.pointArray.append(Point(x: 0.06642509, g: 0))
        self.pointArray.append(Point(x: 0.14251205, g: 250))
        self.pointArray.append(Point(x: 0.25241542, g: 500))
        self.pointArray.append(Point(x: 0.36352655, g: 750))
        self.pointArray.append(Point(x: 0.5048309, g: 1000))
        self.pointArray.append(Point(x: 0.634058, g: 2000))
        self.pointArray.append(Point(x: 0.75, g: 5000))
        self.pointArray.append(Point(x: 0.8671497, g: 10000))
        self.pointArray.append(Point(x: 0.99758449, g: CGFloat(self.maxValue)))
        self.setNeedsDisplay()
    }
    
    /*Only override draw() if you perform custom drawing.
     An empty implementation adversely affects performance during animation.*/
    override func draw(_ rect: CGRect) {
        
        guard let zeroPointX = pointArray.first?.x else {
            return
        }
    
        if self.value < Float(zeroPointX) {
            self.value = Float(zeroPointX)
        }
        self.drawGauge(frame2: rect, progressBarLevel: CGFloat(self.value))
    }
    
    func drawGauge(frame2: CGRect = CGRect(x: 0, y: 0, width: 333, height: 183), progressBarLevel: CGFloat = 0) {
        print("****** Gauge drawGauge progressBarLevel:" + progressBarLevel.description)
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Color Declarations
        let color = UIColor(red: 0.572, green: 0.572, blue: 0.572, alpha: 1.000)
        let color2 = UIColor(red: 1.000, green: 0.669, blue: 0.000, alpha: 1.000)
        let color5 = UIColor(red: 0.643, green: 0.671, blue: 0.690, alpha: 1.000)
        
        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.lightGray
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 5
        
        //// Variable Declarations
//        let expression: CGFloat = progressBarLevel * 437
        let expression: CGFloat = progressBarLevel * 437
        
        //// Subframes
        let group: CGRect = CGRect(x: frame2.minX + fastFloor((frame2.width - 333) / 2 + 0.5), y: frame2.minY, width: 333, height: 183)
        let frame = CGRect(x: group.minX, y: group.minY, width: 333, height: 183)
        
        
        //// Group
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        //// Clip Frame
        context.clip(to: frame)
        
        
        //// ProgressBarStroke Drawing
        let progressBarStrokeRect = CGRect(x: frame.minX + fastFloor((frame.width - 276) * 0.49123 - 0.5) + 1, y: frame.minY + frame.height - 159, width: 276, height: 258)
        
        self.rectForProgressBarStroke = progressBarStrokeRect
        
        let progressBarStrokePath = UIBezierPath()
        progressBarStrokePath.addArc(withCenter: CGPoint.zero, radius: progressBarStrokeRect.width / 2, startAngle: -180 * CGFloat.pi/180, endAngle: 0 * CGFloat.pi/180, clockwise: true)
        
        var progressBarStrokeTransform = CGAffineTransform(translationX: progressBarStrokeRect.midX, y: progressBarStrokeRect.midY)
        progressBarStrokeTransform = progressBarStrokeTransform.scaledBy(x: 1, y: progressBarStrokeRect.height / progressBarStrokeRect.width)
        progressBarStrokePath.apply(progressBarStrokeTransform)
        
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        UIColor.white.setStroke()
        progressBarStrokePath.lineWidth = 30
        progressBarStrokePath.lineCapStyle = .round
        progressBarStrokePath.lineJoinStyle = .round
        context.saveGState()
        context.setLineDash(phase: 15, lengths: [437, 1000])
        progressBarStrokePath.stroke()
        
        self.pathForProgressBarStroke = progressBarStrokePath
        
        context.restoreGState()
        context.restoreGState()
        
        
        //// ProgessBarLine Drawing
        let progessBarLineRect = CGRect(x: frame.minX + fastFloor((frame.width - 276) * 0.49123 - 0.5) + 1, y: frame.minY + fastFloor((frame.height - 258) * -0.32000 - 0.5) + 1, width: 276, height: 258)
        self.rectForProgressBarLine = progessBarLineRect
        let progessBarLinePath = UIBezierPath()
        progessBarLinePath.addArc(withCenter: CGPoint.zero, radius: progessBarLineRect.width / 2, startAngle: -180 * CGFloat.pi/180, endAngle: -progressBarLevel * CGFloat.pi/180, clockwise: true)
        
        var progessBarLineTransform = CGAffineTransform(translationX: progessBarLineRect.midX, y: progessBarLineRect.midY)
        progessBarLineTransform = progessBarLineTransform.scaledBy(x: 1, y: progessBarLineRect.height / progessBarLineRect.width)
        progessBarLinePath.apply(progessBarLineTransform)
        
        color2.setStroke()
        progessBarLinePath.lineWidth = 15
        progessBarLinePath.lineCapStyle = .round
        progessBarLinePath.lineJoinStyle = .round
        context.saveGState()
        context.setLineDash(phase: 15, lengths: [expression, 1000])
        progessBarLinePath.stroke()
        context.restoreGState()
        self.pathForProgressBarLine = progessBarLinePath
        
        //// Text Drawing
        let textRect = CGRect(x: frame.minX + 44, y: frame.minY + 145, width: frame.width - 296, height: frame.height - 166)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: textStyle,
            ] as [NSAttributedString.Key: Any]
        
        "0 g\n".draw(in: textRect, withAttributes: textFontAttributes)
        
        
        //// Text 2 Drawing
        let text2Rect = CGRect(x: frame.minX + 77, y: frame.minY + 79, width: frame.width - 295, height: frame.height - 166)
        let text2Style = NSMutableParagraphStyle()
        text2Style.alignment = .center
        let text2FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: text2Style,
            ] as [NSAttributedString.Key: Any]
        
        "500 g\n".draw(in: text2Rect, withAttributes: text2FontAttributes)
        
        
        //// Text 3 Drawing
        let text3Rect = CGRect(x: frame.minX + 101, y: frame.minY + 54, width: frame.width - 296, height: frame.height - 165)
        let text3Style = NSMutableParagraphStyle()
        text3Style.alignment = .center
        let text3FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: text3Style,
            ] as [NSAttributedString.Key: Any]
        
        "750 g\n".draw(in: text3Rect, withAttributes: text3FontAttributes)
        
        
        //// Text 4 Drawing
        let text4Rect = CGRect(x: frame.minX + 147, y: frame.minY + 45, width: frame.width - 296, height: frame.height - 166)
        let text4Style = NSMutableParagraphStyle()
        text4Style.alignment = .center
        let text4FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: text4Style,
            ] as [NSAttributedString.Key: Any]
        
        "1 kg\n".draw(in: text4Rect, withAttributes: text4FontAttributes)
        
        
        //// Text 5 Drawing
        let text5Rect = CGRect(x: frame.minX + 188, y: frame.minY + 54, width: frame.width - 296, height: frame.height - 166)
        let text5Style = NSMutableParagraphStyle()
        text5Style.alignment = .center
        let text5FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: text5Style,
            ] as [NSAttributedString.Key: Any]
        
        "2 kg\n".draw(in: text5Rect, withAttributes: text5FontAttributes)
        
        
        //// Text 6 Drawing
        let text6Rect = CGRect(x: frame.minX + 217, y: frame.minY + 78, width: frame.width - 296, height: frame.height - 165)
        let text6Style = NSMutableParagraphStyle()
        text6Style.alignment = .center
        let text6FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: text6Style,
            ] as [NSAttributedString.Key: Any]
        
        "5 kg\n".draw(in: text6Rect, withAttributes: text6FontAttributes)
        
        
        //// Text 7 Drawing
        let text7Rect = CGRect(x: frame.minX + 238, y: frame.minY + 113, width: frame.width - 296, height: frame.height - 166)
        let text7Style = NSMutableParagraphStyle()
        text7Style.alignment = .center
        let text7FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: text7Style,
            ] as [NSAttributedString.Key: Any]
        
        "10 kg\n".draw(in: text7Rect, withAttributes: text7FontAttributes)
        
        
        //// Text 8 Drawing
        let text8Rect = CGRect(x: frame.minX + 243, y: frame.minY + 145, width: frame.width - 295, height: frame.height - 166)
        let text8Style = NSMutableParagraphStyle()
        text8Style.alignment = .center
        let text8FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: text8Style,
            ] as [NSAttributedString.Key: Any]
        
        "\(self.maxValue / 1000) kg\n".draw(in: text8Rect, withAttributes: text8FontAttributes)
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 8) * 0.07692 + 0.5), y: frame.minY + frame.height - 42, width: 7, height: 7))
        color5.setFill()
        ovalPath.fill()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 9) * 0.18519 + 0.5), y: frame.minY + frame.height - 121, width: 7, height: 7))
        color5.setFill()
        oval2Path.fill()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 9) * 0.31173 + 0.5), y: frame.minY + frame.height - 151, width: 7, height: 7))
        color5.setFill()
        oval3Path.fill()
        
        
        //// Oval 4 Drawing
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 8) * 0.49538 + 0.5), y: frame.minY + frame.height - 163, width: 7, height: 7))
        color5.setFill()
        oval4Path.fill()
        
        
        //// Oval 5 Drawing
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 7) * 0.65951 + 0.5), y: frame.minY + frame.height - 151, width: 7, height: 7))
        color5.setFill()
        oval5Path.fill()
        
        
        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 9) * 0.79012 + 0.5), y: frame.minY + frame.height - 125, width: 7, height: 7))
        color5.setFill()
        oval6Path.fill()
        
        
        //// Oval 7 Drawing
        let oval7Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 9) * 0.88272 + 0.5), y: frame.minY + frame.height - 85, width: 7, height: 7))
        color5.setFill()
        oval7Path.fill()
        
        
        //// Oval 8 Drawing
        let oval8Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 8) * 0.92000 + 0.5), y: frame.minY + frame.height - 42, width: 7, height: 7))
        color5.setFill()
        oval8Path.fill()
        
        
        //// Text 9 Drawing
        let text9Rect = CGRect(x: frame.minX + 54, y: frame.minY + 113, width: frame.width - 296, height: frame.height - 166)
        let text9Style = NSMutableParagraphStyle()
        text9Style.alignment = .center
        let text9FontAttributes = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: color,
            .paragraphStyle: text9Style,
            ] as [NSAttributedString.Key: Any]
        
        "250 g\n".draw(in: text9Rect, withAttributes: text9FontAttributes)
        
        
        //// Oval 9 Drawing
        let oval9Path = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor((frame.width - 8) * 0.10462 + 0.5), y: frame.minY + frame.height - 82, width: 7, height: 7))
        color5.setFill()
        oval9Path.fill()
        
        
        context.endTransparencyLayer()
        context.restoreGState()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        print("****** Gauge continueTracking")
        let lastPoint = touch.location(in: self)
        if self.rectForProgressBarLine?.contains(lastPoint) == true {
            if let midY = self.rectForProgressBarLine?.midY, lastPoint.y <= midY {
                self.drawCircularLine(value: Float(lastPoint.x))
                _ = self.defineRangeFor(touchX: CGFloat(self.value))
                print(self.value)
                self.setNeedsDisplay()
            }
        }
    
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        print("****** Gauge endTracking")
        super.endTracking(touch, with: event)
        let value = self.defineRangeFor(touchX: CGFloat(self.value))
        self.delegate?.endEditing(value: value)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        print("****** Gauge cancelTracking Value:" + self.value.description)
    }
    
    func drawCircularLine(value: Float) {
        guard let rectForProgressBarLine = self.rectForProgressBarLine else {
            return
        }
        
        self.value = (value - Float(rectForProgressBarLine.minX)) / Float((Int(rectForProgressBarLine.maxX) - Int(rectForProgressBarLine.minX)))
        print("****** Gauge Value:" + self.value.description)
    }
    
    func getValueFor(kg: Double) -> CGFloat {
        var i = 0
        let max = self.pointArray.count
        
        let kilo = kg
        
        while(i <= max) {
            if ((i + 1) < max && self.pointArray[i].g <= CGFloat(kilo) &&  self.pointArray[i + 1].g >= CGFloat(kilo)) {
                
                let distance = self.pointArray[i + 1].g - self.pointArray[i].g
                let g = self.pointArray[i + 1].x - self.pointArray[i].x
                let valueGByx = g / distance
                let restX = CGFloat(kilo) - self.pointArray[i].g
                let value = (restX * valueGByx) + self.pointArray[i].x
//                self.delegate?.valueDidChange(value: Float(value))
                return value
            }
            i += 1
        }
        
        if i > max {
            return 30
        } else {
            return 0
        }
        
    }
    
    func defineRangeFor(touchX: CGFloat) -> Float {
        var i = 0
        let max = self.pointArray.count
        
        let touch = touchX
        
        while(i <= max) {
            if ((i + 1) < max && self.pointArray[i].x < touch &&  self.pointArray[i + 1].x > touch) {
                
                let distance = self.pointArray[i + 1].x - self.pointArray[i].x
                let g = self.pointArray[i + 1].g - self.pointArray[i].g
                let valueGByx = g / distance
                let restX = touch - self.pointArray[i].x
                let value = (restX * valueGByx) + self.pointArray[i].g
                
                self.delegate?.valueDidChange(value: Float(value))
                return Float(value)
            }
            i += 1
        }
        
        if i > max {
            return 30
        } else {
            return 0
        }
    }
}
