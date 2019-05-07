//
//  StepTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 22/10/2018.
//

import UIKit

class StepTableViewCell: UITableViewCell {

    let gradientLayer = CAGradientLayer()
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var stepTitle: UILabel!
    @IBOutlet weak var stepImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
        
    }
    
    func createGradientLayer( view : UIView) {
        //gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.lpGradientRed.cgColor, UIColor.lpGradientYellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [
            UIColor.init(red: 236/255, green: 102/255, blue: 8/255, alpha: 1).cgColor, UIColor.init(red: 251/255, green: 186/255, blue: 7/255, alpha: 1).cgColor]
        return layer
    }
    
    func setupCell(step: Step) {
        self.stepNumber.text = step.stepNumber
        self.stepTitle.text = step.stepTitle
        self.stepImage.image = UIImage.loadImage(name: step.image)
        self.stepImage.image?.withRenderingMode(.alwaysTemplate)
        self.stepImage.tintColor = .white
        self.createGradientLayer(view: self.contentView)
        //layer.insertSublayer(self.gradient(frame: cell.bounds), at:0)
    }
}
