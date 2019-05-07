//
//  MockNavigationController.swift
//  LaPosteProTests
//
//  Created by PENA SANCHEZ Edwin Jose on 15/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
@testable import LaPostePro

class MockNavigationController: UINavigationController {
    
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: true)
    }
}
