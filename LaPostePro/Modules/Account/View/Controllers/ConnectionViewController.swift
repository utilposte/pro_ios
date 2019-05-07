//
//  ConnectionViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 02/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import KeychainSwift
import MaterialComponents.MaterialTextFields

class ConnectionViewController: UIViewController {
    //PROPRETIES
    let connectionViewModel = ConnectionViewModel()
    let keychain = KeychainSwift()
    var hiddenPassword : Bool!
    var emailFieldController: MDCTextInputControllerFilled?
    var passwordFieldController: MDCTextInputControllerFilled?
    var expectedSize: CGSize!
    var rgpdView: RgpdView!
    var emailElement: FormElementView!
    var passwordElement: FormElementView!
    var buttonsView: ConnexionButtons!
    var errorView = UIView()
    lazy var loaderManager = LoaderViewManager()
    //OUTLETS
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kHomeNotConnected,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kHomeLevel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupErrorView()
        checkInitData()
        
        if let header = Bundle.main.loadNibNamed("ConnexionHeader", owner: nil, options: nil)?.first as? ConnexionHeader {
            stackView.addArrangedSubview(header)
        }
        
        //add white space
        stackView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 130)))
        
        let emailStruct = FormElementStruct.init(placeholder: "Saisissez votre adresse email", helperText: nil, errorText: nil, isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .email)
        emailElement = FormElementView.init(emailStruct)
        emailElement.delegate = self
        emailElement.textfield?.tag = 0
        emailElement.textfield?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailElement.textfield?.delegate = self
        emailElement.textfield?.autocorrectionType = .no
        stackView.addArrangedSubview(emailElement)
        
        let passwordStruct = FormElementStruct.init(placeholder: "Saisissez votre mot de passe", helperText: "", errorText: "", isRequired: true, isDisplayed: true, action: .none, isSecured: true, defaultValue: nil, shouldSeePassword: true, elementType: .none)
        passwordElement = FormElementView(passwordStruct)
        passwordElement.textfield?.returnKeyType = .done
        passwordElement.delegate = self
        passwordElement.textfield?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordElement.textfield?.delegate = self
        passwordElement.textfield?.tag = 1
        stackView.addArrangedSubview(passwordElement)
        
        if let buttonsView = Bundle.main.loadNibNamed("ConnexionButtons", owner: nil, options: nil)?.first as? ConnexionButtons {
            self.buttonsView = buttonsView
            buttonsView.delegate = self
            stackView.addArrangedSubview(buttonsView)
        }
        
        //RGPD
        if let rgpdView = Bundle.main.loadNibNamed("RgpdView", owner: nil, options: nil)?.first as? RgpdView {
            rgpdView.setupText()
            stackView.addArrangedSubview(rgpdView)
        }
        
        let versionlabel : UILabel = self.getversionLabel()
        stackView.addArrangedSubview(versionlabel)
    }
    
    func getversionLabel() -> UILabel {
        let versionlabel : UILabel = UILabel(frame : CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        versionlabel.textColor = UIColor.gray
        versionlabel.textAlignment = NSTextAlignment.center
        versionlabel.font = UIFont(size: 12)
        versionlabel.text = AppDelegate.getVersionString()
        return versionlabel
    }
    
    func checkInitData() {
        self.loaderManager.showLoderView()
        connectionViewModel.initData() { (success) in
            self.loaderManager.hideLoaderView()
            if success == false {
                let deleteAlert = UIAlertController(title: "Erreur de connexion", message: "Nous n'avons pas pu charger les éléments nécessaires au bon fonctionnement de l'application. Voulez-vous réessayer?", preferredStyle: UIAlertControllerStyle.alert)
                
                deleteAlert.addAction(UIAlertAction(title: "Réessayer", style: .default, handler: { (action: UIAlertAction!) in
                    self.checkInitData()
                }))
                self.present(deleteAlert, animated: true, completion: nil)
            }
        }
    }
}

extension ConnectionViewController: FormElementViewDelegate, UITextFieldDelegate {
    func textFieldDidEndEditing(textfield: UITextField, textType: FormElementInputTextType) {
        let isValidEmail = (emailElement.getText().isValidEmail())
        if (emailElement.getText().isEmpty) || !isValidEmail || (passwordElement.getText().isEmpty) {
            buttonsView.connexionButton.isEnabled = false
            buttonsView.connexionButton.backgroundColor = .lightGray
            if !isValidEmail {
                self.showErrorViewWith("Le format de l'email n’est pas conforme.")
            }
        } else {
            buttonsView.connexionButton.isEnabled = true
            buttonsView.connexionButton.backgroundColor = .lpPurple
        }
    }
    
