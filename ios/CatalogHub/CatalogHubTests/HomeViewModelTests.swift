//
//  HomeViewModelTests.swift
//  CatalogHub
//
//  Created by Irfan on 05/11/26.
//

import Foundation
import XCTest
@testable import CatalogHub

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    func testFetchFeaturedProductsSuccess() async {
        let mockRepo = MockProductRepository()
        mockRepo.mockProducts = [
            Product(id: 1, title: "iPhone", price: 999, description: "Apple smartphone", category: "electronics", imageURL: "https://example.com/iphone.jpg", rating: 4.8)
        ]
        let homeViewModel = await HomeViewModel(repository: mockRepo)
        
        await homeViewModel.fetchFeaturedProducts()
        
        XCTAssertEqual(homeViewModel.products.count, 1)
        XCTAssertEqual(homeViewModel.products.first?.title, "iPhone")
        XCTAssertNil(homeViewModel.errorMessage)
        XCTAssertFalse(homeViewModel.isLoading)
    }
    
    
    func testFetchFeaturedProductsFail() async {
        let mock = MockProductRepository()
        mock.shouldThrowError = true
        let viewModel = HomeViewModel(repository: mock)
        await viewModel.fetchFeaturedProducts()
        
        XCTAssertTrue(mock.mockProducts.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
