//  AppDelegate.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 30/04/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Accengage
import Firebase
import IQKeyboardManagerSwift
import LPColissimo
import LPSharedMCM
import UIKit
import RealmSwift

let scheme = "laposte_apppro"

let statusBarTappedNotification = Notification(name: Notification.Name(rawValue: "statusBarTappedNotification"))

enum Route {
    case cart
    case orders
    case tab(TabBarItem)
    
    init?(url: URL) {
        switch url.absoluteString {
        case "\(scheme)://tab1": self = .tab(.eBoutique)
        case "\(scheme)://tab2": self = .tab(.locator)
        case "\(scheme)://modal": self = .cart
        default: return nil
        }
    }
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        case "EBoutique": self = .tab(.eBoutique)
        case "Location": self = .tab(.locator)
        case "Orders": self = .orders
        case "Cart": self = .cart
        default: return nil
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // Dans la fonction "setUpDefaultAppHeader" ajouter le code suivant pour test de la MEP
    //
    //    UnComment Before MEP
    //    [_restManager.requestSerializer setValue:@"BOUTIQUE=pstfru-hybrisfront01-prod" forHTTPHeaderField:@"Cookie"];
    
    var window: UIWindow?
    var launchedRoute: Route?
    
    // MARK: ONLY FOR DEBUG used to show alert one time when no configuration app installed
    
    var alertShowed = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Logger.shared.verbose("Here is where the magic starts!")

