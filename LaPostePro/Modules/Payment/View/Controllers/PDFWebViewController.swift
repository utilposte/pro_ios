//
//  PDFWebViewController.swift
//  LPColissimoUI
//
//  Created by SPASOV DIMITROV Vladimir on 11/01/2019.
//

import UIKit

public class PDFWebViewController: UIViewController {

    @IBOutlet weak var pdfButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    public var pdfData: Data?
    public var orderNumber: String?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Enregistrer"
        
        
        if let _data = pdfData {
            webView.load(_data, mimeType: "application/pdf", textEncodingName: "UTF-8", baseURL: NSURL() as URL)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        if let _data = self.pdfData {
            let activityViewController = UIActivityViewController.init(activityItems: [_data], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
