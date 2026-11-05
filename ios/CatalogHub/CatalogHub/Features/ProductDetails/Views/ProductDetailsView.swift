//
//  ProductDetailsView.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import SwiftUI

struct ProductDetailsView: View {
    
    @State private var viewModel: ProductDetailsViewModel
    
    init(viewModel: ProductDetailsViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading product details...")
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else if let product = viewModel.product {
                productContent(product)
            } else {
                ContentUnavailableView(
                                "Product Not Found",
                                systemImage: "shippingbox",
                                description: Text("Product details are unavailable.")
                            )
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchProductDetails()
        }
    }
    
    private func productContent(_ product: Product) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: product.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 280)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius:12))
                
                Text(product.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Label(String(format: "%.1f / 5", product.rating), systemImage: "star.fill")
                    .foregroundStyle(.orange)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.headline)
                    
                    Text(product.category.capitalized)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    
                    Text(product.description)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Retry") {
                Task {
                    await viewModel.fetchProductDetails()
                }
            }
        }
    }
}


