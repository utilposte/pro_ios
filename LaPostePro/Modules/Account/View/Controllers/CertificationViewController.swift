//
//  CertificationViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 24/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import ActiveLabel
import UIKit

class CertificationViewController: UIViewController {
    @IBOutlet var background: UIView!
    @IBOutlet var firstMethodeLabel: UILabel!
    @IBOutlet var footerLabel: UILabel!
    @IBOutlet var secondeMethodeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    // custom type for Active label
    // let form = ActiveType.custom(pattern: "\\sformulaire en ligne\\b")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIView.animate(withDuration: 0, delay: 0, options: [], animations: {
            self.background.alpha = 0
            // self.headerView.roundCorners([.topLeft, .topRight], radius: 20)
            self.view.backgroundColor = .clear
        }) { isFinished in
            if isFinished {
                UIView.animate(withDuration: 0.7, animations: {
                    self.background.alpha = 0.7
                    self.background.backgroundColor = .lpGrey
                })
            }
        }
        
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kPopinCertificationInstruction,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kAccountLevel)
    }
    
    func setupText() {
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Saisir ce ")
            .custom("formulaire en ligne ", font: UIFont.systemFont(ofSize: 15, weight: .semibold), color: .lpPurple)
            .custom("(choix \"Votre compte Boutique\", motif \"Envoi de pièces justificatives\") ", font: UIFont.italicSystemFont(ofSize: 14), color: .lpGrey)
            .normal(" sans oublier de ")
            .custom("télécharger vos documents avant de valider l'envoi. ", font: UIFont.systemFont(ofSize: 14, weight: .semibold), color: .lpGrey)
        firstMethodeLabel.attributedText = formattedString
        
        let secondeMethodeFormattedString = NSMutableAttributedString()
        secondeMethodeFormattedString
            .normal("Envoyer ces documents ")
            .custom("par courrier à l'adresse suivante ", font: UIFont.systemFont(ofSize: 15, weight: .semibold), color: .lpGrey)
            .normal(":")
        secondeMethodeLabel.attributedText = secondeMethodeFormattedString
        
        let addressFormattedString = NSMutableAttributedString()
        addressFormattedString
            .custom("La Poste – St Brieuc ADV\n", font: UIFont.systemFont(ofSize: 15, weight: .semibold), color: .lpDeepBlue)
            .normal("Service boutique\nCS 63549\n22035 St Brieuc cedex 1")
        addressLabel.attributedText = addressFormattedString
        
        let footerFormattedString = NSMutableAttributedString()
        footerFormattedString
            .normal("Pour en savoir plus sur la validation de votre compte Pro, veuillez consulter l’")
            .custom("Aide en ligne", font: UIFont.systemFont(ofSize: 15, weight: .semibold), color: .lpPurple)
            .normal(".")
        footerLabel.attributedText = footerFormattedString
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func firstMethodeLabel(_ sender: UITapGestureRecognizer) {
        let text = firstMethodeLabel.text!
        let formRange = (text as NSString).range(of: "formulaire en ligne")
        if sender.didTapAttributedTextInLabel(label: self.firstMethodeLabel, inRange: formRange) {
            let viewController = R.storyboard.webView.webViewControllerID()!
//            viewController.url = "http://aide.boutique.laposte.fr/contact.php?profil=pro"
            viewController.url = WebViewURL.validation.rawValue
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.navigationBar.tintColor = .lpGrey
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func footerLabel(_ sender: UITapGestureRecognizer) {
        // let text = (footerLabel.text)!
        // let formRange = (text as NSString).range(of: "Aide en ligne")
        // if sender.didTapAttributedTextInLabel(label: footerLabel, inRange: formRange) {
        let viewController = R.storyboard.webView.webViewControllerID()!
        viewController.url = WebViewURL.pro.rawValue
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = .lpGrey
        self.navigationController!.pushViewController(viewController, animated: true)
        // }
    }
}
