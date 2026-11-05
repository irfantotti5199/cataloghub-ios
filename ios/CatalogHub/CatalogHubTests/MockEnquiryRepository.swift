//
//  MockEnquiryRepository.swift
//  CatalogHubTests
//
//  Created by Irfan on 05/11/26.
//

import XCTest
@testable import CatalogHub

final class MockEnquiryRepository: EnquiryRepository {
    
    var shouldThrowError = false
    var submittedEnquiry: EnquiryRequest?
    
    func submitEnquiry(_ enquiry: CatalogHub.EnquiryRequest) async throws -> CatalogHub.EnquiryResponse {
        submittedEnquiry = enquiry
        if shouldThrowError {
            throw APIError.invalidResponse
        }
        return EnquiryResponse(status: "success", message: "Enquiry submitted successfully")
    }
}
