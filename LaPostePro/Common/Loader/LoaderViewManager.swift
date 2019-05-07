//
//  LoaderViewManager.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 27/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class LoaderViewManager: NSObject {
    private var loaderView : LoaderViewCustom!
    let window = UIApplication.shared.keyWindow
    var timerStop : Timer? = nil {
        willSet {
            timerStop?.invalidate()
        }
    }
    
    override init() {
        super.init()
        loaderView = R.nib.loaderViewCustom.firstView(owner: self)
        loaderView.isHidden = true
        loaderView.frame = window?.bounds ?? .zero
        
        window?.addSubview(loaderView)
        window?.bringSubview(toFront: loaderView)
    }
    
    func isShown() -> Bool {
        return !loaderView.isHidden
    }
    
    func showLoderView(message: String = "") {
        DispatchQueue.main.async {
            if self.loaderView.frame == .zero {
                self.loaderView.frame = UIApplication.shared.keyWindow?.bounds ?? .zero
            }
            self.window?.bringSubview(toFront: self.loaderView)
            self.loaderView.isHidden = false
            self.timerStop = nil
            self.timerStop = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { (timer) in
                self.hideLoaderView()
            })
        }
    }
    
    func hideLoaderView() {
        DispatchQueue.main.async {
            self.loaderView.isHidden = true
            self.timerStop = nil
        }

    }
}
