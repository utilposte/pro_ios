//
//  FormTitleView.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 10/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class FormTitleView: UIView {
    private var titleLabel: UILabel!
    
    init() { super.init(frame: CGRect.zero) }
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        self.titleLabel =  UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.textColor = UIColor.lpDeepBlue
        self.addSubview(titleLabel!)
        setTitleLabelConstaints()
        self.backgroundColor = .white
    }
    
    private func setTitleLabelConstaints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            self.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
