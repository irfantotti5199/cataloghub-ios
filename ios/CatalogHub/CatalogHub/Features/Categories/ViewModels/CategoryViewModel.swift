//
//  CategoryViewModel.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class CategoryViewModel {
    private let repository: ProductRepository
    
    private(set) var categories: [String] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    
    func fetchCategories() async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        
        do {
            categories = try await repository.getCategories()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
