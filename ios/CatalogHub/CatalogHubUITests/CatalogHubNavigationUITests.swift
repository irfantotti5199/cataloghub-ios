//
//  CatalogHubNavigationUITests.swift
//  CatalogHubUITests
//
//  Created by Irfan on 05/11/26.
//

import Foundation
import XCTest

final class CatalogHubNavigationUITests: XCTestCase {

    func testAppLaunchesSuccessfully() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.exists)
    }
    
    func testAllMainTabsAreVisible() {
        let app = XCUIApplication()
        app.launch()
        
        let tabBars = app.tabBars
        
        XCTAssertTrue(tabBars.buttons["Home"].exists)
        XCTAssertTrue(tabBars.buttons["Categories"].exists)
        XCTAssertTrue(tabBars.buttons["Search"].exists)
        XCTAssertTrue(tabBars.buttons["Enquiry"].exists)
    }
    
    func testUserCanNavigateBetweenTabs() {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.buttons["Categories"].tap()
        XCTAssertTrue(app.navigationBars["Categories"].exists)
        
        app.tabBars.buttons["Search"].tap()
        XCTAssertTrue(app.navigationBars["Search"].exists)
        
        app.tabBars.buttons["Enquiry"].tap()

        XCTAssertTrue(
            app.staticTexts["Interested in a product?"]
                .waitForExistence(timeout: 5)
        )
        
        app.tabBars.buttons["Home"].tap()
        XCTAssertTrue(app.navigationBars["CatalogHub"].exists)
    }
    
    func testEnquiryFormElementsAreVisible() {

        
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Enquiry"].tap()

        XCTAssertTrue(app.staticTexts["Interested in a product?"].exists)
        XCTAssertTrue(app.textFields["Full Name"].exists)
        XCTAssertTrue(app.textFields["Email Address"].exists)
        XCTAssertTrue(app.textFields["Phone Number"].exists)
        XCTAssertTrue(app.textFields["Your Message"].exists)
        XCTAssertTrue(app.buttons["Submit Enquiry"].exists)
    }

    func testSearchScreenIsVisible() {

        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Search"].tap()

        XCTAssertTrue(app.navigationBars["Search"].exists)
        XCTAssertTrue(app.searchFields["Search products"].exists)
    }
    
    func testInspectHomeScreen() {

        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(
            app.tabBars.buttons["Home"].waitForExistence(timeout: 5)
        )
        
        print("===== HOME SCREEN HIERARCHY =====")
        print(app.debugDescription)
    }
    
    func testInspectFeaturedProducts() {
        let app = XCUIApplication()
        app.launch()

        sleep(3)

        print("========== UI HIERARCHY ==========")
        print(app.debugDescription)
        print("========== END UI HIERARCHY ======")
    }
    
    
    func testUserCanOpenProductDetails() {
        let app = XCUIApplication()
        app.launch()

        let firstProduct = app.descendants(matching: .any)
            .matching(
                NSPredicate(
                    format: "identifier BEGINSWITH %@",
                    "home.product."
                )
            )
            .firstMatch

        XCTAssertTrue(
            firstProduct.waitForExistence(timeout: 15),
            "Featured product was not found"
        )

        firstProduct.tap()

        let productDetails = app.navigationBars["Product Details"]

        XCTAssertTrue(
            productDetails.waitForExistence(timeout: 10),
            "Product Details screen did not open"
        )
    }
    
    
}

