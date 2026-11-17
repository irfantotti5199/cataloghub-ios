//
//  DependencyContainer.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import Foundation

struct DependencyContainer {
    let apiClient: APIClient
    let productRepository: ProductRepository
    let enquiryRepository: EnquiryRepository
    
    init(baseURL: URL) {
        let client = APIClient(baseURL: baseURL)
        self.apiClient = client
        self.productRepository = ProductRepositoryImpl(apiClient: apiClient)
        self.enquiryRepository = EnquiryRepositoryImpl(apiClient: apiClient)
    }
}
