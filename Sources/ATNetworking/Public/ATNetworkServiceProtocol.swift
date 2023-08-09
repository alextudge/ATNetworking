//
//  ATNetworkService.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation
import Combine

public protocol ATNetworkServiceProtocol: AnyObject {
    /**
     Make a network call with a completion block.

     - Parameter endpoint: A case from an enum conforming to `ATEndpoint`.
     - Parameter type: A `Decodable` type to decode a successful response into.
     - Parameter completion: An escaping closure of type `Result<T, ATError>`
     */
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type, completion: @escaping (Result<T, ATError>) -> Void)
    func request(endpoint: ATEndpoint, completion: @escaping (Result<Data, ATError>) -> Void)
    
    /**
     Make a network call with a `Combine` publisher.

     - Parameter endpoint: A case from an enum conforming to `ATEndpoint`.
     - Parameter type: A `Decodable` type to decode a successful response into.
     - Returns: A publisher containing the decoded response or any errors.
     */
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type) -> AnyPublisher<T, ATError>
    func request(endpoint: ATEndpoint) -> AnyPublisher<Data, ATError>
    
    /**
     Make a network call with aync.

     - Parameter endpoint: A case from an enum conforming to `ATEndpoint`.
     - Parameter type: A `Decodable` type to decode a successful response into.
     
     - Throws: An `ATError` case representing the part of the operation that failed (networking, decoding etc).
     
     - Returns: The decoded object from a successful response.
     */
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type) async throws -> T
    func request(endpoint: ATEndpoint) async throws -> Data
}
