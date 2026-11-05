//
//  ProductRepositoryImpl.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import Foundation
struct ProductRepositoryImpl: ProductRepository {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getProducts() async throws -> [Product] {
        let products: [ProductDTO] = try await apiClient.get("api/products")
        return products.map {$0.toDomain()}
    }
    
    func getFeaturedProducts() async throws -> [Product] {
        let products: [ProductDTO] = try await apiClient.get("api/products/featured")
        return products.map {$0.toDomain()}
    }
    
    func getProduct(id: Int) async throws -> Product {
        let product: ProductDTO = try await apiClient.get("api/products/\(id)")
        return product.toDomain()
    }
    
    func getCategories() async throws -> [String] {
        try await apiClient.get("api/categories")
    }
    
    func getProducts(category: String) async throws -> [Product] {
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? category
        let products: [ProductDTO] = try await apiClient.get("api/categories/\(encodedCategory)/products")
        return products.map {$0.toDomain()}
    }
    
    func searchProducts(query: String) async throws -> [Product] {
        var allowedCharacters = CharacterSet.urlQueryAllowed
        allowedCharacters.remove(charactersIn: "&+=?")
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? query
        let products: [ProductDTO] = try await apiClient.get("api/products/search?q=\(encodedQuery)")
        return products.map {$0.toDomain()}
    }
}
