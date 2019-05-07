//
//  File.swift
//  LaPosteProTests
//
//  Created by PENA SANCHEZ Edwin Jose on 17/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
@testable import LaPostePro

extension XCTestCase {
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}
