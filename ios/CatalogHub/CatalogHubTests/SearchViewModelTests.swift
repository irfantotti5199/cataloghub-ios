//
//  File.swift
//  CatalogHubTests
//
//  Created by Irfan on 05/11/26.
//

import Foundation
import XCTest
@testable import CatalogHub

@MainActor
final class SearchViewModelTests: XCTest {
    
    func testSearchProductSuccess() async {
        let mock = MockProductRepository()
        mock.mockProducts = [
            Product(
                id: 1,
                title: "iPhone",
                price: 999,
                description: "Apple smartphone",
                category: "electronics",
                imageURL: "https://example.com/iphone.jpg",
                rating: 4.8
            ),
            Product(
                id: 2,
                title: "Jacket",
                price: 50,
                description: "Winter jacket",
                category: "clothing",
                imageURL: "https://example.com/jacket.jpg",
                rating: 4.2
            )
        ]
        
        let viewModel = SearchViewModel(repository: mock)
        
        await viewModel.searchProducts(query: "iPhone")
        XCTAssertEqual(viewModel.products.count, 1)
        XCTAssertEqual(viewModel.products.first?.title, "iPhone")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        
    }
    
    func testSearchProductWithEmptyQuery() async {
        let mock = MockProductRepository()
        
        let viewModel = SearchViewModel(repository: mock)
        
        await viewModel.searchProducts(query: "  ")
        
        XCTAssertTrue(viewModel.products.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    
    }
    
    func testSeachProductFailure() async {
        let mock = MockProductRepository()
        mock.shouldThrowError = true
        let viewModel = SearchViewModel(repository: mock)
        
        await viewModel.searchProducts(query: "iPhone")
        
        XCTAssertTrue(viewModel.products.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        
        
    }
}
