//
//  SearchView.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import SwiftUI

struct SearchView: View {
    
    @State private var viewModel: SearchViewModel
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Never>?
    
    private let repository:  ProductRepository
    
    
    init(viewModel: SearchViewModel, repository: ProductRepository) {
        _viewModel = State(wrappedValue: viewModel)
        self.repository = repository
    }
    
    private let columns = [
        GridItem(.flexible(), spacing:16),
        GridItem(.flexible(), spacing: 16)
    ]
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Searching products...")
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ContentUnavailableView("Search Products", systemImage: "magnifyingglass", description: Text("Enter a product name to search"))
                } else if viewModel.products.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    productGrid
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search products")
            .onChange(of: searchText) { _, newValue in
                
                searchTask?.cancel()
                searchTask = Task {
                    do {
                        try? await Task.sleep(for: .seconds(0.4))
                        guard !Task.isCancelled else {return}
                        await viewModel.searchProducts(query: newValue)
                    } catch is CancellationError {
                        // Previous search was cancelled
                    } catch {
                        // Handle unexpected errors if needed
                        print(error)
                    }
                }
            }
        }
    }
    
    private var productGrid: some View  {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.products) { product in
                    NavigationLink {
                        ProductDetailsView(viewModel: ProductDetailsViewModel(repository: repository, productID: product.id))
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
                        }
                        .foregroundStyle(.primary)
                        
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    
    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Search Failed", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Retry") {
                Task {
                    await viewModel.searchProducts(query: searchText)
                }
            }
        }
    }
}
