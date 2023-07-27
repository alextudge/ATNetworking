//
//  ATNetworkService.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation
import Combine

class ATNetworkService: ATNetworkServiceProtocol {
    
    private let session: ATURLSession
    
    init(session: ATURLSession) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type, completion: @escaping (Result<T, ATError>) -> Void) {
        Task {
            do {
                let data = try await makeRequest(endpoint: endpoint)
                let object = try decode(data: data, type: type)
                completion(.success(object))
            } catch let error as ATError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }
    }
    
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type) -> AnyPublisher<T, ATError> {
        Future {
            return try await self.request(endpoint: endpoint, type: type)
        }.eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type) async throws -> T {
        do {
            let data = try await makeRequest(endpoint: endpoint)
            return try decode(data: data, type: type)
        } catch {
            throw error
        }
    }
}

private extension ATNetworkService {
    func makeRequest(endpoint: ATEndpoint) async throws -> Data {
        guard let request = endpoint.urlRequest() else {
            throw ATError.invalidUrl
        }
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw ATError.invalidUrl
            }
            try processStatusCode(response.statusCode)
            return data
        } catch {
            throw error
        }
    }
    
    func decode<T: Decodable>(data: Data, type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw ATError.decoding(message: error.localizedDescription)
        }
    }
    
    func processStatusCode(_ code: Int) throws {
        switch code {
        case 200...299:
            break
        case 401:
            throw ATError.unauthorised
        default:
            throw ATError.unknown
        }
    }
}
