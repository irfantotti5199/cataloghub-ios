//
//  EnquiryRepositoryImpl.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation

struct EnquiryRepositoryImpl: EnquiryRepository {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func submitEnquiry(_ enquiry: EnquiryRequest) async throws -> EnquiryResponse {
        
        let response: EnquiryResponse = try await apiClient.post("api/enquiries", body: enquiry)
        
        return response
    }
}
