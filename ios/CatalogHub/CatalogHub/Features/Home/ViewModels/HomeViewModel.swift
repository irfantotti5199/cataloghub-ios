//
//  HomeViewModel.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private let repository: ProductRepository
    
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    func fetchFeaturedProducts() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            products = try await repository.getFeaturedProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
