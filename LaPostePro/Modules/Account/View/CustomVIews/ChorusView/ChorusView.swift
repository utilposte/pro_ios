//
//  ChorusView.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 03/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import ActiveLabel

protocol ChorusDelegate: class {
    func serviceListButtonTapped()
}

class ChorusView: UIView {
    
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    weak var delegate: ChorusDelegate?
    @IBOutlet weak var serviceListButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // custom type for Active label
    let help = ActiveType.custom(pattern: "Aide en ligne\\b")//Looks for "Aide en ligne\"
    let chorus = ActiveType.custom(pattern: "\\sChorus Pro\\b") //Looks for "Chorus Pro"
    
    override func awakeFromNib() {
        self.serviceListButton.layer.borderColor = UIColor.lpGrey.cgColor
        self.serviceListButton.layer.borderWidth = 1
        self.serviceListButton.layer.cornerRadius = 5
        self.serviceListButton.titleLabel?.numberOfLines = 2
        self.serviceListButton.backgroundColor = UIColor.white
        self.serviceListButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        serviceListButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, UIScreen.main.bounds.width-80, 0.0, 0.0)
        serviceListButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0)
        
        self.containerView.layer.cornerRadius = 5
        let activeLabel = ActiveLabel()
        activeLabel.numberOfLines = 0
        activeLabel.font = UIFont.systemFont(ofSize: 13)
        activeLabel.textColor = UIColor.black
        
        activeLabel.frame = .zero
        
        activeLabel.text = "Vous trouverez toutes les informations complémentaires dans l'Aide en ligne ainsi que sur le site Chorus Pro."
        activeLabel.enabledTypes = [.url, help, chorus]
        activeLabel.sizeToFit()
        activeLabel.customColor[help] = UIColor.lpPurple
        activeLabel.customColor[chorus] = UIColor.lpPurple
        activeLabel.customize { (label) in
            label.URLColor = UIColor.lpPurple
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 13, weight: .semibold)
                return atts
            }
        }
        activeLabel.handleURLTap { url in self.openWebView(for: url.absoluteString) }
        activeLabel.handleCustomTap(for: help) { (element) in
            self.openWebView(for: WebViewURL.pro.rawValue)
        }
        activeLabel.handleCustomTap(for: chorus) { (element) in
            self.openWebView(for: WebViewURL.chorus.rawValue)
        }
        self.addSubview(activeLabel)
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activeLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 18),
            activeLabel.bottomAnchor.constraint(equalTo: self.serviceListButton.topAnchor, constant: -23),
            activeLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10),
            activeLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -10),
            ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func serviceListButtonClicked(_ sender: Any) {
        delegate?.serviceListButtonTapped()
    }
    
    func setText(serviceText: String) {
        self.serviceListButton.setTitle(serviceText, for: .normal)
        self.serviceListButton.setTitleColor(.lpDeepBlue, for: .normal)
    }
    
    func getText() -> String {
        return (serviceListButton.titleLabel?.text)!
    }
    
    func setErrorStyle() {
        self.serviceListButton.layer.borderColor = UIColor.lpRedForUnavailableProduct.cgColor
        self.serviceListButton.setTitleColor(.lpRedForUnavailableProduct, for: .normal)
    }
    
    func setServiceList(_ isServiceList : Bool) {
        buttonHeight.constant = isServiceList ? 50:0
        serviceListButton.isHidden = !isServiceList
    }
    //    func openWebView(for url: String) {
    //        let viewController = R.storyboard.webView.webViewControllerID()!
    //        viewController.url = url
    //        self.parentViewController?.navigationController?.setNavigationBarHidden(false, animated: false)
    //        self.parentViewController?.navigationController?.navigationBar.tintColor = .lpGrey
    //        self.parentViewController?.navigationController!.pushViewController(viewController, animated: true)
    //    }
}
