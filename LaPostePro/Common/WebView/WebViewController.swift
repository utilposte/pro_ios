//
//  WebViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 20/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

enum WebViewControllerType {
    case needHelp
    case contactUsForm
    case returnOrder
    case colissimo(completion: (String) -> ())
    case none
}

class WebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {

    var url: String?
    var webViewType: WebViewControllerType?
    lazy var loaderManager = LoaderViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = self.url else { return }
        switch webViewType ?? .none {
        case .colissimo:
            setup()
            loaderManager.showLoderView()
            self.setupWKWebView(url: url)
        default:
            guard let myUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
            let svc = SFSafariViewController(url: myUrl)
            svc.delegate = self
            present(svc, animated: false, completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch webViewType ?? .none {
        case .colissimo:
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kAddDelivreyAddress,
                                                                 chapter1: TaggingData.kTunnel,
                                                                 chapter2: nil,
                                                                 level2: TaggingData.kCommerceLevel)
        default:
            return
        }
    }
    
    private func setup() {
        switch webViewType ?? .none {
        case .needHelp:
            setupTitleNavigationBar(backEnabled: true, title: "Besoin d'aide ?",showCart: false)
        case .contactUsForm:
            setupTitleNavigationBar(backEnabled: true, title: "Contactez-nous",showCart: false)
        case .returnOrder:
            setupTitleNavigationBar(backEnabled: true, title: "Retourner la commande",showCart: false)
        default:
            setupTitleNavigationBar(backEnabled: true, title: "",showCart: false)
        }
    }

    private func setupWKWebView(url: String) {
        let wkWebView = WKWebView()
        self.view.addSubview(wkWebView)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: self.view.topAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            wkWebView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            wkWebView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])

        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        guard let myUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        var urlRequest = URLRequest(url: myUrl)
        
        
        
        
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("1", forHTTPHeaderField: "Hybride")
        urlRequest.addValue("1", forHTTPHeaderField: "WithHeader")
        
        
        wkWebView.load(urlRequest)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        
        if navigationAction.navigationType == WKNavigationType.formSubmitted {
            if navigationAction.request.url?.absoluteString.contains("/so-colissimo/success") == true {
                decisionHandler(WKNavigationActionPolicy.cancel)
                    switch webViewType ?? .none {
                    case .colissimo(let completion):
                        completion((navigationAction.request.url?.absoluteString)!)
                    default:
                        return
                    }
                //ShippingCartViewModel.postResultColissimo(urlString: (navigationAction.request.url?.absoluteString)!)
                self.navigationController?.popViewController(animated: true)
                return
            } else if navigationAction.request.url?.absoluteString.contains("/so-colissimo/failed") == true {
                let alertController = UIAlertController(title: "Erreur", message: "Une erreur est survenue", dismissActionTitle: "Fermer") {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                decisionHandler(WKNavigationActionPolicy.cancel)
                self.present(alertController!, animated: true, completion: nil)
                return
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
        return
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderManager.hideLoaderView()
    }

}

extension WebViewController : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.navigationController?.popViewController(animated: false)
    }
}
