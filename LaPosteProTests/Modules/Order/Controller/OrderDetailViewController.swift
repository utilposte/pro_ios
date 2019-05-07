//
//  OrderDetailViewController.swift
//  LaPosteProTests
//
//  Created by PENA SANCHEZ Edwin Jose on 15/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
@testable import LaPostePro

class OrderDetailViewControllerTest: XCTestCase {
    
    var controller: OrderDetailViewController!
    let viewModel = MockOrderViewModel()
    var tableView: UITableView!
    
    override func setUp() {
        guard let controller = R.storyboard.order.orderDetailViewController() else {
            return XCTFail("Could not instantiate orderDetailViewController from storyboard")
        }
        self.viewModel.addReexProduct()
        controller.viewModel = self.viewModel
        self.controller = controller
        self.controller.loadViewIfNeeded()
        tableView = controller.tableView
    }
    
    func testTableViewHasCells() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderEntryTableViewCell")
        XCTAssertNotNil(cell, "TableView should be able to dequeue cell with identifier: 'OrderEntryTableViewCell'")
    }
    
    func testTableViewDelegateIsViewController() {
        XCTAssertTrue(tableView.delegate === controller, "Controller should be delegate for the table view")
    }
    
    func testTableViewHasRightData() {
        XCTAssertNotNil(self.controller.tableView, "Controller should have a tableview")
        XCTAssertEqual(controller.tableView(self.tableView, numberOfRowsInSection: 0), 1, "should return the right number of rows")
        XCTAssertEqual(controller.numberOfSections(in: self.tableView), 6, "should return the right number of sections")
    }
    
    func testControllerCellHasRightReexProduct() {
        // Given
        guard let entryRow = self.controller.sections.firstIndex(where: { $0.first == .entry }) else {
            return XCTFail("there is not any entry items in the datasource")
        }
        let indexPath = IndexPath(row: 0, section: entryRow)
        
        // When
        let cell = controller.tableView(tableView, cellForRowAt: indexPath) as? OrderEntryTableViewCell
        
        // Then
        XCTAssertEqual(cell?.titleLabel.text, "Contrat de réexpédition", "should return title of reex product")
        XCTAssertEqual(cell?.quantityLabel.text, "", "should return description of reex product")
        XCTAssertEqual(cell?.detailLabel.text, "18 avril 2019 - 31 mai 2019", "should return date of reex product")
        XCTAssertEqual(cell?.priceLabel.text, "66,00 €", "should return price of reex product")
    }
    
    func testContactUsTappedButton_PushWebViewControllerWithRightURL() {
        // Given
        let navigationController = MockNavigationController(rootViewController: self.controller)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        // When
        self.controller.contactUsTapped()
        // Then
        guard let webview = navigationController.pushedViewController as? WebViewController else { XCTFail(); return }
        XCTAssertTrue(webview.url == WebViewURL.contact.rawValue)
    }
    
    func testDidSelectRowReexCellOpenDetail() {
        // Given
        let navigationController = MockNavigationController(rootViewController: self.controller)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        
        guard let entryRow = self.controller.sections.firstIndex(where: { $0.first == .entry }) else {
            return XCTFail("there is not any entry items in the datasource")
        }
        let indexPath = IndexPath(row: 0, section: entryRow)
        
        // When
        controller.tableView(tableView, didSelectRowAt: indexPath)
        // Then
        let mostTopViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        XCTAssert(mostTopViewController is ReexCartDetailViewController, "It should to be present a ReexCartDetailViewController")
        mostTopViewController?.dismiss(animated: false, completion: nil)
    }

}
