//
//  ChatButton.swift
//  ChatButton
//
//  Created by Issam DAHECH on 15/04/2019.
//  Copyright © 2019 LaPoste. All rights reserved.
//

import UIKit

protocol ChatButtonDelegate : class {
    func didCallChat()
}

class ChatButton: UIView {
    // MARK: - Variables
    // @IBOutlet
    @IBOutlet weak private var button: UIButton?
    @IBOutlet weak private var errorView: UIView?
    @IBOutlet weak private var closeButton: UIButton!
    // @IBOutlet Constraints (For Animation)
    @IBOutlet private var chatButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var errorViewLeadingConstraint: NSLayoutConstraint!
    // Custom Views
    private var popNotification: UIView?
    private var notificationLabel: UILabel?
    private weak var delegate: ChatButtonDelegate?
    // custom Constraints (For Animation)
    var containerViewLeadingConstraint: NSLayoutConstraint!
    private var containerViewWidthConstraint: NSLayoutConstraint!
    private var chatButtonWidthConstraint: NSLayoutConstraint!
    private var chatButtonTrailingConstraint: NSLayoutConstraint!
    private var errorViewWidthConstraint: NSLayoutConstraint!
    // static Chat Button size
    static let sizeView:CGFloat = 70

    // MARK: - Init Methods
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
     getChatButton: get view from nib and set up subviews, constraints and delegate
     */
    class func getChatButton(delegate: ChatButtonDelegate) -> ChatButton? {
        let nibArray = Bundle.main.loadNibNamed("ChatButton", owner: self, options: nil)
        if let view = nibArray?.first as? ChatButton {
            view.setUp(delegate: delegate)
            return view
        }
        return nil
    }
    
    // MARK: - Private Methods
    private func setUp(delegate: ChatButtonDelegate) {
        // Set delegate
        self.delegate = delegate
        // Set need Constraint for animation
        self.chatButtonTrailingConstraint = button?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16)
        self.errorViewWidthConstraint = errorView?.widthAnchor.constraint(equalToConstant: ChatButton.sizeView)
        self.containerViewWidthConstraint = self.widthAnchor.constraint(equalToConstant: ChatButton.sizeView)
        // add / remove needed constraints
        NSLayoutConstraint.activate([self.errorViewWidthConstraint, self.chatButtonTrailingConstraint, self.containerViewWidthConstraint])
        NSLayoutConstraint.deactivate([self.chatButtonLeadingConstraint, self.errorViewLeadingConstraint])
        // Change color of close button
        let image = closeButton?.image(for: .normal)
        let tintedImage = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        closeButton?.setImage(tintedImage, for: .normal)
        closeButton?.tintColor = UIColor.lpDeepBlue
        // Create notif View
        popNotification = UIView(frame: CGRect(x: 65, y: 10, width: 24, height: 24))
        popNotification?.backgroundColor = UIColor.white
        popNotification?.layer.cornerRadius = 12
        popNotification?.isHidden = true
        // Create notif Label
        notificationLabel = UILabel(frame: popNotification?.bounds ?? CGRect(x: 1, y: 1, width: 22, height: 22))
        notificationLabel?.backgroundColor = UIColor.clear
        notificationLabel?.textColor = UIColor.lpDeepBlue
        notificationLabel?.adjustsFontSizeToFitWidth = true
        notificationLabel?.minimumScaleFactor = 0.5
        notificationLabel?.textAlignment = .center
        notificationLabel?.font = UIFont(name: "DINPro-Bold", size: 14)
        // add notif views to chat button
        popNotification?.addSubview(notificationLabel!)
        button?.addSubview(popNotification!)
    }
    
    // MARK: Behaviour Button (Private)
    @IBAction private func chatButtonClicked() {
        delegate?.didCallChat()
    }
    
    @IBAction private func hideError() {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.5,
                       animations: {
                        // Hide the error view (with Alpha)
                        self.closeButton?.alpha = 0.0
        }, completion: { finish in })
        UIView.animate(withDuration: 1.0,
                       animations: {
                        // Animation
                        NSLayoutConstraint.deactivate([self.chatButtonLeadingConstraint, self.errorViewLeadingConstraint])
                        NSLayoutConstraint.activate([self.chatButtonTrailingConstraint, self.errorViewWidthConstraint])
                        self.layoutIfNeeded()
        }, completion: { finish in
            // Layout to be setted without animation :: reduce the size of containerView to match the size of the chatButton
            self.errorView?.alpha = 0.0
            NSLayoutConstraint.deactivate([self.containerViewLeadingConstraint])
            NSLayoutConstraint.activate([self.containerViewWidthConstraint])
        })
    }
    // MARK: Public services
    /*
     setNotification : offer the possibility to set the number of unread methods
     badge : the number of unread messages to show, if 0 hide notification 
     */
    func setNotification(badge: Int = 0) {
        if badge <= 0 {
            popNotification?.isHidden = true
        } else {
            notificationLabel?.text = "\(badge)"
            popNotification?.isHidden = false
        }
    }
    /*
     showError : the animation to show error message on the button
     */
    func showError() {
        // Layout to be setted without animation :: prepare containerView to be extanded
        NSLayoutConstraint.activate([self.containerViewLeadingConstraint])
        NSLayoutConstraint.deactivate([self.containerViewWidthConstraint])
        self.errorView?.alpha = 1.0
        self.layoutIfNeeded()
        UIView.animate(withDuration: 1.0,
                         animations: {
                            // Animation
                            NSLayoutConstraint.deactivate([self.chatButtonTrailingConstraint, self.errorViewWidthConstraint])
                            NSLayoutConstraint.activate([self.chatButtonLeadingConstraint, self.errorViewLeadingConstraint])
                            self.layoutIfNeeded()
        }, completion: { finish in
            // Show the error view (with Alpha)
            UIView.animate(withDuration: 0.25,
                           animations: {
            self.closeButton?.alpha = 1.0
            }, completion: { finish in })
        })
    }
    /*
     resetLayout: reset default value layout before showing the button
     */
    func resetLayout() {
        NSLayoutConstraint.deactivate([self.chatButtonLeadingConstraint, self.errorViewLeadingConstraint,self.containerViewLeadingConstraint])
        NSLayoutConstraint.activate([self.chatButtonTrailingConstraint, self.errorViewWidthConstraint])
        self.layoutIfNeeded()
        self.errorView?.alpha = 0.0
    }
}
