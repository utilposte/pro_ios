//
//  MockHomeViewModel.swift
//  LaPosteProTests
//
//  Created by PENA SANCHEZ Edwin Jose on 17/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
@testable import LaPostePro

class MockHomeViewModel: HomeViewModel {
    
    override func setupCategories(completion:@escaping([Module]) -> Void) {
        completion([Module()])
    }
}
