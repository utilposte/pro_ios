//
//  UpdatePasswordViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 22/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var actualPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var renewPasswordView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    lazy var loaderManager = LoaderViewManager()
    
    // MARK: FormElement View
    var actualPasswordFormElement: FormElementView?
    var newPasswordFormElement: FormElementView?
    var renewPasswordFormElement: FormElementView?
    
    // MARK: FormElement Struct
    var actualPasswordFormStruct: FormElementStruct?
    var newPasswordFormStruct: FormElementStruct?
    var renewPasswordFormStruct: FormElementStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupModalNavigationBar(title: "Changer le mot de passe", image: R.image.ic_close())
        self.setupActualPassword()
        self.setupNewPassword()
        self.setupRenewPassword()
        self.setupConfirmButton()
        self.disbaleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kEditPassword,
                                                             chapter1: TaggingData.kYourProfile,
                                                             chapter2: TaggingData.kPersonal,
                                                             level2: TaggingData.kAccountLevel)
    }
    
    private func setupConfirmButton() {
        self.confirmButton.backgroundColor = .lpPurple
        self.confirmButton.layer.cornerRadius = self.confirmButton.frame.height / 2
        self.confirmButton.setTitle("Confirmer", for: .normal)
        self.confirmButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupActualPassword() {
        self.actualPasswordFormStruct = FormElementStruct(placeholder: "Saisissez le mot de passe actuel", helperText: "", errorText: "Mot de passe invalide", isRequired: true, isDisplayed: true, action: .none, isSecured: true, defaultValue: nil, shouldSeePassword: true, elementType: .none)
        self.actualPasswordFormElement = FormElementView(self.actualPasswordFormStruct!)
        self.actualPasswordView.addSubview(self.actualPasswordFormElement!)
        self.actualPasswordView.translatesAutoresizingMaskIntoConstraints = false
        self.actualPasswordFormElement?.translatesAutoresizingMaskIntoConstraints = false
        self.actualPasswordFormElement?.textfield?.addTarget(self, action: #selector(UpdatePasswordViewController.checkTextfield), for: .editingChanged)
        NSLayoutConstraint.activate([
            self.actualPasswordFormElement!.rightAnchor.constraint(equalTo: self.actualPasswordView.rightAnchor),
            self.actualPasswordFormElement!.leftAnchor.constraint(equalTo: self.actualPasswordView.leftAnchor),
            self.actualPasswordFormElement!.topAnchor.constraint(equalTo: self.actualPasswordView.topAnchor),
            self.actualPasswordFormElement!.bottomAnchor.constraint(equalTo: self.actualPasswordView.bottomAnchor),
            ])
    }
    
    private func setupNewPassword() {
        self.newPasswordFormStruct = FormElementStruct(placeholder: "Saisissez un mot de passe", helperText: "", errorText: "Mot de passe invalide", isRequired: true, isDisplayed: true, action: .none, isSecured: true, defaultValue: nil, shouldSeePassword: true, elementType: .none)
        self.newPasswordFormElement = FormElementView(self.newPasswordFormStruct!)
        self.newPasswordView.addSubview(self.newPasswordFormElement!)
        self.newPasswordView.translatesAutoresizingMaskIntoConstraints = false
        self.newPasswordFormElement?.translatesAutoresizingMaskIntoConstraints = false
        self.newPasswordFormElement?.textfield?.addTarget(self, action: #selector(UpdatePasswordViewController.checkTextfield), for: .editingChanged)
        NSLayoutConstraint.activate([
            self.newPasswordFormElement!.rightAnchor.constraint(equalTo: self.newPasswordView.rightAnchor),
            self.newPasswordFormElement!.leftAnchor.constraint(equalTo: self.newPasswordView.leftAnchor),
            self.newPasswordFormElement!.topAnchor.constraint(equalTo: self.newPasswordView.topAnchor),
            self.newPasswordFormElement!.bottomAnchor.constraint(equalTo: self.newPasswordView.bottomAnchor),
        ])
    }
    
    private func setupRenewPassword() {
        self.renewPasswordFormStruct = FormElementStruct(placeholder: "Saisissez un mot de passe", helperText: "", errorText: "Mot de passe invalide", isRequired: true, isDisplayed: true, action: .none, isSecured: true, defaultValue: nil, shouldSeePassword: true, elementType: .none)
        self.renewPasswordFormElement = FormElementView(self.renewPasswordFormStruct!)
        self.renewPasswordView.addSubview(self.renewPasswordFormElement!)
        self.renewPasswordView.translatesAutoresizingMaskIntoConstraints = false
        self.renewPasswordFormElement?.translatesAutoresizingMaskIntoConstraints = false
        self.renewPasswordFormElement?.textfield?.addTarget(self, action: #selector(UpdatePasswordViewController.checkTextfield), for: .editingChanged)
        NSLayoutConstraint.activate([
            self.renewPasswordFormElement!.rightAnchor.constraint(equalTo: self.renewPasswordView.rightAnchor),
            self.renewPasswordFormElement!.leftAnchor.constraint(equalTo: self.renewPasswordView.leftAnchor),
            self.renewPasswordFormElement!.topAnchor.constraint(equalTo: self.renewPasswordView.topAnchor),
            self.renewPasswordFormElement!.bottomAnchor.constraint(equalTo: self.renewPasswordView.bottomAnchor),
            ])
    }
    
    private func enableButton() {
        self.confirmButton.isEnabled = true
        self.confirmButton.backgroundColor = .lpPurple
    }
    
    private func disbaleButton() {
        self.confirmButton.isEnabled = false
        self.confirmButton.backgroundColor = .lpGrey
    }
    
    @objc func checkTextfield() {
        if self.actualPasswordFormElement?.textfield?.text != "" && self.newPasswordFormElement?.textfield?.text != "" && self.renewPasswordFormElement?.textfield?.text != "" {
            self.enableButton()
        } else {
            self.disbaleButton()
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.loaderManager.showLoderView()
        if self.actualPasswordFormElement?.getText() == "" {
            self.loaderManager.hideLoaderView()
            self.actualPasswordFormElement?.setupErrorStyle(errorText: "Veuillez renseigner votre mot de passe actuel")
        } else if !(self.newPasswordFormElement?.getText().isValidPassword())! {
            self.loaderManager.hideLoaderView()
            //self.newPasswordFormElement?.setupErrorStyle(errorText: "Le mot de passe n’est pas conforme. Il doit comprendre 8 caractères alphanumériques minimum et au moins un chiffre et une lettre")
            let alertController = UIAlertController(title: "Changer votre mot de passe", message: "Le mot de passe n’est pas conforme. Il doit comprendre 8 caractères alphanumériques minimum et au moins un chiffre et une lettre", dismissActionTitle: "Fermer", dismissActionBlock: {
            })
            self.present(alertController!, animated: true, completion: nil)
        } else if self.newPasswordFormElement?.getText() != self.renewPasswordFormElement?.getText() {
            self.loaderManager.hideLoaderView()
            //self.newPasswordFormElement?.setupErrorStyle(errorText: "Les mots de passe ne sont pas identiques")
            //self.renewPasswordFormElement?.setupErrorStyle(errorText: "Les mots de passe ne sont pas identiques")
            let alertController = UIAlertController(title: "Changer votre mot de passe", message: "Les mots de passe sont différents", dismissActionTitle: "Fermer", dismissActionBlock: {
            })
            self.present(alertController!, animated: true, completion: nil)
        } else if self.newPasswordFormElement?.getText() == self.actualPasswordFormElement?.getText() {
            self.loaderManager.hideLoaderView()
            //self.newPasswordFormElement?.setupErrorStyle(errorText: "Le nouveau mot de passe doit être différent du mot de pas actuel")
            //self.renewPasswordFormElement?.setupErrorStyle(errorText: "Le nouveau mot de passe doit être différent du mot de pas actuel")
            let alertController = UIAlertController(title: "Changer votre mot de passe", message: "Le nouveau mot de passe doit être différent du mot de passe actuel", dismissActionTitle: "Fermer", dismissActionBlock: {
            })
            self.present(alertController!, animated: true, completion: nil)
        } else if self.actualPasswordFormElement?.getText() != KeychainService().get(key: "password") {
            self.loaderManager.hideLoaderView()
            let alertController = UIAlertController(title: "Changer votre mot de passe", message: "Le mot de passe actuel saisi est erroné", dismissActionTitle: "Fermer", dismissActionBlock: {
            })
            self.present(alertController!, animated: true, completion: nil)
        } else {
            let manager = AccountNetworkManager()
            let model = PasswordModel(oldPassword: self.actualPasswordFormElement?.getText(), newPassword: self.newPasswordFormElement?.getText())
            manager.updatePassword(passwordModel: model) { isSuccess in
                self.loaderManager.hideLoaderView()
                if isSuccess {
                    let alertController = UIAlertController(title: "Changer votre mot de passe", message: "Votre mot de passe a bien était changé", dismissActionTitle: "Fermer", dismissActionBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
                    self.present(alertController!, animated: true, completion: nil)
                    // ATInternet
                    ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kConfirmerModificationMdp , pageName: nil, chapter1: TaggingData.kYourProfile, chapter2: TaggingData.kPersonal, level2: TaggingData.kAccountLevel)
                } else {
                    let alertController = UIAlertController(title: "Changer votre mot de passe", message: "Une erreure est survenue", dismissActionTitle: "Fermer", dismissActionBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
                    self.present(alertController!, animated: true, completion: nil)
                }
            }
        }
    }
    
}
