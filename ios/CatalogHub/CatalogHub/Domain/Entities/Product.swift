//
//  Product.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import Foundation

struct Product: Equatable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let imageURL: String
    let rating: Double
}
