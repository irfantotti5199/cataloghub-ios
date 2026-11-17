//
//  CategoryProductsViewModel.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class CategoryProductsViewModel {
    private let repository: ProductRepository
    private let category: String
    
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var products: [Product] = []
    
    var featuredProducts: [Product] {
        Array(
            products
                .sorted { $0.rating > $1.rating}
                .prefix(5)
        )
    }
    
    var remainingProducts: [Product] {
        let featureIDs = Set(featuredProducts.map(\.id))
        return products.filter {
            !featureIDs.contains($0.id)
        }
    }
    
    init(repository: ProductRepository,category: String) {
        self.repository = repository
        self.category = category
    }
    
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        
        do {
            products = try await repository.getProducts(category: category)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
