//
//  ForgottenPasswordViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 02/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class ForgottenPasswordViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordDescription: UILabel!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var forgottenPasswordTitleView: UIView!
    @IBOutlet weak var fakeBackground: UIView!
    @IBOutlet weak var snackbar: UIView!
    lazy var loaderManager = LoaderViewManager()
    let viewModel = ForgottenPasswordModel()
    var emailTextFieldController: MDCTextInputControllerFilled?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.snackbar.isHidden = true
        UIView.animate(withDuration: 0, delay: 0, options: [], animations: {
            self.fakeBackground.alpha = 0
            self.emailTextFieldController =  MDCTextInputControllerFilled(textInput: self.emailTextField)
            self.emailTextField.delegate = self
            self.emailTextFieldController?.placeholderText = "Saisissez votre adresse e-mail"
            self.applyButton.layer.cornerRadius = self.applyButton.frame.size.height / 2
            self.containerView.clipsToBounds = true
            self.containerView.backgroundColor = .clear
            self.view.backgroundColor = .clear
        }) { isFinished in
            if isFinished {
                UIView.animate(withDuration: 0.7, animations: {
                    self.fakeBackground.alpha = 0.7
                    self.fakeBackground.backgroundColor = .lpGrey
                })
            }
        }
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kPopinForgottenPassword,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kHomeLevel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ForgottenPasswordViewController.closeButtonTapped(_:)))
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ForgottenPasswordViewController.closeButtonTapped(_:)))
        swipeGesture.direction = .down
        
        self.fakeBackground.addGestureRecognizer(tapGesture)
        self.containerView.addGestureRecognizer(swipeGesture)
    }

    override func viewDidLayoutSubviews() {
        self.containerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        if self.emailTextField.text?.isEmpty == true || self.emailTextField.text?.isValidEmail() == false {
            self.snackbar.isHidden = false
            self.snackbar.backgroundColor = .lpPurple
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ForgottenPasswordViewController.hideSnackbar), userInfo: nil, repeats: false)
        } else {
            self.loaderManager.showLoderView()
            self.viewModel.resetPassword(email: self.emailTextField.text ?? "") { response in
                self.loaderManager.hideLoaderView()
                switch response {
                case .email:
                    let alertController = UIAlertController(title: nil, message: "L'email saisi n'existe pas", dismissActionTitle: "Fermer", dismissActionBlock: {})
                    self.present(alertController!, animated: true, completion: nil)
                case .network:
                    let alertController = UIAlertController(title: nil, message: "Une erreur est survenue", dismissActionTitle: "Fermer", dismissActionBlock: {})
                    self.present(alertController!, animated: true, completion: nil)
                case .none:
                    let alertController = UIAlertController(title: nil, message: "Email envoyé", dismissActionTitle: "Fermer", dismissActionBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
                    self.present(alertController!, animated: true, completion: nil)
                }
            }

            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kEnvoyerMail , pageName: TaggingData.kPopinForgottenPassword, chapter1: nil, chapter2: nil, level2: TaggingData.kHomeLevel)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.fakeBackground.alpha = 0
        }) { isFinished in
            if isFinished {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func hideSnackbar() {
        self.snackbar.isHidden = true
    }
}

extension ForgottenPasswordViewController: UITextFieldDelegate {
    
}
