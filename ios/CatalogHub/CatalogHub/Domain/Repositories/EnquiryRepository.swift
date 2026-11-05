//
//  EnquiryRepository.swift
//  CatalogHub
//
//  Created by Irfan on 04/11/26.
//

import Foundation
protocol EnquiryRepository {
    func submitEnquiry(_ enquiry: EnquiryRequest) async throws -> EnquiryResponse
}
