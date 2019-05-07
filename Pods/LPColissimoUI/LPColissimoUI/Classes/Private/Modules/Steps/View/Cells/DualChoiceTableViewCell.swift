//
//  DualChoiceTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 19/11/2018.
//

import UIKit

protocol DualChoiceTableViewCellDelegate: class {
    func firstViewDidTapped(cell: DualChoiceTableViewCell)
    func secondViewDidTapped(cell: DualChoiceTableViewCell)
}

class DualChoiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstView: UIView!

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    
    weak var delegate: DualChoiceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.firstView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DualChoiceTableViewCell.firstViewTapped)))
        self.secondView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DualChoiceTableViewCell.secondViewTapped)))
    }
    
    func setupCell(firstChoice: Choice, secondChoice: Choice) {
        self.firstView.layer.cornerRadius = 5
        self.firstLabel.isHidden = true
        self.firstImageView.image = firstChoice.image
        self.firstButton.setTitle(firstChoice.titleButton?.uppercased(), for: .normal)
        self.firstButton.titleLabel?.numberOfLines = 0
        self.firstButton.layer.cornerRadius = self.firstButton.frame.height / 2
        self.firstButton.titleLabel?.textAlignment = .center
        self.firstButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        if firstChoice.isSelected == true && firstChoice.isEnabled == true {
            self.firstView.layer.borderColor = UIColor.lpOrange.cgColor
            self.firstView.layer.borderWidth = 1
            
            self.firstButton.backgroundColor = UIColor.lpOrange
            self.firstButton.setTitleColor(.white, for: .normal)
        } else {
            self.firstView.layer.borderColor = UIColor.lpOrange.cgColor
            self.firstView.layer.borderWidth = 0
            
            self.firstButton.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
            self.firstButton.setTitleColor(UIColor(red: 60/255, green: 60/255, blue: 59/255, alpha: 1), for: .normal)
        }
        
        self.firstView.layer.masksToBounds = false
        self.firstView.layer.shadowRadius = 2.0
        self.firstView.layer.shadowColor = UIColor.gray.cgColor
        self.firstView.layer.shadowOffset = CGSize.init(width: 0.7, height: 0.5)
        self.firstView.layer.shadowOpacity = 0.5
        
        self.firstImageView.clipsToBounds = true
        self.firstImageView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        
        self.firstButton.clipsToBounds = true
        self.firstButton.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        self.secondImageView.clipsToBounds = true
        self.secondImageView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        
        self.secondButton.clipsToBounds = true
        self.secondButton.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        if firstChoice.isEnabled == true {
            self.firstLabel.isHidden = true
            self.firstLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 59/255, alpha: 1)
        } else {
            self.firstLabel.isHidden = false
            self.firstLabel.text = firstChoice.unavailableText ?? ""
            self.firstLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 59/255, alpha: 1)
        }
        
        // SECOND VIEW
        
        self.secondView.layer.cornerRadius = 5
        
        self.secondImageView.image = secondChoice.image
        self.secondButton.setTitle(secondChoice.titleButton?.uppercased(), for: .normal)
        self.secondButton.titleLabel?.numberOfLines = 0
        self.secondButton.layer.cornerRadius = self.secondButton.frame.height / 2
        self.secondButton.backgroundColor = UIColor.lpOrange
        self.secondButton.titleLabel?.textAlignment = .center
        self.secondButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        if secondChoice.isSelected == true {
            self.secondView.layer.borderColor = UIColor.lpOrange.cgColor
            self.secondView.layer.borderWidth = 1
            
            self.secondButton.backgroundColor = UIColor.lpOrange
            self.secondButton.setTitleColor(.white, for: .normal)
        } else {
            self.secondView.layer.borderColor = UIColor.clear.cgColor
            self.secondView.layer.borderWidth = 0
            
            self.secondButton.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
            self.secondButton.setTitleColor(UIColor(red: 60/255, green: 60/255, blue: 59/255, alpha: 1), for: .normal)
        }
        
        self.secondView.layer.masksToBounds = false
        self.secondView.layer.shadowRadius = 2.0
        self.secondView.layer.shadowColor = UIColor.gray.cgColor
        self.secondView.layer.shadowOffset = CGSize.init(width: 0.7, height: 0.5)
        self.secondView.layer.shadowOpacity = 0.5
        
        if secondChoice.isEnabled == true {
            self.secondLabel.isHidden = true
            self.secondLabel.text = ""
            self.secondLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 59/255, alpha: 1)
        } else {
            self.secondLabel.isHidden = false
            self.secondLabel.text = secondChoice.unavailableText ?? ""
            self.secondLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 59/255, alpha: 1)
        }
        
        if secondChoice.unavailableText != nil && secondChoice.unavailableText != "" {
            self.secondLabel.isHidden = false
            self.secondLabel.text = secondChoice.unavailableText ?? ""
        }
        self.setNeedsLayout()
    }
    
    @objc func firstViewTapped() {
        self.delegate?.firstViewDidTapped(cell: self)
        self.delegate?.firstViewDidTapped(cell: self)
    }
    
    @objc func secondViewTapped() {
        self.delegate?.secondViewDidTapped(cell: self)
        self.delegate?.secondViewDidTapped(cell: self)
    }
    
    @IBAction func firstButtonTapped(_ sender: Any) {
        self.delegate?.firstViewDidTapped(cell: self)
        self.delegate?.firstViewDidTapped(cell: self)
    }
    
    @IBAction func secondButtonTapped(_ sender: Any) {
        self.delegate?.secondViewDidTapped(cell: self)
        self.delegate?.secondViewDidTapped(cell: self)
    }
    
}
