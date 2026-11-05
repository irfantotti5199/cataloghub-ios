//
//  MockProductRepository.swift
//  CatalogHubTests
//
//  Created by Irfan on 05/11/26.
//

import Foundation
@testable import CatalogHub

final class MockProductRepository: ProductRepository {
    
    var mockProducts: [Product] = []
    var shouldThrowError = false
    
    func getProducts() async throws -> [Product] {
        return mockProducts
    }
    
    func getFeaturedProducts() async throws -> [Product] {
        if shouldThrowError {
            throw APIError.invalidResponse
        }
        return mockProducts
    }
    
    func getProduct(id: Int) async throws -> Product {
        guard let product = mockProducts.first(where: { $0.id == id }) else {
            throw APIError.invalidResponse
        }
        return product
    }
    
    func getCategories() async throws -> [String] {
        return []
    }
    
    func getProducts(category: String) async throws -> [Product] {
        return mockProducts
    }
    
    func searchProducts(query: String) async throws -> [Product] {
        return mockProducts.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }
    
}
