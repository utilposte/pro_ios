//
//  UpdateEmailViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 23/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class UpdateEmailViewController: UIViewController {

    @IBOutlet weak var oldEmailView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var oldEmailLabel: UILabel!
    @IBOutlet weak var newEmailView: UIView!
    @IBOutlet weak var renewEmailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    var newEmailFormElement: FormElementView?
    var renewEmailFormElement: FormElementView?
    var passwordFormElement: FormElementView?
    var newEmailFormStruct: FormElementStruct?
    var renewEmailFormStruct: FormElementStruct?
    var passwordFormStruct: FormElementStruct?
    lazy var loaderManager = LoaderViewManager()
    
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupModalNavigationBar(title: "Modifier adresse e-mail", image: R.image.ic_close())
        self.setupNewEmail()
        self.setupRenewEmail()
        self.setupPassword()
        self.setupConfirmButton()
        
        self.oldEmailLabel.text = UserAccount.shared.customerInfo?.displayUid
        self.oldEmailView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kEditEmail,
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
    
    private func setupNewEmail() {
        self.newEmailFormStruct = FormElementStruct(placeholder: "Nouvelle adresse e-mail", helperText: "", errorText: "Adresse e-mail invalide", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        self.newEmailFormElement = FormElementView(self.newEmailFormStruct!)
        self.newEmailView.addSubview(self.newEmailFormElement!)
        self.newEmailView.translatesAutoresizingMaskIntoConstraints = false
        self.newEmailFormElement?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.newEmailFormElement!.rightAnchor.constraint(equalTo: self.newEmailView.rightAnchor),
            self.newEmailFormElement!.leftAnchor.constraint(equalTo: self.newEmailView.leftAnchor),
            self.newEmailFormElement!.topAnchor.constraint(equalTo: self.newEmailView.topAnchor),
            self.newEmailFormElement!.bottomAnchor.constraint(equalTo: self.newEmailView.bottomAnchor),
            ])
    }
    
    private func setupRenewEmail() {
        self.renewEmailFormStruct = FormElementStruct(placeholder: "Confirmer l'adresse e-mail", helperText: "", errorText: "Adresse e-mail invalide", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
        self.renewEmailFormElement = FormElementView(self.renewEmailFormStruct!)
        self.renewEmailView.addSubview(self.renewEmailFormElement!)
        self.renewEmailView.translatesAutoresizingMaskIntoConstraints = false
        self.renewEmailFormElement?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.renewEmailFormElement!.rightAnchor.constraint(equalTo: self.renewEmailView.rightAnchor),
            self.renewEmailFormElement!.leftAnchor.constraint(equalTo: self.renewEmailView.leftAnchor),
            self.renewEmailFormElement!.topAnchor.constraint(equalTo: self.renewEmailView.topAnchor),
            self.renewEmailFormElement!.bottomAnchor.constraint(equalTo: self.renewEmailView.bottomAnchor),
            ])
    }
    
    private func setupPassword() {
        self.passwordFormStruct = FormElementStruct(placeholder: "Saisir votre mot de passe", helperText: "", errorText: "Mot de passe invalide", isRequired: true, isDisplayed: true, action: .none, isSecured: true, defaultValue: nil, shouldSeePassword: true, elementType: .none)
        self.passwordFormElement = FormElementView(self.passwordFormStruct!)
        self.passwordView.addSubview(self.passwordFormElement!)
        self.passwordView.translatesAutoresizingMaskIntoConstraints = false
        self.passwordFormElement?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.passwordFormElement!.rightAnchor.constraint(equalTo: self.passwordView.rightAnchor),
            self.passwordFormElement!.leftAnchor.constraint(equalTo: self.passwordView.leftAnchor),
            self.passwordFormElement!.topAnchor.constraint(equalTo: self.passwordView.topAnchor),
            self.passwordFormElement!.bottomAnchor.constraint(equalTo: self.passwordView.bottomAnchor),
            ])
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.loaderManager.showLoderView()
        let accountManager = AccountNetworkManager()
        let model = EmailModel(newLogin: self.newEmailFormElement?.getText(), password: self.passwordFormElement?.getText())
        if self.newEmailFormElement?.getText() != self.renewEmailFormElement?.getText() {
            self.loaderManager.hideLoaderView()
            let alertController = UIAlertController(title: "Changer votre e-mail", message: "Les deux adresses mails doivent êtres identiques", dismissActionTitle: "Fermer", dismissActionBlock: {
            })
            self.present(alertController!, animated: true, completion: nil)
        } else if !(self.newEmailFormElement?.getText().isValidEmail())! {
            self.loaderManager.hideLoaderView()
            let alertController = UIAlertController(title: "Changer votre e-mail", message: "Le format de l’email est incorrect", dismissActionTitle: "Fermer", dismissActionBlock: {
            })
            self.present(alertController!, animated: true, completion: nil)
        }
        else {
            accountManager.updateEmail(emailModel: model) { isSuccess in
                self.loaderManager.hideLoaderView()
                if isSuccess {
                    let alertController = UIAlertController(title: "Changer votre e-mail", message: "Votre e-mail a bien était changé", dismissActionTitle: "Fermer", dismissActionBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
                    self.present(alertController!, animated: true, completion: nil)
                    // ATInternet
                    ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kConfirmerModificationEmail , pageName: nil, chapter1: TaggingData.kYourProfile, chapter2: TaggingData.kPersonal, level2: TaggingData.kAccountLevel)
                } else {
                    let alertController = UIAlertController(title: "Changer votre e-mail", message: "Une erreure est survenue", dismissActionTitle: "Fermer", dismissActionBlock: {
                        self.dismiss(animated: true, completion: nil)
                    })
                    self.present(alertController!, animated: true, completion: nil)
                }
            }
        }
    }
    
}
