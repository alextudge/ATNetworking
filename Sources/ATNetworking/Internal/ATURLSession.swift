//
//  ATURLSession.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation

protocol ATURLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: ATURLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request, delegate: nil)
    }
}
