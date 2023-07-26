//
//  ATNetworkService.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation

class ATNetworkService: ATNetworkServiceProtocol {
    func request<T: Decodable>(endpoint: ATEndpoint, type: T.Type, completion: @escaping (Result<T, ATError>) -> Void) {
        Task {
            do {
                let data = try await makeRequest(endpoint: endpoint)
                let object = try decode(data: data, type: type)
                completion(.success(object))
            } catch let error as ATError {
                completion(.failure(error))
            } catch is DecodingError {
                completion(.failure(.invalidUrl))
            } catch {
                completion(.failure(.invalidUrl))
            }
        }
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
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw ATError.invalidUrl
            }
            switch response.statusCode {
            case 200...299:
//                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
//                    return .failure(.decode)
//                }
                return data
            case 401:
                throw ATError.invalidUrl
//                return .failure(.unauthorized)
            default:
                throw ATError.invalidUrl
//                return .failure(.unexpectedStatusCode)
            }
        } catch {
            throw ATError.invalidUrl
        }
    }
    
    func decode<T: Decodable>(data: Data, type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
}
