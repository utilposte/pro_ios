//
//  CartViewControllerTest.swift
//  LaPosteProTests
//
//  Created by PENA SANCHEZ Edwin Jose on 16/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
@testable import LaPostePro

class CartViewControllerTest: XCTestCase {
    
    var controller: CartViewController!
    let viewModel = MockCartViewModel()
    var tableView: UITableView!
    
    override func setUp() {
        guard let controller = R.storyboard.cart.cartViewControllerID() else {
            return XCTFail("Could not instantiate CartViewController from storyboard")
        }
        self.viewModel.addReexProduct = true
        controller.cartViewModel = viewModel
        self.controller = controller
        self.controller.loadViewIfNeeded()
        self.controller.setupView()
        tableView = controller.tableView
    }
    
    func testTableViewHasCells() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCartColissimoTableViewCellID")
        XCTAssertNotNil(cell, "TableView should be able to dequeue cell with identifier: 'ProductCartColissimoTableViewCellID'")
    }
    
    func testTableViewDelegateIsViewController() {
        XCTAssertTrue(tableView.delegate === controller, "Controller should be delegate for the table view")
    }
    
    func testTableViewHasRightData() {
        XCTAssertNotNil(self.controller.tableView, "Controller should have a tableview")
        XCTAssertEqual(controller.tableView(self.tableView, numberOfRowsInSection: 0), 6, "should return the right number of rows")
        XCTAssertEqual(controller.numberOfSections(in: self.tableView), 1, "should return the right number of sections")
    }

    func testControllerCellHasRightReexProduct() {
        // Given
        guard let cartRow = controller.cartArray.firstIndex(where: { $0 == .cart}) else {
            return XCTFail("there is not any cart items in the datasource")
        }
        let indexPath = IndexPath(row: cartRow, section: 0)
        
        // When
        let cell = controller.tableView(tableView, cellForRowAt: indexPath) as? ProductCartColissimoTableViewCell
        
        // Then
        XCTAssertEqual(cell?.productTitleLabel.text, "Contrat de réexpédition temporaire nationale", "should return title of reex product")
        XCTAssertEqual(cell?.productDescLabel.text, "", "should return description of reex product")
        XCTAssertEqual(cell?.additionalInfoLabel.text, "20 avril 2019 - 31 mai 2019", "should return date of reex product")
        XCTAssertEqual(cell?.unitPriceHTLabel.text, "66,00 €", "should return price of reex product")
    }
    
    func testDidSelectRowReexCellOpenDetail() {
        // Given
        let navigationController = MockNavigationController(rootViewController: self.controller)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        
        guard let cartRow = controller.cartArray.firstIndex(where: { $0 == .cart}) else {
            return XCTFail("there is not any cart items in the datasource")
        }
        let indexPath = IndexPath(row: cartRow, section: 0)
        
        // When
        controller.tableView(tableView, didSelectRowAt: indexPath)
        // Then
        let mostTopViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        XCTAssert(mostTopViewController is ReexCartDetailViewController, "It should to be present a ReexCartDetailViewController")
        mostTopViewController?.dismiss(animated: false, completion: nil)
    }
}
