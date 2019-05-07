//
//  TrackTableHeaderFooterView.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 06/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol TrackTableHeaderFooterViewDelegate {
    func toggleSection(_ header: TrackTableHeaderFooterView, section: Int)
}

class TrackTableHeaderFooterView: UITableViewHeaderFooterView {
    
    var delegate: TrackTableHeaderFooterViewDelegate?
    var section: Int = 0
    
    let titleLabel = UILabel()
    let rightImage = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(self.rightImage)
        self.rightImage.translatesAutoresizingMaskIntoConstraints = false
        self.rightImage.widthAnchor.constraint(equalToConstant: 12).isActive = true
        self.rightImage.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        self.rightImage.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -10).isActive = true
        self.rightImage.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        self.rightImage.contentMode = .center
        
        contentView.addSubview(self.titleLabel)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 10).isActive = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TrackTableHeaderFooterView.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? TrackTableHeaderFooterView else {
            return
        }
        
        self.delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        self.rightImage.rotate(collapsed ? 0.0 : -(.pi / 2))
    }

}

