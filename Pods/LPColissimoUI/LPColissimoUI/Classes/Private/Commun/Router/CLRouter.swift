//
//  CLRouter.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 29/04/2019.
//

import UIKit

enum Router {
    
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth
    
    var viewControllerType: UIViewController.Type {
        switch self {
        case .first:
            return FirstStepViewController.self
        case .second:
            return ColissimoDimensionViewController.self
        case .third:
            return ThirdStepViewController.self
        case .fourth:
            return CLSenderViewController.self
        case .fifth:
            return CLReceiverViewController.self
        case .sixth:
            return SixthStepViewController.self
        }
    }
}

class CLRouter {
    
    static let shared: CLRouter = CLRouter()
    
    func change(step: Router, navigation: UINavigationController) {
        switch step {
        case .first:
            self.popTo(step: .first, navigation: navigation)
        case .second:
            self.popTo(step: .second, navigation: navigation)
        case .third:
            self.popTo(step: .third, navigation: navigation)
        case .fourth:
            self.popTo(step: .fourth, navigation: navigation)
        case .fifth:
            self.popTo(step: .fifth, navigation: navigation)
        case .sixth:
            self.popTo(step: .sixth, navigation: navigation)
        }
    }
    
    func areEqual() -> Bool {
        if ColissimoData.shared.equal(to: ColissimoDataCopy.shared) {
            return true
        } else {
            return false
        }
    }
    
    func popTo(step: Router, navigation: UINavigationController) {
        let viewController = navigation.viewControllers.first {
            $0.classForCoder == step.viewControllerType
        }
        
        guard let _viewController = viewController else {
            return
        }
        
        navigation.popToViewController(_viewController, animated: true)
    }
    
}
