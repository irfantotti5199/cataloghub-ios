//
//  ProductDTO.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import Foundation

struct ProductDTO: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: RatingDTO?
    
    func toDomain() -> Product {
        Product(id: id, title: title, price: price, description: description, category: category, imageURL: image, rating: rating?.rate ?? 0.0)
    }
    
}

struct RatingDTO: Decodable {
    let rate: Double
    let count: Int
}
