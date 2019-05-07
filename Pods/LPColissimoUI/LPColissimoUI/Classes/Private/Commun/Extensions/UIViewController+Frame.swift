//
//  UIViewController+Frame.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 31/10/2018.
//

import Foundation

extension UIViewController{
    
    
    /// Calculate top distance with "navigationBar" and "statusBar" by adding a
    /// subview constraint to navigationBar or to topAnchor or superview
    /// - Returns: The real distance between topViewController and Bottom navigationBar
    func calculateTopDistance() -> CGFloat{
        
        /// Create view for misure
        let misureView : UIView     = UIView()
        misureView.backgroundColor  = .clear
        view.addSubview(misureView)
        
        /// Add needed constraint
        misureView.translatesAutoresizingMaskIntoConstraints                    = false
        misureView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive     = true
        misureView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive   = true
        misureView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        if let nav = navigationController {
            misureView.topAnchor.constraint(equalTo: nav.navigationBar.bottomAnchor).isActive = true
        }else{
            misureView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        
        /// Force layout
        view.layoutIfNeeded()
        
        /// Calculate distance
        let distance = view.frame.size.height - misureView.frame.size.height
        
        /// Remove from superview
        misureView.removeFromSuperview()
        
        return distance
        
    }
    
}
