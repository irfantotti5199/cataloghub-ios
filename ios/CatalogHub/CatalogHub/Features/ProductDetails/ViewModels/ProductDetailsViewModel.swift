//
//  ProductDetailsViewModel.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ProductDetailsViewModel {
    
    private let productID: Int
    private let repository: ProductRepository
    private(set) var product: Product?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    init(repository: ProductRepository, productID: Int) {
        self.productID = productID
        self.repository = repository
    }
    
    func fetchProductDetails() async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        
        do {
            product = try await repository.getProduct(id: productID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
