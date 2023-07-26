//
//  ATNetworkService.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation

public protocol ATNetworkServiceProtocol: AnyObject {
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type, completion: @escaping (Result<T, ATError>) -> Void)
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type) async throws -> T
}
