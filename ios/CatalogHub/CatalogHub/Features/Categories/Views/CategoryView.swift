//
//  CategoryView.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation
import SwiftUI

struct CategoryView: View {
    
    @State var viewModel: CategoryViewModel
    private let repository: ProductRepository
    
    init(viewModel: CategoryViewModel, repository: ProductRepository) {
        _viewModel = State(wrappedValue: viewModel)
        self.repository = repository
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading categories...")
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else {
                    categoryList
                }
            }
            .navigationTitle("Categories")
        }
        .task {
            await viewModel.fetchCategories()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Unable to Load Categories", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Retry") {
                Task {
                    await viewModel.fetchCategories()
                }
            }
        }
    }
    
    private var categoryList: some View {
        List(viewModel.categories, id: \.self) { category in
            NavigationLink {
                CategoryProductsView(
                    viewModel: CategoryProductsViewModel(
                        repository: repository, category: category
                    ), category: category, repository: repository
                )
            } label: {
                Text(category.capitalized)
                    .font(.headline)
                    .padding(.vertical, 8)
            }
        }
    }
}
