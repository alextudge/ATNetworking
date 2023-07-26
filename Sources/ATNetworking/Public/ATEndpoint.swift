//
//  ATEndpoint.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation

protocol ATEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: ATHTTPMethod { get }
    var headers: [String: String] { get }
    var queries: [URLQueryItem] { get }
    var parameters: Data? { get }
}

extension ATEndpoint {
    func urlComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        if !queries.isEmpty {
            components.queryItems = queries
        }
        return components
    }
    
    func urlRequest() -> URLRequest? {
        guard let url = urlComponents().url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = parameters
        headers.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        return urlRequest
    }
}
