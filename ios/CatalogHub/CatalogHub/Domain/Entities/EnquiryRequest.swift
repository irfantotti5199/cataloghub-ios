//
//  EnquiryRequest.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation

struct EnquiryRequest: Encodable {
    let name: String
    let email: String
    let phone: String
    let message: String
}


struct EnquiryResponse: Decodable {
    let status: String
    let message: String
}
