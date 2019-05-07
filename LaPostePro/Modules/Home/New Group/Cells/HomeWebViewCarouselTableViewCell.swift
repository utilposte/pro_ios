//
//  HomeWebViewCarouselTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 11/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import WebKit

class HomeWebViewCarouselTableViewCell: UITableViewCell, WKUIDelegate {

    var webView: WKWebView!
    @IBOutlet weak var webViewContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setupCell() {
        
         let htmlContent = "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> <style>*{box-sizing: border-box;}body{font-family: Verdana, sans-serif;margin: 0; text-align: center;background-color:#fafafa}.mySlides{display: block;}img{vertical-align: middle;}/* Slideshow container */ .slideshow-container{height: 100%; position: relative; margin: auto;}/* Caption text */ .text{color: #f2f2f2; font-size: 15px; padding: 8px 12px; position: absolute; bottom: 8px; width: 100%; text-align: center;}/* Number text (1/3 etc) */ .numbertext{color: #f2f2f2; font-size: 12px; padding: 8px 12px; position: absolute; top: 0;}/* The dots/bullets/indicators */ .dot{height: 15px; width: 15px; margin: 0 2px; background-color: #bbb; border-radius: 50%; display: inline-block; transition: background-color 0.6s ease;}.active{background-color: #717171;}/* Fading animation */ .fade{-webkit-animation-name: fade; -webkit-animation-duration: 1.5s; animation-name: fade; animation-duration: 1.5s;}@-webkit-keyframes fade{from{opacity: .4}to{opacity: 1}}@keyframes fade{from{opacity: .4}to{opacity: 1}}/* On smaller screens, decrease text size */ @media only screen and (max-width: 300px){.text{font-size: 11px}}</style> </head> <body> <div class=\"slideshow-container\"> <div class=\"mySlides active\"> <img src=\"https://boutique.laposte.fr/medias/sys_master/images/h8e/h2c/11299391537182/Application-pro.png\" style=\"width:100%\"> </div></div></body> </html>"
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences
        self.webView = WKWebView(frame: webViewContainer.frame, configuration: webConfiguration)
//        self.webView.uiDelegate = self
        self.webViewContainer.addSubview(self.webView)

        self.webView.loadHTMLString(htmlContent, baseURL: nil)
    }

}
