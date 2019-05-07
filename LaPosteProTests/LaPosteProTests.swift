//
//  LaPosteProTests.swift
//  LaPosteProTests
//
//  Created by Issam DAHECH on 15/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
@testable import LaPostePro

class LaPosteProTests: XCTestCase {

    var messageManager: MessageManager!
    override func setUp() {
        super.setUp()
        messageManager = MessageManager.shared
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testActivateSDK() {
        let promise = expectation(description: "SDK Activated")
        messageManager.presentChatFromButton { (success) in
            if success == true {
                promise.fulfill()
            } else {
                XCTFail("Error: SDK Fail to connect")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
