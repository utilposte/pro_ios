//
//  HomeViewControllerTest.swift
//  LaPosteProTests
//
//  Created by PENA SANCHEZ Edwin Jose on 17/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
@testable import LaPostePro

class HomeViewControllerTest: XCTestCase {
    
    var controller: HomeViewController!
    let homeViewModel = MockHomeViewModel()
    let cartViewModel = MockCartViewModel()
    var tableView: UITableView!
    
    override func setUp() {
        guard let controller = R.storyboard.home.homeStoryboard() else {
            return XCTFail("Could not instantiate HomeViewController from storyboard")
        }
        self.cartViewModel.addReexProduct = true
        controller.homeViewModel = self.homeViewModel
        controller.cartViewModel = self.cartViewModel
        self.controller = controller
        self.controller.addProductAndShowCart()
        self.controller.loadViewIfNeeded()
        tableView = controller.tableView
    }
    
    func givenVerticalCellAndVerticalItem() -> (HomeVerticalListTableViewCell?, HomeVerticalListItemTableViewCell?, IndexPath) {
        // Given
        let module = Module.init(moduleName: "Vous avez ajouté à votre panier", deepLink: "",
                                 actionDescription: "Finaliser ma commande", items: cartViewModel.products,
                                 contentType: .cartList)
        guard let homeRow = controller.homeTableViewCellArray.firstIndex(where: { $0 == HomeViewController.Home.verticalList(module: module)}) else {
            return (nil, nil, IndexPath(row: 0, section: 0))
        }
        var indexPath = IndexPath(row: homeRow, section: 0)
        
        // When
        guard let verticalCell = controller.tableView(tableView, cellForRowAt: indexPath) as? HomeVerticalListTableViewCell,
            let productRow = verticalCell.module.items?.firstIndex(where: { $0.id == "TN_PRO-1_6"}) else {
                return (nil, nil, IndexPath(row: 0, section: 0))
        }
        
        indexPath = IndexPath(row: productRow, section: 0)
        guard let subMenuTableView = verticalCell.subMenuTableView,
            let verticalItemCell = verticalCell.tableView(subMenuTableView, cellForRowAt: indexPath) as? HomeVerticalListItemTableViewCell else {
               return (nil, nil, IndexPath(row: 0, section: 0))
        }
        
        return (verticalCell, verticalItemCell, indexPath)
    }
    
    func testTableViewHasCells() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVerticalListTableViewCellID")
        XCTAssertNotNil(cell, "TableView should be able to dequeue cell with identifier: 'HomeVerticalListTableViewCell'")
    }
    
    func testTableViewDelegateIsViewController() {
        XCTAssertTrue(tableView.delegate === controller, "Controller should be delegate for the table view")
    }
    
    func testTableViewHasRightData() {
        XCTAssertNotNil(self.controller.tableView, "Controller should have a tableview")
        XCTAssertTrue(controller.tableView(self.tableView, numberOfRowsInSection: 0) > 0, "should return the right number of rows")
    }
    
    func testControllerVerticalCellHasRightReexProduct() {
        
        // Given
        let (verticalCell, verticalItemCell, _) = givenVerticalCellAndVerticalItem()
        
        // Then
        XCTAssertEqual(verticalCell?.cellTitle.text, "Vous avez ajouté à votre panier", "should return title of vertical cell")
        XCTAssertEqual(verticalItemCell?.verticalListItemTitleLabel.text, "Contrat de réexpédition temporaire nationale", "should return title of reex product")
        XCTAssertEqual(verticalItemCell?.verticalListProductCountLabel.text, "", "should return description of reex product")
        XCTAssertEqual(verticalItemCell?.verticalListItemDetailLabel.text, "20 avril 2019 - 31 mai 2019", "should return date of reex product")
        XCTAssertEqual(verticalItemCell?.verticalListItemPriceLabel.text!, "66,00 € ", "should return price of reex product")
    }
    
    func testDidSelectRowReexCellOpenDetail() {
        // Given
        let navigationController = MockNavigationController(rootViewController: self.controller)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        
        // Given
        let (verticalCell, _, index) = givenVerticalCellAndVerticalItem()
        
        // When
        verticalCell?.tableView(tableView, didSelectRowAt: index)
        // Then
        let mostTopViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        XCTAssert(mostTopViewController is ReexCartDetailViewController, "It should to be present a ReexCartDetailViewController")
        mostTopViewController?.dismiss(animated: false, completion: nil)
    }
    
}
