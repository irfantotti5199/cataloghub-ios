//
//  APIClient.swift
//  CatalogHub
//
//  Created by Irfan on 03/11/26.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
}


struct APIClient {
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func get<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: baseURL)?.absoluteURL else {
            throw APIError.invalidResponse
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue( "application/json", forHTTPHeaderField: "Accept")
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    
    func post<Body: Encodable, Response: Decodable>(_ endpoint: String, body: Body) async throws -> Response {
        guard let url = URL(string: endpoint, relativeTo: baseURL)?.absoluteURL else {
            throw APIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw APIError.httpError(statusCode: response.statusCode)
        }
        return try JSONDecoder().decode(Response.self,from: data)
    }
}
