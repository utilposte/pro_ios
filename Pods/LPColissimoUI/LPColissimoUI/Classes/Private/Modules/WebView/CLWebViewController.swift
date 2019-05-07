//
//  CLWebViewController.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 21/01/2019.
//

import UIKit

public class CLWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    public var url: String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
        
        if let _urlString = url, let _url = URL.init(string: _urlString) {
            self.webView.loadRequest(URLRequest.init(url: _url))
        }
        
    }

}