    func textfieldDidTapped(textfield: MDCTextField, action: FormElementDataPicker) {
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (emailElement.getText().isEmpty) || !(emailElement.getText().isValidEmail()) || (passwordElement.getText().isEmpty) || !(passwordElement.getText().isValidPassword()) {
            buttonsView.connexionButton.isEnabled = false
            buttonsView.connexionButton.backgroundColor = .lightGray
        } else {
            buttonsView.connexionButton.isEnabled = true
            buttonsView.connexionButton.backgroundColor = .lpPurple
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailElement.textfield {
            passwordElement.textfield?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonsView.connexionButton.isEnabled = false
        buttonsView.connexionButton.backgroundColor = .lightGray
        return true
    }
}

extension ConnectionViewController: ConnexionButtonsDelegate {
    func forgotPassword() {
        let viewController = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ForgottenPasswordViewControllerID") as! ForgottenPasswordViewController
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kMdpOublie , pageName: TaggingData.kHomeNotConnected, chapter1: nil, chapter2: nil, level2: TaggingData.kHomeLevel)
        
    }
    
    func connexion() {
        self.loaderManager.showLoderView()
        connectionViewModel.connect(with: self.emailElement.getText(), password: self.passwordElement.getText(), onCompletion:{ (isConnected) in
            self.loaderManager.hideLoaderView()
            if isConnected == .connected {
                UIApplication.shared.shortcutItems = Constants.shortcuts
                // Reset Home Frandole's data
                FrandoleViewModel.sharedInstance.list = [Frandole]()
                self.gotoHome()
                // Accengage
                AccengageTaggingManager().trackCustomer(id: self.emailElement.getText())
            } else {
                self.showErrorViewWith(isConnected.message)
                self.emailElement.setupErrorStyle(errorText: "")
                self.passwordElement.setupErrorStyle(errorText: "")
            }
        })
    }
    
    func showErrorViewWith(_ text : String) {
        if let label = self.errorView.viewWithTag(99) as? UILabel {
            label.text = text
        }
        self.errorView.isHidden = false
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
            self.errorView.isHidden = true
        })
    }
    
    func setupErrorView() {
        self.errorView.isHidden = true
        self.errorView.backgroundColor = UIColor.lpPink
        self.view.addSubview(self.errorView)
        
        self.errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.errorView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.errorView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.errorView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.errorView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let imageError = UIImageView()
        imageError.image = UIImage(named: "warning")
        self.errorView.addSubview(imageError)
        
        imageError.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageError.centerYAnchor.constraint(equalTo: self.errorView.centerYAnchor, constant: 10),
            imageError.leftAnchor.constraint(equalTo: self.errorView.leftAnchor, constant: 20),
            imageError.widthAnchor.constraint(equalToConstant: 25),
            imageError.heightAnchor.constraint(equalToConstant: 25),
            ])
        
        let labelError = UILabel()
        labelError.tag = 99
        labelError.numberOfLines = 0
        labelError.text = "L’identifiant et/ou le mot de passe saisi sont incorrects"
        labelError.font = UIFont.systemFont(ofSize: 15)
        self.errorView.addSubview(labelError)
        
        labelError.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelError.topAnchor.constraint(equalTo: imageError.topAnchor, constant: 0),
            labelError.leftAnchor.constraint(equalTo: imageError.rightAnchor, constant: 10),
            labelError.rightAnchor.constraint(equalTo: self.errorView.rightAnchor, constant: -20),
            labelError.bottomAnchor.constraint(lessThanOrEqualTo: self.errorView.bottomAnchor, constant: -10),
            ])
    }

    
    func register() {
        guard let inscriptionViewController = R.storyboard.account.firstPartViewControllerID() else {
            return
        }
        if self.emailElement.getText().isEmpty == false {
            inscriptionViewController.emailFromConnection = self.emailElement.getText()
        }
        inscriptionViewController.formType = .create
        let navigationController = UINavigationController(rootViewController: inscriptionViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
