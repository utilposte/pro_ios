//
//  FirstPartViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 09/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedMCM
import MaterialComponents.MaterialTextFields
import UIKit

class FirstPartViewController: UIViewController {
    // IBOutlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var timeLineActiveStepIndicatorView: UIView!
    @IBOutlet var timeLineDashedView: UIView!
    @IBOutlet var timeLineDisabledStepIndicatorView: UIView!
    @IBOutlet var timeLineHeightConstraint: NSLayoutConstraint!
    
    // Variables
    let timelineView: UIView = UIView()
    let informationView: UIView = UIView()
    let titleIdentifier: UIView = UIView()
    let titleInformations: UIView = UIView()
    let genderView: UIView = UIView()
    var nextButton: UIButton = UIButton()
    let femaleCheckImage: UIImageView = UIImageView(image: UIImage(named: "small-check"))
    let maleCheckImage: UIImageView = UIImageView(image: UIImage(named: "small-check"))
    
    var maleView: UIView?
    var femaleView: UIView?
    
    var isMale = false
    var isFemale = false
    
    // FORM ELEMENT AND STRUCT
    var emailFormStruct: FormElementStruct?
    var emailFormElement: FormElementView?
    
    var passwordFormStruct: FormElementStruct?
    var passwordFormElement: FormElementView?
    
    var phoneFormElement: FormElementView?
    var phoneFormStruct: FormElementStruct?
    
    var firstnameFormElement: FormElementView?
    var firstnameFormStruct: FormElementStruct?
    
    var lastnameFormElement: FormElementView?
    var lastnameFormStruct: FormElementStruct?
    
    var emailFromConnection: String?
    var formType: FormType?
    
