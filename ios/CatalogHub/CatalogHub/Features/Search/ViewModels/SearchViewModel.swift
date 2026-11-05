//
//  SearchViewModel.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    private let repository: ProductRepository
    
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private var currentSearchID = UUID()
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    func searchProducts(query: String) async {
        let searchText = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let searchId = UUID()
        currentSearchID = searchId
        
        guard !searchText.isEmpty else {
            products = []
            errorMessage = nil
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer {
            
            if currentSearchID == searchId {
                isLoading = false
            }
        }
        
        do {
            let results = try await repository.searchProducts(query: searchText)
            guard currentSearchID == searchId  else {
                return
            }
            products  = results
        } catch {
            guard currentSearchID == searchId else {
                return
            }
            errorMessage = error.localizedDescription
        }
    }
    
}
