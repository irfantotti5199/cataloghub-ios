//
//  ProductRepository.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import Foundation

protocol ProductRepository {
    func getProducts() async throws -> [Product]
    
    func getFeaturedProducts() async throws -> [Product]
    
    func getProduct(id: Int) async throws -> Product
    
    func getCategories() async throws -> [String]
    
    func getProducts(category: String) async throws -> [Product]
    
    func searchProducts(query: String) async throws -> [Product]
}