    var errorView = UIView()
    var emailExist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        
        if self.formType == .create {
            self.setupModalNavigationBar(title: "Création de compte", image: R.image.ic_close()!)
            self.setupTimeLine()
            self.setupInformationView()
            self.setupTitleIdentifier()
            self.setupIdentifierForm(formType: self.formType ?? .create)
            self.setupTitleInformations()
            self.setupGenderForm(formType: self.formType ?? .create)
            self.setupPersonnalForm(formType: self.formType ?? .create)
            self.setupNextStepButton()
            self.setupErrorView()
            self.setRgpdView()
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kIdentifiers,
                                                                 chapter1: TaggingData.kRegister,
                                                                 chapter2: nil,
                                                                 level2: TaggingData.kAccountLevel)
        } else {
            self.timeLineHeightConstraint.constant = 0
            self.setupInformationView()
            self.setupTitleInformations()
            self.setupGenderForm(formType: self.formType ?? .update)
            self.setupPersonnalForm(formType: self.formType ?? .update)
            self.setActiveNavigationBarButton()
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kEditInformations,
                                                                 chapter1: TaggingData.kYourProfile,
                                                                 chapter2: TaggingData.kPersonal,
                                                                 level2: TaggingData.kAccountLevel)
        }
    }
    
    func setupTimelineView() {
        let timelineLabel = UILabel()
        timelineLabel.text = "Timeline"
        timelineLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        timelineLabel.textAlignment = .center
        timelineLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timelineView.translatesAutoresizingMaskIntoConstraints = false
        self.timelineView.addSubview(timelineLabel)
        self.stackView.addArrangedSubview(self.timelineView)
        
        NSLayoutConstraint.activate([
            timelineLabel.topAnchor.constraint(equalTo: self.timelineView.topAnchor, constant: 10),
            timelineLabel.bottomAnchor.constraint(equalTo: self.timelineView.bottomAnchor, constant: -10),
            timelineLabel.leftAnchor.constraint(equalTo: self.timelineView.leftAnchor, constant: 30),
            timelineLabel.rightAnchor.constraint(equalTo: self.timelineView.rightAnchor, constant: -30),
            timelineLabel.centerXAnchor.constraint(equalTo: self.timelineView.centerXAnchor),
            timelineLabel.centerYAnchor.constraint(equalTo: self.timelineView.centerYAnchor),
        ])
    }
    
    func setupInformationView() {
        let titleLabel = UILabel()
        titleLabel.text = "Vos informations"
        titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        titleLabel.textColor = .lpDeepBlue
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Les champs suivis d'une * sont obligatoires"
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .lpGrey
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.informationView.translatesAutoresizingMaskIntoConstraints = false
        self.informationView.backgroundColor = .lpBackgroundGrey
        self.informationView.addSubview(titleLabel)
        self.informationView.addSubview(descriptionLabel)
        self.stackView.addArrangedSubview(self.informationView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.informationView.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.informationView.bottomAnchor, constant: -20),
        ])
    }
    
    func setupTitleIdentifier() {
        let titleLabel = UILabel()
        titleLabel.text = "Mes identifiants"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleIdentifier.translatesAutoresizingMaskIntoConstraints = false
        self.titleIdentifier.addSubview(titleLabel)
        self.stackView.addArrangedSubview(self.titleIdentifier)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.titleIdentifier.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.titleIdentifier.bottomAnchor, constant: -10),
            titleLabel.leftAnchor.constraint(equalTo: self.titleIdentifier.leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: self.titleIdentifier.rightAnchor, constant: -30),
            titleLabel.centerXAnchor.constraint(equalTo: self.titleIdentifier.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.titleIdentifier.centerYAnchor),
        ])
    }
    
    func setupTitleInformations() {
        let titleLabel = UILabel()
        titleLabel.text = "Mes informations"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleInformations.translatesAutoresizingMaskIntoConstraints = false
        self.titleInformations.addSubview(titleLabel)
        self.stackView.addArrangedSubview(self.titleInformations)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.titleInformations.topAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: self.titleInformations.bottomAnchor, constant: -10),
            titleLabel.leftAnchor.constraint(equalTo: self.titleInformations.leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: self.titleInformations.rightAnchor, constant: -30),
            titleLabel.centerXAnchor.constraint(equalTo: self.titleInformations.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.titleInformations.centerYAnchor),
        ])
    }
    
    func setupIdentifierForm(formType: FormType) {
        if self.formType == .create {
            self.emailFormStruct = FormElementStruct(placeholder: "Saisissez votre adresse e-mail", helperText: "", errorText: "Adresse e-mail non valide", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: self.emailFromConnection, shouldSeePassword: false, elementType: .email)
            
            self.emailFormElement = FormElementView(self.emailFormStruct!)
            self.emailFormElement?.delegate = self
            self.stackView.addArrangedSubview(self.emailFormElement!)
        } else if self.formType == .update {
            self.emailFormStruct = FormElementStruct(placeholder: "Saisissez votre adresse e-mail", helperText: "", errorText: "Adresse e-mail non valide", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.displayUid, shouldSeePassword: false, elementType: .email)
            
            self.emailFormElement = FormElementView(self.emailFormStruct!)
            self.emailFormElement?.delegate = self
            self.stackView.addArrangedSubview(self.emailFormElement!)
        }
        
        self.passwordFormStruct = FormElementStruct(placeholder: "Saisissez un mot de passe", helperText: "Saisissez au miminum 8 caractères dont \nau moins un chiffre et une lettre", errorText: "Veuillez remplir le champs", isRequired: true, isDisplayed: true, action: .none, isSecured: true, defaultValue: nil, shouldSeePassword: true, elementType: .none)
        
        self.passwordFormElement = FormElementView(self.passwordFormStruct!)
        self.passwordFormElement?.delegate = self
        self.passwordFormElement?.textfield?.addTarget(self, action: #selector(FirstPartViewController.checkPassword), for: UIControlEvents.editingChanged)
        self.stackView.addArrangedSubview(self.passwordFormElement!)
    }
    
    @objc func checkPassword() {
        if self.passwordFormElement?.getText().isValidPassword() == false {
            self.passwordFormElement?.setupErrorStyle(errorText: "Saisissez au miminum 8 caractères dont \nau moins un chiffre et une lettre")
        } else {
            self.passwordFormElement?.noErrorStyle()
        }
    }
    
    func setRgpdView() {
        // RGPD
        if let rgpdView = Bundle.main.loadNibNamed("RgpdView", owner: nil, options: nil)?.first as? RgpdView {
            rgpdView.setupText()
            stackView.addArrangedSubview(rgpdView)
        }
    }
    
    func setupGenderForm(formType: FormType) {
        let genderStackView: UIStackView = UIStackView()
        genderStackView.alignment = .fill
        genderStackView.distribution = .fillEqually
        genderStackView.spacing = 5
        genderStackView.axis = .horizontal
        genderStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.genderView.addSubview(genderStackView)
        
        // Male
        self.maleView = UIView()
        self.maleView?.backgroundColor = .white
        self.maleView?.translatesAutoresizingMaskIntoConstraints = false
        self.maleView?.addRadius(value: 5, color: UIColor.lpGrey.cgColor, width: 1)
        
        let maleButton: UIButton = UIButton()
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.addTarget(self, action: #selector(FirstPartViewController.maleButtonTapped), for: .touchUpInside)
        
        let maleLabel: UILabel = UILabel()
        maleLabel.translatesAutoresizingMaskIntoConstraints = false
        maleLabel.text = "M."
        maleLabel.textAlignment = .center
        
        self.maleCheckImage.translatesAutoresizingMaskIntoConstraints = false
        self.maleCheckImage.tintColor = .lpPurple
        self.maleCheckImage.isHidden = true
        
        self.maleView?.addSubview(self.maleCheckImage)
        self.maleView?.addSubview(maleButton)
        self.maleView?.addSubview(maleLabel)
        
        NSLayoutConstraint.activate([
            self.maleView!.heightAnchor.constraint(equalToConstant: 50),
            self.maleCheckImage.widthAnchor.constraint(equalToConstant: 10),
            self.maleCheckImage.heightAnchor.constraint(equalToConstant: 8),
            self.maleCheckImage.topAnchor.constraint(equalTo: self.maleView!.topAnchor, constant: 10),
            self.maleCheckImage.rightAnchor.constraint(equalTo: self.maleView!.rightAnchor, constant: -5),
            maleButton.topAnchor.constraint(equalTo: self.maleView!.topAnchor),
            maleButton.bottomAnchor.constraint(equalTo: self.maleView!.bottomAnchor),
            maleButton.leftAnchor.constraint(equalTo: self.maleView!.leftAnchor),
            maleButton.rightAnchor.constraint(equalTo: self.maleView!.rightAnchor),
            maleLabel.centerXAnchor.constraint(equalTo: self.maleView!.centerXAnchor),
            maleLabel.centerYAnchor.constraint(equalTo: self.maleView!.centerYAnchor),
            maleLabel.leftAnchor.constraint(equalTo: self.maleView!.leftAnchor, constant: 10),
            maleLabel.rightAnchor.constraint(equalTo: self.maleView!.rightAnchor, constant: -5),
        ])
        
        // Female
        self.femaleView = UIView()
        self.femaleView?.backgroundColor = .white
        self.femaleView?.translatesAutoresizingMaskIntoConstraints = false
        self.femaleView?.addRadius(value: 5, color: UIColor.lpGrey.cgColor, width: 1)
        
        let femaleButton: UIButton = UIButton()
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.addTarget(self, action: #selector(FirstPartViewController.femaleButtonTapped(sender:)), for: .touchUpInside)
        
        let femaleLabel: UILabel = UILabel()
        femaleLabel.translatesAutoresizingMaskIntoConstraints = false
        femaleLabel.text = "Mme"
        femaleLabel.textAlignment = .center
        
        self.femaleCheckImage.translatesAutoresizingMaskIntoConstraints = false
        self.femaleCheckImage.tintColor = .lpPurple
        self.femaleCheckImage.isHidden = true
        
        self.femaleView?.addSubview(self.femaleCheckImage)
        self.femaleView?.addSubview(femaleButton)
        self.femaleView?.addSubview(femaleLabel)
        
        genderStackView.addArrangedSubview(self.maleView!)
        genderStackView.addArrangedSubview(self.femaleView!)
        
        NSLayoutConstraint.activate([
            self.femaleView!.heightAnchor.constraint(equalToConstant: 50),
            self.femaleCheckImage.widthAnchor.constraint(equalToConstant: 10),
            self.femaleCheckImage.heightAnchor.constraint(equalToConstant: 8),
            self.femaleCheckImage.topAnchor.constraint(equalTo: self.femaleView!.topAnchor, constant: 10),
            self.femaleCheckImage.rightAnchor.constraint(equalTo: self.femaleView!.rightAnchor, constant: -10),
            femaleButton.topAnchor.constraint(equalTo: self.femaleView!.topAnchor),
            femaleButton.bottomAnchor.constraint(equalTo: self.femaleView!.bottomAnchor),
            femaleButton.leftAnchor.constraint(equalTo: self.femaleView!.leftAnchor),
            femaleButton.rightAnchor.constraint(equalTo: self.femaleView!.rightAnchor),
            femaleLabel.centerXAnchor.constraint(equalTo: self.femaleView!.centerXAnchor),
            femaleLabel.centerYAnchor.constraint(equalTo: self.femaleView!.centerYAnchor),
            femaleLabel.leftAnchor.constraint(equalTo: self.femaleView!.leftAnchor, constant: 10),
            femaleLabel.rightAnchor.constraint(equalTo: self.femaleView!.rightAnchor, constant: -10),
        ])
        
        self.genderView.addSubview(genderStackView)
        
        let genderLabel: UILabel = UILabel()
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.text = "Civilité*"
        genderLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        genderLabel.textColor = .gray
        self.genderView.addSubview(genderLabel)
        
        NSLayoutConstraint.activate([
            genderLabel.leftAnchor.constraint(equalTo: self.genderView.leftAnchor, constant: 20),
            genderLabel.rightAnchor.constraint(equalTo: self.genderView.rightAnchor, constant: -20),
            genderLabel.topAnchor.constraint(equalTo: self.genderView.topAnchor, constant: 10),
            genderStackView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            genderStackView.bottomAnchor.constraint(equalTo: self.genderView.bottomAnchor, constant: -10),
            genderStackView.leftAnchor.constraint(equalTo: self.genderView.leftAnchor, constant: 30),
            genderStackView.rightAnchor.constraint(equalTo: self.genderView.rightAnchor, constant: -30),
        ])
        
        if formType == .update {
            if let title = UserAccount.shared.customerInfo?.titleCode {
                if title.elementsEqual("mr") {
                    self.maleButtonTapped(sender: maleButton)
                } else {
                    self.femaleButtonTapped(sender: femaleButton)
                }
            }
        }
        
        self.stackView.addArrangedSubview(self.genderView)
    }
    
    @objc func femaleButtonTapped(sender: UIButton) {
        self.maleView?.layer.borderColor = UIColor.lpGrey.cgColor
        self.femaleView?.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 1, y: 1, blur: 5, spread: 1)
        self.femaleView?.layer.borderColor = UIColor.lpPurple.cgColor
        self.isMale = false
        self.isFemale = true
        self.updateCheckView()
        self.checkIfTextfieldEmpty()
    }
    
    @objc func maleButtonTapped(sender: UIButton) {
        self.femaleView?.layer.borderColor = UIColor.lpGrey.cgColor
        self.maleView?.layer.borderColor = UIColor.lpPurple.cgColor
        self.maleView?.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 1, y: 1, blur: 5, spread: 1)
        self.isMale = true
        self.isFemale = false
        self.updateCheckView()
        self.checkIfTextfieldEmpty()
    }
    
    func updateCheckView() {
        self.maleCheckImage.isHidden = !self.isMale
        self.femaleCheckImage.isHidden = !self.isFemale
    }
    
    private func setInactiveNavigationBarButton() {
        let valideBarButton = UIBarButtonItem(title: "Confirmer", style: .plain, target: self, action: nil)
        valideBarButton.tintColor = .lpGrey
        self.navigationItem.rightBarButtonItem = valideBarButton
    }
    
    private func setActiveNavigationBarButton() {
        let valideBarButton = UIBarButtonItem(title: "Confirmer", style: .plain, target: self, action: #selector(FirstPartViewController.updateForm))
        valideBarButton.tintColor = .lpPurple
        self.navigationItem.rightBarButtonItem = valideBarButton
    }
    
    @objc private func updateForm(acceptError: Bool = false) {
        let accountNetworkManager = AccountNetworkManager()
        var form = UserAccount.shared.userAccountToDataModel()
        form.firstName = firstnameFormElement?.getText()
        form.lastName = lastnameFormElement?.getText()
        form.telephone = phoneFormElement?.getText().replacingOccurrences(of: " ", with: "")
        form.titleCode = self.isMale ? "mr" : "mrs"
        let viewModel = CompanyInformationViewModel()
        viewModel.loaderManager.showLoderView()
        accountNetworkManager.updateCompanyInfo(acceptError: acceptError, userInfo: form) { errors in
            viewModel.loaderManager.hideLoaderView()
            if errors == nil {
                self.navigationController?.popViewController(animated: true)
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kConfirmerModificationInformations,
                                                                      pageName: nil, chapter1: TaggingData.kYourProfile,
                                                                      chapter2: TaggingData.kPersonal,
                                                                      level2: TaggingData.kAccountLevel)
                
            } else {
                self.showError(formData: form, errors: errors!)
            }
        }
    }
    
    func showError(formData: UpdateFormModel, errors: [AccountNetworkError]) {
        var canAcceptError = true
        var showDefaultError = true
        
        var popinString = ""
        for tmpError in errors {
            if tmpError.canSubscribe == false {
                canAcceptError = false
            } else {
                popinString = popinString + "• " + (tmpError.message ?? "") + "\n"
            }
            
            switch tmpError.type {
            case .firstName:
                showDefaultError = false
                self.firstnameFormElement?.setupErrorStyle(errorText: tmpError.message ?? "")
            //            case .siret:
            //                showDefaultError = false
            //                self.companySiretField.setupErrorStyle(errorText: tmpError.message ?? "")
            //            case .tvaIntra:
            //                showDefaultError = false
            //                self.tvaField.setupErrorStyle(errorText: tmpError.message ?? "")
            default:
                break
            }
        }
        
        if canAcceptError {
            popinString = popinString + "\n\n Souhaitez-vous malgré tout modifier votre compte ?"
            let alert = UIAlertController(title: nil, message: popinString, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Non", style: .destructive, handler: { _ in })
            let alertAction = UIAlertAction(title: "Oui", style: .default, handler: { _ in
                self.updateForm(acceptError: true)
            })
            alert.addAction(cancelAction)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else if showDefaultError {
            let alert = UIAlertController(title: "Erreur", message: "Une erreur est survenue : Erreur Inconnu", dismissActionTitle: "OK", dismissActionBlock: {})
            self.present(alert!, animated: true, completion: nil)
        }
    }
    
    func setupPersonnalForm(formType: FormType) {
        if self.formType == .create {
            self.lastnameFormStruct = FormElementStruct(placeholder: "Saisissez votre nom", helperText: "", errorText: "Veuillez remplir le champs", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
            
            self.lastnameFormElement = FormElementView(self.lastnameFormStruct!)
            self.lastnameFormElement?.delegate = self
            self.stackView.addArrangedSubview(self.lastnameFormElement!)
        } else if self.formType == .update {
            self.lastnameFormStruct = FormElementStruct(placeholder: "Saisissez votre nom", helperText: "", errorText: "Veuillez remplir le champs", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.lastName, shouldSeePassword: false, elementType: .none)
            
            self.lastnameFormElement = FormElementView(self.lastnameFormStruct!)
            self.lastnameFormElement?.delegate = self
            self.stackView.addArrangedSubview(self.lastnameFormElement!)
        }
        
        if self.formType == .create {
            self.firstnameFormStruct = FormElementStruct(placeholder: "Saisissez votre prénom", helperText: "", errorText: "Veuillez remplir le champs", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
            
            self.firstnameFormElement = FormElementView(self.firstnameFormStruct!)
            self.firstnameFormElement?.delegate = self
            self.stackView.addArrangedSubview(self.firstnameFormElement!)
        } else if self.formType == .update {
            self.firstnameFormStruct = FormElementStruct(placeholder: "Saisissez votre prénom", helperText: "", errorText: "Veuillez remplir le champs", isRequired: true, isDisplayed: true, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.firstName, shouldSeePassword: false, elementType: .none)
            
            self.firstnameFormElement = FormElementView(self.firstnameFormStruct!)
            self.firstnameFormElement?.delegate = self
            self.stackView.addArrangedSubview(self.firstnameFormElement!)
        }
        
        if self.formType == .create {
            self.phoneFormStruct = FormElementStruct(placeholder: "Saisissez votre numéro de téléphone", helperText: "", errorText: "", isRequired: false, isDisplayed: true, action: .none, isSecured: false, defaultValue: nil, shouldSeePassword: false, elementType: .none)
            
            self.phoneFormElement = FormElementView(self.phoneFormStruct!)
            self.phoneFormElement?.textfield?.keyboardType = .numberPad
            self.phoneFormElement?.delegate = self
            self.phoneFormElement?.textfield?.delegate = self
            self.phoneFormElement?.textfield?.keyboardType = .phonePad
            self.stackView.addArrangedSubview(self.phoneFormElement!)
        } else if self.formType == .update {
            self.phoneFormStruct = FormElementStruct(placeholder: "Saisissez votre numéro de téléphone", helperText: "", errorText: "", isRequired: false, isDisplayed: true, action: .none, isSecured: false, defaultValue: UserAccount.shared.customerInfo?.phone, shouldSeePassword: false, elementType: .none)
            
            self.phoneFormElement = FormElementView(self.phoneFormStruct!)
            self.phoneFormElement?.textfield?.keyboardType = .numberPad
            self.phoneFormElement?.delegate = self
            self.phoneFormElement?.textfield?.delegate = self
            self.phoneFormElement?.textfield?.keyboardType = .phonePad
            self.stackView.addArrangedSubview(self.phoneFormElement!)
        }
    }
    
    func setupNextStepButton() {
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextButton.setTitle("Etape suivante", for: .normal)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = .lpPurple
        self.nextButton.addTarget(self, action: #selector(FirstPartViewController.nextStepButtonTapped), for: .touchUpInside)
        
        buttonView.addSubview(self.nextButton)
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.widthAnchor.constraint(equalToConstant: 150),
            nextButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 20),
            nextButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -20),
            nextButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
        ])
        
        self.nextButton.layer.cornerRadius = 20
        
        self.nextButton.isEnabled = false
        self.nextButton.backgroundColor = .lpGrey
        
        self.stackView.addArrangedSubview(buttonView)
    }
    
    func setupErrorView() {
        self.errorView.alpha = 0.0
        self.errorView.backgroundColor = UIColor.lpPink
        self.view.addSubview(self.errorView)
        self.errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.errorView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 44),
            self.errorView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.errorView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.errorView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        let imageError = UIImageView()
        imageError.image = UIImage(named: "warning")
        self.errorView.addSubview(imageError)
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.hideErrorView))
        imageError.isUserInteractionEnabled = true
        imageError.addGestureRecognizer(gestureRecogniser)
        
        imageError.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageError.centerYAnchor.constraint(equalTo: self.errorView.centerYAnchor, constant: 10),
            imageError.leftAnchor.constraint(equalTo: self.errorView.leftAnchor, constant: 20),
            imageError.widthAnchor.constraint(equalToConstant: 25),
            imageError.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        let labelError = UILabel()
        labelError.numberOfLines = 0
        labelError.text = "L'email renseigné est déjà utilisé"
        labelError.font = UIFont.systemFont(ofSize: 15)
        self.errorView.addSubview(labelError)
        
        labelError.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelError.topAnchor.constraint(equalTo: self.errorView.topAnchor, constant: 10),
            labelError.leftAnchor.constraint(equalTo: imageError.rightAnchor, constant: 10),
            labelError.rightAnchor.constraint(equalTo: self.errorView.rightAnchor, constant: 20),
            labelError.bottomAnchor.constraint(equalTo: self.errorView.bottomAnchor, constant: 10),
        ])
    }
    
    @objc func nextStepButtonTapped() {
        self.handleSubmittedForm()
    }
    
    @objc func hideErrorView() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.errorView.alpha = 0.0
        }) { _ in
        }
    }
    
    func handleSubmittedForm() {
        var isValid = true
        var dataForm = UpdateFormModel()
        
        if self.emailFormElement?.textfield?.text?.isEmpty == false {
            if self.emailFormElement?.textfield?.text?.isValidEmail() == false {
                self.emailFormElement?.setupErrorStyle(errorText: "Adresse E-mail Invalide")
                isValid = false
            } else {
                self.emailFormElement?.noErrorStyle()
                dataForm.email = self.emailFormElement?.getText()
            }
        } else {
            self.emailFormElement?.setupErrorStyle(errorText: "Veuillez remplir ce champs")
            isValid = false
        }
        
        if self.passwordFormElement?.textfield?.text?.isEmpty == true {
            self.passwordFormElement?.setupErrorStyle(errorText: "Veuillez remplir ce champs")
            isValid = false
        } else {
            self.passwordFormElement?.noErrorStyle()
            dataForm.pwd = self.passwordFormElement?.getText()
        }
        
        if self.isMale == false, self.isFemale == false {
            let alertController = UIAlertController(title: "Informations manquantes", message: "Merci de renseigner votre civilité", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Fermer", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            self.scrollView.scrollRectToVisible(self.genderView.frame, animated: true)
        } else {
            dataForm.titleCode = self.isMale ? "mr" : "mrs"
        }
        
        if self.firstnameFormElement?.textfield?.text?.isEmpty == true {
            self.firstnameFormElement?.setupErrorStyle(errorText: "Veuillez remplir ce champs")
            isValid = false
        } else {
            self.firstnameFormElement?.noErrorStyle()
            dataForm.firstName = self.firstnameFormElement?.getText().tmpChangeSpecialCharacters()
        }
        
        if self.lastnameFormElement?.textfield?.text?.isEmpty == true {
            self.lastnameFormElement?.setupErrorStyle(errorText: "Veuillez remplir ce champs")
            isValid = false
        } else {
            self.lastnameFormElement?.noErrorStyle()
            dataForm.lastName = self.lastnameFormElement?.getText().tmpChangeSpecialCharacters()
        }
        
        // TODOs: Method check form validation
        let phoneNumber = self.phoneFormElement?.getText().replacingOccurrences(of: " ", with: "") ?? ""
        if phoneNumber.isEmpty {
            self.phoneFormElement?.noErrorStyle()
            dataForm.telephone = ""
        } else if phoneNumber.isValidPhoneNumber() {
            self.phoneFormElement?.noErrorStyle()
            dataForm.telephone = phoneNumber
        } else {
            self.phoneFormElement?.setupErrorStyle(errorText: "Votre saisie est incorrecte")
            isValid = false
        }
        
        if isValid {
            guard let companyInformation = R.storyboard.account.companyInformationViewControllerID() else { return }
            companyInformation.formType = .create
            companyInformation.dataForm = dataForm
            
            self.navigationController?.pushViewController(companyInformation, animated: true)
        }
    }
    
    func checkIfTextfieldEmpty() {
        if self.emailFormElement?.textfield?.text?.isEmpty == true || self.passwordFormElement?.textfield?.text?.isEmpty == true || self.firstnameFormElement?.textfield?.text?.isEmpty == true || self.lastnameFormElement?.textfield?.text?.isEmpty == true || (self.isMale == false && self.isFemale == false) || self.passwordFormElement?.textfield?.text?.isValidPassword() == false || self.emailExist {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .lpGrey
        } else {
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = .lpPurple
        }
    }
    
    private func setupTimeLine() {
        self.drawDottedLine(start: CGPoint(x: self.timeLineDashedView.bounds.minX, y: self.timeLineDashedView.bounds.minY + 1),
                            end: CGPoint(x: self.timeLineDashedView.bounds.maxX, y: self.timeLineDashedView.bounds.minY + 1),
                            view: self.timeLineDashedView)
        self.timeLineActiveStepIndicatorView.backgroundColor = .lpPurple
        self.timeLineActiveStepIndicatorView.layer.borderColor = UIColor.lpPurple.cgColor
        self.timeLineActiveStepIndicatorView.layer.borderWidth = 2
        self.timeLineActiveStepIndicatorView.cornerRadius = self.timeLineActiveStepIndicatorView.bounds.width / 2
        
        self.timeLineDisabledStepIndicatorView.layer.borderColor = UIColor.lpGrayShadow.cgColor
        self.timeLineDisabledStepIndicatorView.layer.borderWidth = 2
        self.timeLineDisabledStepIndicatorView.cornerRadius = self.timeLineActiveStepIndicatorView.bounds.width / 2
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lpGrayShadow.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [4, 2] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
}

extension FirstPartViewController: FormElementViewDelegate {
    func textFieldDidEndEditing(textfield: UITextField, textType: FormElementInputTextType) {
        if textType == .email, let text = textfield.text, !text.isEmpty {
            let viewModel = CompanyInformationViewModel()
            viewModel.loaderManager.showLoderView()
            viewModel.checkEmailAddress(text) { showError in
                viewModel.loaderManager.hideLoaderView()
                if showError {
                    self.emailFormElement?.setupErrorStyle(errorText: "")
                    self.emailExist = true
                    UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                        self.errorView.alpha = 1.0
                    }) { _ in
                    }
                } else {
                    self.emailFormElement?.noErrorStyle()
                    self.emailExist = false
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        self.errorView.alpha = 0.0
                    }) { _ in
                    }
                }
                self.checkIfTextfieldEmpty()
            }
        }
        self.checkIfTextfieldEmpty()
    }
    
    func textfieldDidTapped(textfield: MDCTextField, action: FormElementDataPicker) {}
}

extension FirstPartViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let phoneNumber = textField.text!
        if !phoneNumber.isEmpty {
            let formattedPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            textField.text = formattedPhoneNumber
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let phoneNumber = textField.text
        let formattedPhoneNumber = phoneNumber?.inserting(separator: " ", every: 2)
        textField.text = formattedPhoneNumber
    }
}
