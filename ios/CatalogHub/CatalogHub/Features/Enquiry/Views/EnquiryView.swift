//
//  EnquiryView.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import SwiftUI

struct EnquiryView: View {
    
    @State private var viewModel: EnquiryViewModel
    
    init(viewModel: EnquiryViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isSubmissionSuccessful {
                    thankyouView
                } else {
                    enquiryForm
                }
            }
            .navigationTitle("Product Enquiry")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var enquiryForm: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Interested in a product?")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Share your contact details and our sales team will get in touch with you.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Group {
                    TextField("Full Name", text: $viewModel.name)
                        .textContentType(.name)
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    TextField("Phone Number", text: $viewModel.phone)
                        .keyboardType(.phonePad)
                    
                    TextField("Your Message", text: $viewModel.message)
                        .lineLimit(4...6)
                    
                }
                .padding()
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
                
                Button {
                    Task {
                        await viewModel.submitEnquiry()
                    }
                } label: {
                    HStack {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .tint(.white)
                        }
                        
                        Text(viewModel.isSubmitting ? "Submitting...." : "Submit Enquiry")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius:10))
                }
                .disabled(viewModel.isSubmitting)
            }
        }
    }
    
    private var thankyouView: some View {
        VStack(spacing:16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 65))
                .foregroundStyle(.green)
            
            Text("Thank you!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your enquiry has been submitted successfully. Our sales team will contact you soon.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
        }
        .padding()
        
    }
}

