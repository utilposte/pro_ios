//
//  CategoryHeaderTableViewCell.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 23/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class CategoryHeaderTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    var openSearchClosure : (() -> ())? = nil ;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupHeaderLabel()
        setupSearchField()
    }

    func setupHeaderLabel() {
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Que ")
            .bold("recherchez-vous ", size: 28)
            .normal(" aujourd’hui ?")
        headerLabel.attributedText = formattedString
    }

    func setupSearchField() {
        searchField.setLeftPaddingPoints(32.0)
        searchField.attributedPlaceholder = NSAttributedString(string: "Rechercher un produit", attributes: [NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x787882)])
        
        let imageView = UIImageView()
        let magnifyingGlassImage = UIImage(named: "magnifyingGlass")
        imageView.image = magnifyingGlassImage
        
        imageView.frame = CGRect(x: 0, y: 5, width: 45, height: 20)
        imageView.contentMode = .scaleAspectFit
        
        searchField.leftViewMode = .always
        searchField.leftView = imageView
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        openSearchClosure?()
        return false
    }
}
