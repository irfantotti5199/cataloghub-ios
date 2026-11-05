//
//  CatalogHubApp.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import SwiftUI

@main
struct CatalogHubApp: App {
    private let container: DependencyContainer
    
    init() {
        let baseURL = URL(string: "http://127.0.0.1:3000/")!
        container = DependencyContainer(baseURL: baseURL)
    }
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(viewModel: HomeViewModel(repository: container.productRepository), repository: container.productRepository)
                    .tabItem {
                        Label("Home", systemImage:"house")
                    }
                
                CategoryView(viewModel: CategoryViewModel(repository: container.productRepository), repository: container.productRepository)
                    .tabItem {
                        Label("Categories", systemImage:"square.grid.2x2")
                    }
                
                SearchView(viewModel: SearchViewModel(repository: container.productRepository), repository: container.productRepository)
                    .tabItem {
                        Label("Search", systemImage:"magnifyingglass")
                    }
                
                EnquiryView(viewModel: EnquiryViewModel(repository: container.enquiryRepository))
                    .tabItem {
                        Label("Enquiry", systemImage: "envelope")
                    }
            }
            
        }
    }
}
