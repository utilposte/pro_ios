//
//  ToastView.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 24/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

struct Toast {
    let title: String
    let titleColor: UIColor
    let backgroundColor: UIColor
    let viewController: UIViewController
    let duration: TimeInterval
}

class ToastView: UIView {

    let toastView = UIView()
    let toastTitle = UILabel()
    let toastImage = UIImageView()

    func drawToast(toast: Toast, image: UIImage = R.image.smallCheck()!) {
        DispatchQueue.main.async {

            self.toastTitle.text = toast.title
            self.toastTitle.textColor = .white
            self.toastTitle.font = UIFont.systemFont(ofSize: 14)
            self.toastTitle.numberOfLines = 2
            
            self.toastView.addSubview(self.toastTitle)
            
            self.toastImage.image = image
            self.toastImage.tintImageColor(color: .white)
            self.toastImage.contentMode = .scaleToFill
            self.toastImage.frame.size = CGSize(width: 60, height: 40)
            self.toastImage.translatesAutoresizingMaskIntoConstraints = false
            self.toastView.addSubview(self.toastImage)

            self.toastView.backgroundColor = toast.backgroundColor
            
            
            var width = self.toastTitle.intrinsicContentSize.width + self.toastImage.frame.width
            var height = self.toastTitle.intrinsicContentSize.height + 10
            
            if width > (UIScreen.main.bounds.size.width - 30) {
                width = UIScreen.main.bounds.size.width - 30
                height = (self.toastTitle.intrinsicContentSize.height * 2) + 10
            }
            
            self.toastView.frame.size = CGSize(width: width, height: height)
            self.toastView.frame.origin = CGPoint(x: (toast.viewController.view.bounds.width / 2 - self.toastView.frame.width / 2), y: toast.viewController.view.bounds.height * 0.85)

            self.toastTitle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.toastImage.widthAnchor.constraint(equalToConstant: 15),
                self.toastImage.heightAnchor.constraint(equalToConstant: 10),
                self.toastImage.leadingAnchor.constraint(equalTo: self.toastView.leadingAnchor, constant: 10),
                self.toastTitle.leadingAnchor.constraint(equalTo: self.toastImage.trailingAnchor, constant: 10),
                self.toastTitle.trailingAnchor.constraint(equalTo: self.toastView.trailingAnchor, constant: 10),
                self.toastImage.centerYAnchor.constraint(equalTo: self.toastView.centerYAnchor),
                self.toastTitle.centerYAnchor.constraint(equalTo: self.toastView.centerYAnchor),
            ])

            self.toastView.layer.masksToBounds = true
            self.toastView.layer.cornerRadius = self.toastView.frame.height / 2
            self.toastView.alpha = 0

            UIView.animate(withDuration: 1) {
                toast.viewController.view.addSubview(self.toastView)
                self.toastView.alpha = 1
            }

            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: toast.duration, repeats: false) { _ in
                    self.hideToast()
                }
            } else {
                Timer.scheduledTimer(timeInterval: toast.duration, target: self, selector: #selector(ToastView.hideToast), userInfo: nil, repeats: false)
            }
        }
    }

    @objc func hideToast() {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.toastView.alpha = 0
        }, completion: {(_) -> Void in
            self.toastView.removeFromSuperview()
        })
    }

}
