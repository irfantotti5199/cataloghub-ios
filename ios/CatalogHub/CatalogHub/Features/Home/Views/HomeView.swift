//
//  HomeView.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    private let repository: ProductRepository
    init(viewModel: HomeViewModel, repository: ProductRepository) {
        _viewModel = State(wrappedValue: viewModel)
        self.repository = repository
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Products...")
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else {
                    productContent
                }
            }
            .navigationTitle("CatalogHub")
            .searchable(
                text: .constant(""),
                prompt: "Search products"
            )
        }
        .task {
            await viewModel.fetchFeaturedProducts()
        }
    }
    
    private var productContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Featured Products")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.products) { product in
                        productCard(product)
                    }
                }
            }
            .padding()
        }
    }
    
    
    private func productCard(_ product: Product) -> some View {
        NavigationLink {
            ProductDetailsView(
                viewModel: ProductDetailsViewModel(
                    repository: repository, productID: product.id
                )
            )
        } label: {
            VStack(alignment: .leading, spacing: 8) {

                AsyncImage(url: URL(string: product.imageURL)) { image in
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

                Label(
                    String(format: "%.1f", product.rating),
                    systemImage: "star.fill"
                )
                .font(.caption)
                .foregroundStyle(.orange)
            }
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("home.product.\(product.id)")
    }

    
    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Retry") {
                Task {
                    await viewModel.fetchFeaturedProducts()
                }
            }
        }
    }
}


