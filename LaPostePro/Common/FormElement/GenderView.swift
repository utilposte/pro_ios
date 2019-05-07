//
//  GenderView.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 20/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol GenderViewDelegate: class {
    func genderSelected()
}

class GenderView: UIView {
    private let femaleCheckImage: UIImageView = UIImageView(image: UIImage(named: "small-check"))
    private let maleCheckImage: UIImageView = UIImageView(image: UIImage(named: "small-check"))
    
    private var maleView: UIView?
    private var femaleView: UIView?
    
    private let maleButton: UIButton = UIButton()
    private let femaleButton: UIButton = UIButton()
    
    weak var delegate: GenderViewDelegate?
    
    private var isMale: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupGenderStackView() {
        let genderStackView: UIStackView = UIStackView()
        genderStackView.alignment = .fill
        genderStackView.distribution = .fillEqually
        genderStackView.spacing = 5
        genderStackView.axis = .horizontal
        genderStackView.translatesAutoresizingMaskIntoConstraints = false
        genderStackView.backgroundColor = .green
        
        self.addSubview(genderStackView)
        
        // Male
        self.maleView = UIView()
        self.maleView?.backgroundColor = .white
        self.maleView?.translatesAutoresizingMaskIntoConstraints = false
        self.maleView?.addRadius(value: 5, color: UIColor.lpGrayShadow.cgColor, width: 1)
        
        
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        
        let maleLabel: UILabel = UILabel()
        maleLabel.translatesAutoresizingMaskIntoConstraints = false
        maleLabel.text = "M."
        maleLabel.textAlignment = .center
        maleLabel.textColor = .lpGrey
        
        self.maleCheckImage.translatesAutoresizingMaskIntoConstraints = false
        self.maleCheckImage.tintColor = .lpPurple
        self.maleCheckImage.isHidden = true
        
        self.maleView?.addSubview(self.maleCheckImage)
        self.maleView?.addSubview(maleButton)
        self.maleView?.addSubview(maleLabel)
        
        NSLayoutConstraint.activate([
            self.maleView!.heightAnchor.constraint(equalToConstant: 50),
            self.maleCheckImage.widthAnchor.constraint(equalToConstant: 10),
            self.maleCheckImage.heightAnchor.constraint(equalToConstant: 8),
            self.maleCheckImage.topAnchor.constraint(equalTo: self.maleView!.topAnchor, constant: 10),
            self.maleCheckImage.rightAnchor.constraint(equalTo: self.maleView!.rightAnchor, constant: -10),
            maleButton.topAnchor.constraint(equalTo: self.maleView!.topAnchor),
            maleButton.bottomAnchor.constraint(equalTo: self.maleView!.bottomAnchor),
            maleButton.leftAnchor.constraint(equalTo: self.maleView!.leftAnchor),
            maleButton.rightAnchor.constraint(equalTo: self.maleView!.rightAnchor),
            maleLabel.centerXAnchor.constraint(equalTo: self.maleView!.centerXAnchor),
            maleLabel.centerYAnchor.constraint(equalTo: self.maleView!.centerYAnchor),
            maleLabel.leftAnchor.constraint(equalTo: self.maleView!.leftAnchor, constant: 10),
            maleLabel.rightAnchor.constraint(equalTo: self.maleView!.rightAnchor, constant: -10),
            ])
        
        // Female
        self.femaleView = UIView()
        self.femaleView?.backgroundColor = .white
        self.femaleView?.translatesAutoresizingMaskIntoConstraints = false
        self.femaleView?.addRadius(value: 5, color: UIColor.lpGrayShadow.cgColor, width: 1)
        
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.addTarget(self, action: #selector(femaleButtonTapped(sender:)), for: .touchUpInside)
        
        let femaleLabel: UILabel = UILabel()
        femaleLabel.translatesAutoresizingMaskIntoConstraints = false
        femaleLabel.text = "Mme."
        femaleLabel.textAlignment = .center
        femaleLabel.textColor = .lpGrey
        
        self.femaleCheckImage.translatesAutoresizingMaskIntoConstraints = false
        self.femaleCheckImage.tintColor = .lpPurple
        self.femaleCheckImage.isHidden = true
        
        self.femaleView?.addSubview(self.femaleCheckImage)
        self.femaleView?.addSubview(femaleButton)
        self.femaleView?.addSubview(femaleLabel)
        
        genderStackView.addArrangedSubview(self.maleView!)
        genderStackView.addArrangedSubview(self.femaleView!)
        
        NSLayoutConstraint.activate([
            self.femaleView!.heightAnchor.constraint(equalToConstant: 50),
            self.femaleCheckImage.widthAnchor.constraint(equalToConstant: 10),
            self.femaleCheckImage.heightAnchor.constraint(equalToConstant: 8),
            self.femaleCheckImage.topAnchor.constraint(equalTo: self.femaleView!.topAnchor, constant: 10),
            self.femaleCheckImage.rightAnchor.constraint(equalTo: self.femaleView!.rightAnchor, constant: -10),
            femaleButton.topAnchor.constraint(equalTo: self.femaleView!.topAnchor),
            femaleButton.bottomAnchor.constraint(equalTo: self.femaleView!.bottomAnchor),
            femaleButton.leftAnchor.constraint(equalTo: self.femaleView!.leftAnchor),
            femaleButton.rightAnchor.constraint(equalTo: self.femaleView!.rightAnchor),
            femaleLabel.centerXAnchor.constraint(equalTo: self.femaleView!.centerXAnchor),
            femaleLabel.centerYAnchor.constraint(equalTo: self.femaleView!.centerYAnchor),
            femaleLabel.leftAnchor.constraint(equalTo: self.femaleView!.leftAnchor, constant: 10),
            femaleLabel.rightAnchor.constraint(equalTo: self.femaleView!.rightAnchor, constant: -10),
            ])
        
        self.addSubview(genderStackView)
        
        let genderLabel: UILabel = UILabel()
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.text = "Civilité"
        genderLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        genderLabel.textColor = .lpDeepBlue
        self.addSubview(genderLabel)
        
        NSLayoutConstraint.activate([
            genderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            genderLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            genderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            genderStackView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            genderStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            genderStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            genderStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            self.heightAnchor.constraint(equalToConstant: 100),
            ])
    }
    
    @objc func femaleButtonTapped(sender: UIButton) {
        self.maleView?.layer.borderColor = UIColor.lpGrey.cgColor
        self.femaleView?.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 1, y: 1, blur: 5, spread: 1)
        self.femaleView?.layer.borderColor = UIColor.lpPurple.cgColor
        self.isMale = false
        self.delegate?.genderSelected()
        self.updateCheckView()
    }
    
    @objc func maleButtonTapped(sender: UIButton) {
        self.femaleView?.layer.borderColor = UIColor.lpGrey.cgColor
        self.maleView?.layer.borderColor = UIColor.lpPurple.cgColor
        self.maleView?.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 1, y: 1, blur: 5, spread: 1)
        self.isMale = true
        self.delegate?.genderSelected()
        self.updateCheckView()
    }
    
    func setGender(isMale: Bool?) {
        if let _isMale = isMale {
            self.isMale = !_isMale
            updateCheckView()
            if self.isMale! {
                maleButton.sendActions(for: .touchUpInside)
            } else {
                femaleButton.sendActions(for: .touchUpInside)
            }
        }
    }
    
    func updateCheckView() {
        self.maleCheckImage.isHidden = !self.isMale!
        self.femaleCheckImage.isHidden = self.isMale!
    }
    
    func isGenderSelected() -> Bool {
        return isMale != nil
    }
    
    func isMaleUser() -> Bool {
        return isMale!
    }
}
