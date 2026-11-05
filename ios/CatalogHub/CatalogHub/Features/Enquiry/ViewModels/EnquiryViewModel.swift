//
//  EnquiryViewModel.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class EnquiryViewModel {
    private let repository: EnquiryRepository
    
    var name = ""
    var email = ""
    var phone = ""
    var message = ""
    
    private(set) var isSubmitting = false
    private(set) var errorMessage: String?
    private(set) var isSubmissionSuccessful = false
    
    init(repository: EnquiryRepository) {
        self.repository = repository
    }
    
    func submitEnquiry() async {
        errorMessage = nil
        isSubmissionSuccessful = false
        
        let enquiry = EnquiryRequest(name: name.trimmingCharacters(in: .whitespacesAndNewlines), email: email.trimmingCharacters(in: .whitespacesAndNewlines) , phone: phone.trimmingCharacters(in: .whitespacesAndNewlines), message: message.trimmingCharacters(in: .whitespacesAndNewlines))
        
        guard !enquiry.name.isEmpty, !enquiry.email.isEmpty, !enquiry.phone.isEmpty, !enquiry.message.isEmpty else {
            errorMessage = "Please fill in all the fields"
            return
        }
        
        guard enquiry.email.contains("@"),enquiry.email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return
        }
        isSubmitting = true
        defer {
            isSubmitting = false
        }
        
        do {
            _ = try await repository.submitEnquiry(enquiry)
            isSubmissionSuccessful = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
