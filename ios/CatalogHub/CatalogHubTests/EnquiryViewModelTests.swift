//
//  EnquiryViewModelTests.swift
//  CatalogHubTests
//
//  Created by Irfan on 05/11/26.
//

import XCTest
@testable import CatalogHub

@MainActor
final class EnquiryViewModelTests: XCTestCase {
    func testSubmitEnquirySuccess() async {
        let mock = MockEnquiryRepository()
        let viewModel = EnquiryViewModel(repository: mock)
        viewModel.name = "Irfan"
        viewModel.email = "irfan@example.com"
        viewModel.phone = "9876543210"
        viewModel.message = "Interested in your products"
        
        await viewModel.submitEnquiry()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isSubmitting)
        XCTAssertTrue(viewModel.isSubmissionSuccessful)
        
        XCTAssertEqual(mock.submittedEnquiry?.name, "Irfan")
        XCTAssertEqual(mock.submittedEnquiry?.email, "irfan@example.com")
    }
    
    func testSubmitEnquiryFailure() async {
        let mock = MockEnquiryRepository()
        mock.shouldThrowError = true
        let viewModel = EnquiryViewModel(repository: mock)
        
        viewModel.name = "Irfan"
        viewModel.email = "irfan@example.com"
        viewModel.phone = "9876543210"
        viewModel.message = "Interested in your products"
        
        await viewModel.submitEnquiry()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isSubmitting)
        XCTAssertFalse(viewModel.isSubmissionSuccessful)
    }
    
    func testSubmitEnquiryWithInvalidEmail() async {
        
        // Arrange
        let mockRepository = MockEnquiryRepository()
        
        let viewModel = EnquiryViewModel(
            repository: mockRepository
        )
        
        viewModel.name = "Irfan"
        viewModel.email = "invalid-email"
        viewModel.phone = "9876543210"
        viewModel.message = "Interested in your products"
        
        // Act
        await viewModel.submitEnquiry()
        
        // Assert
        XCTAssertFalse(viewModel.isSubmissionSuccessful)
        XCTAssertEqual(
            viewModel.errorMessage,
            "Please enter a valid email address."
        )
        XCTAssertNil(mockRepository.submittedEnquiry)
    }
    
    func testSubmitEnquiryWithEmptyFields() async {
    
        let mockRepository = MockEnquiryRepository()
        
        let viewModel = EnquiryViewModel(
            repository: mockRepository
        )
        await viewModel.submitEnquiry()
        XCTAssertFalse(viewModel.isSubmissionSuccessful)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertNil(mockRepository.submittedEnquiry)
    }
}
