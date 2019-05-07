//
//  FooterView.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 23/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol FooterDelegate: class {
    func needHelpTapped()
    func callCustomerService()
}

class FooterView: UIView {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    @IBOutlet weak var needHelpView: UIView!
    @IBOutlet weak var customerServiceLabel: UILabel!
    @IBOutlet weak var customerServiceView: UIView!
    @IBOutlet weak var version: UILabel!
    
    static let height: CGFloat = 350
    weak var delegate: FooterDelegate?
    
    func initFooterView() -> FooterView {
        let customFooter = Bundle.main.loadNibNamed("Footer", owner: self, options: nil)?.first as? FooterView
        customFooter?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: FooterView.height)
        
        return customFooter!
    }
    
    override func awakeFromNib() {
        self.finishLoading()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(needHelpViewClicked))
        needHelpView.addGestureRecognizer(gestureRecognizer)
        
        customerServiceLabel.attributedText = createCustomerServiceText()
        let customerGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callCustomerCenterViewClicked))
        customerServiceView.addGestureRecognizer(customerGestureRecognizer)
        self.version.text = AppDelegate.getVersionString()
    }
    
    func startLoading() {
        if loadingIndicator != nil {
            loadingIndicator?.isHidden = false
            loadingIndicator?.startAnimating()
        }
    }
    
    func finishLoading() {
        if loadingIndicator != nil {
            loadingIndicator?.isHidden = true
            loadingIndicator?.stopAnimating()
        }
    }
    
    @objc private func needHelpViewClicked() {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAideEnLignePro,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kFooter,
                                                              chapter2: nil,
                                                              level2: TaggingData.kTransverseLevel)
        
        delegate?.needHelpTapped()
    }
    
    @objc private func callCustomerCenterViewClicked() {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAppelerServiceClient,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kFooter,
                                                              chapter2: nil,
                                                              level2: TaggingData.kTransverseLevel)
        
        if let url = URL(string: "tel://0969321321") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func createCustomerServiceText() -> NSMutableAttributedString {
        return NSMutableAttributedString()
            .custom("Contacter le Service Clients", font: UIFont.systemFont(ofSize: 14), color: .black)
    }
}
