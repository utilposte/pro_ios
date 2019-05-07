//
//  MessageManager.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 10/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit
import UserNotifications
import IAdvizeConversationSDK

class MessageManager: NSObject {
    
    enum ReturnMode {
        case openMessage
        case showAlertError
        case showButtonError
    }
    
    #if DEBUG
    let iAdvizeApplicationID: String = "6010ae5a-c47e-4caf-9d3e-e6104ab9da7a"
    let iAdvizeSecret: String = "junA6HJwb4JhsKfP2DZ4ySdMr1WIWGnALL0FfNgS3M0="
    let uuidString: String = "ff403bf1-4c43-452c-bf94-0f9da96be619"
    #else
    let iAdvizeApplicationID: String = "be2bd1d7-a0b2-45aa-8926-b7d2cc162bd1"
    let iAdvizeSecret: String = "eTaFmbRm9yx0aem7Fph5LGlN8W3Vk9FrMbRVehA42g8="
    let uuidString: String = ""
    #endif

    
    static let shared: MessageManager = MessageManager()
    private var chatButton: ChatButton?
    private var containerView: UIViewController?
    
    override init() {
        super.init()
        self.setUpMessage()
        self.setUpUI()
        self.registerForPushNotifications()
    }
    /*
 */
    private func setUpMessage() {
        IAdvizeManager.shared.logLevel = .verbose
        IAdvizeManager.shared.registerApplicationId(iAdvizeApplicationID)
        IAdvizeConversationManager.shared.delegate = self
    }
    
    private func setUpUI() {
        chatButton = ChatButton.getChatButton(delegate: self)
        let message = "Bienvenue dans votre espace de Messagerie dans laquelle vous pouvez échanger avec un de nos conseillers du Service Clients Côté Pro sur une commande effectuée sur l’un de nos services.\nSachez que notre Service Clients est à votre disposition pour vous répondre du lundi au vendredi de 8h30 à 19h00 et le samedi de 8h30 à 13h00.\nVous pouvez accéder à la Politique de confidentialité et de protection des Données Personnelles du groupe La Poste: https://www.laposte.fr/politique-de-protection-des-donnees"
        var configuration = ConversationViewConfiguration()
        configuration.navigationBarBackgroundColor = UIColor.white
        configuration.mainColor = UIColor.lpDeepBlue
        configuration.navigationBarMainColor = UIColor.lpDeepBlue
        configuration.automaticMessage = message
        configuration.navigationBarTitle = "Parlez à votre conseiller"
        IAdvizeManager.shared.language = SDKLanguageOption.custom(value: .fr)
        IAdvizeConversationManager.shared.setupConversationView(configuration: configuration)
    }
    
    func addChatButton(_ containerView: UIViewController) {
        self.containerView = containerView
        chatButton?.translatesAutoresizingMaskIntoConstraints = false
        containerView.view.addSubview(chatButton!)
        // Prepare for animation
        chatButton?.containerViewLeadingConstraint = chatButton?.leadingAnchor.constraint(equalTo: containerView.view.leadingAnchor, constant: 20)
        chatButton?.resetLayout()
        NSLayoutConstraint.activate([
            (chatButton?.containerViewLeadingConstraint)!,
            (chatButton?.trailingAnchor.constraint(equalTo: containerView.view.trailingAnchor, constant: -20))!,
            (chatButton?.bottomAnchor.constraint(equalTo: containerView.view.bottomAnchor, constant: -20))!,
            (chatButton?.heightAnchor.constraint(equalToConstant: ChatButton.sizeView))!
            ])
    }
    
    func hideChatButton() {
        self.chatButton?.removeFromSuperview()
    }
    
    private func showErrorView() {
        if let messageView = TopMessageView.instanceFromNib() as? TopMessageView {
            messageView.setView(title: "Service indisponible.", message: "Veuillez réessayer ultérieurement.", type: .error)
//            To test when we integrate iAdvize in OrderViewController
//            let originY =  UIApplication.shared.statusBarFrame.size.height + (self.containerView?.navigationController?.navigationBar.frame.height ?? 0)
            messageView.showInView((self.containerView?.view)!, fromY: 0)
        }
    }
    
    func presentChatFromButton(_ isChatButton: Bool = false, callback:@escaping (Bool) -> ()) {
        let user = "\(UserAccount.shared.customerInfo?.lastName ?? "") - \(UserAccount.shared.customerInfo?.firstName ?? "") - \(UserAccount.shared.customerInfo?.customerId ?? "")"
        let userName = UserAccount.shared.customerInfo?.customerId ?? "anonymous iOS"
        IAdvizeManager.shared.registerUser(User(name: userName))
//        let userName = UserAccount.shared.customerInfo?.customerId ?? "anonymous iOS"
        let uuid: UUID = UUID(uuidString: self.uuidString) ?? UUID()
        IAdvizeManager.shared.activate(jwtOption: .secret(self.iAdvizeSecret), externalId: user, ruleId: uuid) { (success, isEnabled) in
            if success == true {
                self.containerView?.dismiss(animated: false, completion: {
                    IAdvizeConversationManager.shared.presentConversationViewModal()
                })
            } else {
                // Error
                if isChatButton == true {
                    // Animate Chat button
                    self.chatButton?.showError()
                } else {
                    // Show Other Error View
                    self.showErrorView()
                }
            }
            callback(success)
        }
    }
}

extension MessageManager : IAdvizeConversationManagerDelegate {
    func didUpdateUnreadMessagesCount(unreadMessagesCount: Int) {
        chatButton?.setNotification(badge: unreadMessagesCount)
        Logger.shared.verbose("unreadMessagesCount")
    }
    
    func didReceiveNewMessage(content: String) {
        // TODO ::
        Logger.shared.verbose("didReceiveNewMessage")
    }
}

extension MessageManager : ChatButtonDelegate {
    func didCallChat() {
        presentChatFromButton(true) { (success) in
            if success == false {
                // Get Status for Tag?
            }
        }
    }
}
extension MessageManager {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                Logger.shared.info("Permission granted: \(granted)")
        }
    }
    
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let pushToken = MessageManager.stringPushTokenFromData(deviceToken)
        // Register the Push Token to the iAdvize SDK.
        #if DEBUG
        IAdvizeManager.shared.registerPushToken(pushToken, applicationMode: .dev)
        #else
        IAdvizeManager.shared.registerPushToken(pushToken, applicationMode: .prod)
        #endif
    }
    
    func application(didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if IAdvizeManager.shared.isIAdvizePushNotification(with: userInfo) {
            Logger.shared.info("IAdvizeManager Receive: \(userInfo)")
            IAdvizeManager.shared.handlePushNotification(with: userInfo)
        }
    }
    
    private static func stringPushTokenFromData(_ deviceToken: Data) -> String {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for charCount in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[charCount]])
        }
        return tokenString
    }
}
