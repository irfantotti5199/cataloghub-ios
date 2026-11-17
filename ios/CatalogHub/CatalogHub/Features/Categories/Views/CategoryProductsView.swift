//
//  CategoryProductsView.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import SwiftUI

struct CategoryProductsView: View {
    
    @State private var viewModel: CategoryProductsViewModel
    private let repository: ProductRepository
    private let category: String
    
    init(viewModel: CategoryProductsViewModel, category: String, repository: ProductRepository) {
        _viewModel = State(wrappedValue: viewModel)
        self.category = category
        self.repository = repository
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]


    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading products...")
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else {
                productGrid
            }
        }
        .task {
            await viewModel.fetchProducts()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "wifi.exclamationmark")
        } description:
        {
            Text(message)
        } actions: {
            Button("Retry") {
                Task {
                    await viewModel.fetchProducts()
                }
            }
        }
    }
    
    private var productGrid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                //Featured Products
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Top Rated Products")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.featuredProducts) { product in
                            productCard(product)
                        }
                    }
                }
                
                //Remaining Products
                VStack(alignment: .leading, spacing:12) {
                    Text("All Products")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.remainingProducts) { product in
                            productCard(product)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    
    private func productCard(_ product: Product) -> some View {
        NavigationLink {
            ProductDetailsView(viewModel: ProductDetailsViewModel(repository: repository, productID: product.id))
        } label: {
            VStack(alignment: .leading, spacing:8) {
                AsyncImage(url: URL(string:product.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 130)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(product.title)
                               .font(.headline)
                               .lineLimit(2)

                Text("$\(product.price, specifier: "%.2f")")
                               .font(.subheadline)
                               .fontWeight(.semibold)
                
                Label(String(format: "%.2f",product.rating), systemImage: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)

            }
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
    }
    
    
}