        // MARK: set module url
        EnvironmentUrlsManager.sharedManager.setMCMDelegate()
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        do {
            if let folderPath = Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent().path {
                try FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication], ofItemAtPath: folderPath)
            }
            _ = try Realm()
        } catch let error {
            Logger.shared.debug("Realm Open Failed. Deleting all the realm related files. Error : \(error)")
        }
        // MARK: configure firebase
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        // AppDynamics
        self.setUpAppDynamics()
        // Accengage
        self.configureAccengage()
        // Adjust
        AdjustTaggingManager.initSharedInstanceWith(appId: EnvironmentUrlsManager.sharedManager.getAdjustEnvironment())
        AdjustTaggingManager.sharedManager.applicationDidFinishLaunchingWith(token: AdjustTaggingManager.kLaunchAppToken)
        // Paypal
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: EnvironmentUrlsManager.sharedManager.getPayPalProdEnvironment(), PayPalEnvironmentSandbox: EnvironmentUrlsManager.sharedManager.getPayPalDevEnvironment()]) // ( Sandbox : api1 )
        // Colissimo
        ColissimoAPIClient.sharedInstance.baseUrl = EnvironmentUrlsManager.sharedManager.getHybrisServiceHost()
        
        // Setting the Appropriate initialViewController
        let keychainService = KeychainService()
        // SetUserInfo in exists
        let email = keychainService.get(key: keychainService.emailkey)
        let accessToken = keychainService.get(key: keychainService.accessTokenkey)
        let expiresIn = keychainService.get(key: keychainService.expiresInkey)
        let refreshToken = keychainService.get(key: keychainService.refreshTokenkey)
        let tokenType = keychainService.get(key: keychainService.tokenTypekey)
        if let _email = email, let _accessToken = accessToken, let _expiresIn = expiresIn, let _refreshToken = refreshToken, let _tokenType = tokenType {
            ConnectionViewModel.setMCMUserCredential(email: _email, accessToken: _accessToken, expiresIn: _expiresIn, refreshToken: _refreshToken, tokenType: _tokenType)
            if keychainService.isValidToken() == .valid {
                RefreshTokenManager.shared.getUserInfo { customerInfo, _ in
                    if let _customerInfo = customerInfo {
                        UserAccount.shared.customerInfo = _customerInfo
                        ConnectionViewModel.setMCMUserCredential(email: _customerInfo.displayUid ?? _email, accessToken: _accessToken, expiresIn: _expiresIn, refreshToken: _refreshToken, tokenType: _tokenType)
                    }
                }
            }
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        let url = launchOptions?[.url] as? URL
        let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem
        if url != nil || shortcutItem != nil {
            // It uses force unwrap but the if before checks that at least one variable is not nil
            guard let route = url != nil ? Route(url: url!) : Route(shortcutItem: shortcutItem!) else { return false }
            self.launchedRoute = route
        }
        return true
    }
    
    open func addShortcut(application: UIApplication) {
        application.shortcutItems = Constants.shortcuts
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let route = Route(shortcutItem: shortcutItem) else {
            completionHandler(false)
            return
        }
        completionHandler(self.handle(route: route))
    }
    
    func handle(route: Route) -> Bool {
        if let tabController = window?.rootViewController as? MainTabBarViewController {
            switch route {
            case .tab(let tab): tabController.showTab(tab)
            case .cart: tabController.pushCart()
            case .orders: tabController.pushOrders()
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkUserStatus(application)
        // launch Route after app is active
        if let route = launchedRoute {
            _ = self.handle(route: route)
            self.launchedRoute = nil
        }
    }
    
    func checkUserStatus(_ application: UIApplication) {
        let keychainService = KeychainService()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            keychainService.deleteUserCredentials()
            keychainService.deleteTokens()
        }
        let email = keychainService.get(key: keychainService.emailkey)
        let accessToken = keychainService.get(key: keychainService.accessTokenkey)
        let expiresIn = keychainService.get(key: keychainService.expiresInkey)
        let refreshToken = keychainService.get(key: keychainService.refreshTokenkey)
        let tokenType = keychainService.get(key: keychainService.tokenTypekey)
        guard let _email = email, let _accessToken = accessToken, let _expiresIn = expiresIn, let _refreshToken = refreshToken, let _tokenType = tokenType else {
            keychainService.deleteTokens()
            self.showFirstScreen(launchedBefore: launchedBefore)
            return
        }
        
        ConnectionViewModel.setMCMUserCredential(email: _email, accessToken: _accessToken, expiresIn: _expiresIn, refreshToken: _refreshToken, tokenType: _tokenType)
        switch keychainService.isValidToken() {
        case .valid:
            RefreshTokenManager.shared.getUserInfo { customerInfo, _ in
                if let _customerInfo = customerInfo {
                    UserAccount.shared.customerInfo = _customerInfo
                    ConnectionViewModel.setMCMUserCredential(email: _customerInfo.displayUid ?? "", accessToken: _accessToken, expiresIn: _expiresIn, refreshToken: _refreshToken, tokenType: _tokenType)
                } else {
                    self.needToCallConnectionView()
                }
            }
            
        case .expired:
            let refreshToken = keychainService.get(key: keychainService.refreshTokenkey) ?? ""
            RefreshTokenManager.shared.appDidRefreshToken(refreshToken: refreshToken) { success in
                if success {
                    self.addShortcut(application: application)
                    let favoriteViewModel = FavoriteViewModel()
                    favoriteViewModel.getProductWishlist(completion: { _ in })
                } else {
                    self.needToCallConnectionView()
                }
            }
        case .notExist:
            self.showFirstScreen(launchedBefore: launchedBefore)
        }
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setUpAppDynamics() {
        #if DEBUG
            ADEumInstrumentation.initWithKey("AD-AAB-AAM-MDR")
        #else
            ADEumInstrumentation.initWithKey("AD-AAB-AAM-MCN")
        #endif
    }
    
    func showAlertFromAppDelegate(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, dismissActionTitle: "OK", dismissActionBlock: {
            self.alertShowed = false
            return
        })
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 0.8
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert!, animated: true, completion: {})
    }
    
    private func getTopViewController() -> UIViewController {
        return UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
    }
    
    private func getHomeViewController() -> HomeViewController? {
        if let tabbar = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController, let homeNavigationViewController = tabbar.viewControllers?.first as? UINavigationController, let homeViewController = homeNavigationViewController.viewControllers.first as? HomeViewController {
            return homeViewController
        }
        return nil
    }
    
    func needToCallConnectionView() {
        let keychainService = KeychainService()
        if let email = keychainService.get(key: keychainService.emailkey), let password = keychainService.get(key: keychainService.passwordkey) {
            ConnectionViewModel().connect(with: email, password: password) { (returnType) in
                if returnType == .connected {
                    if let homeViewController = self.getHomeViewController() {
                        homeViewController.refreshDataForConnectedUser()
                    }
                } else {
                    self.openConnectionViewWhenDisconnected()
                }
            }
        } else {
            self.openConnectionViewWhenDisconnected()
        }
    }
    
    func openConnectionViewWhenDisconnected() {
        KeychainService().deleteTokens()
        let viewController = R.storyboard.account.connectionViewControllerID()!
        self.getTopViewController().present(viewController, animated: true, completion: {
            self.showAlertFromAppDelegate(title: "", message: "Vous avez été déconnecté, suite à une session trop longue.\nMerci de vous reconnecter pour accéder à votre compte PRO.")
        })
    }
    
    func showFirstScreen(launchedBefore: Bool) {
        var viewController: UIViewController
        if launchedBefore {
            viewController = R.storyboard.account.connectionViewControllerID()!
        } else {
            viewController = R.storyboard.account.onBoardingViewControllerID()!
        }
        self.getTopViewController().present(viewController, animated: false, completion: { })
    }
    
    // MARK: Accengage Methods
    func configureAccengage() {
        // Start Accengage
        let config = ACCConfiguration.defaultConfig()
        config.appId = EnvironmentUrlsManager.sharedManager.getAccengagePatnerId()
        config.appPrivateKey = EnvironmentUrlsManager.sharedManager.getAccengagePrivateKey()
        Accengage.start(withConfig: config, optIn: ACCOptIn.enabled)
        Accengage.setLoggingEnabled(true)
        // Register for notification
        Accengage.push()?.registerForUserNotifications(options: [.sound, .badge, .alert, .carPlay])
        // Set up the UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        // TODO: move later
//         Accengage.setDataOptInEnabled(true)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Accengage.push()?.didRegisterForUserNotifications(withDeviceToken: deviceToken)
//        MessageManager.shared.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Accengage.push()?.didReceiveRemoteNotification(userInfo)
//        MessageManager.shared.application(didReceiveRemoteNotification: userInfo)
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        Accengage.push()?.handleAction(withIdentifier: identifier!, forRemoteNotification: userInfo)
        completionHandler()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        
        Accengage.push()?.handleAction(withIdentifier: identifier!, forRemoteNotification: userInfo)
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        Accengage.push()?.didReceive(notification)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        Accengage.push()?.handleAction(withIdentifier: identifier, for: notification)
        completionHandler()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        Accengage.push()?.handleAction(withIdentifier: identifier, for: notification)
        completionHandler()
    }
    
    // UNUserNotificationCenterDelegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void) {
        completionHandler((Accengage.push()?.willPresent(notification))!)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Accengage.push()?.didReceive(response)
        completionHandler()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let statusBarRect = UIApplication.shared.statusBarFrame
        guard let touchPoint = event?.allTouches?.first?.location(in: self.window) else { return }
        
        if statusBarRect.contains(touchPoint) {
            NotificationCenter.default.post(statusBarTappedNotification)
        }
    }
    
    public class func getVersionString() -> String {
        var version : String = ""
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        #if DEBUG
        let platform = EnvironmentUrlsManager.sharedManager.getHybrisServiceHost()
        let buildVersion =  Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        version = "v\(appVersion ?? "") - build \(buildVersion ?? "") - \(platform)"
        #else
        version = "v\(appVersion ?? "")"
        #endif
        return version
    }
}
