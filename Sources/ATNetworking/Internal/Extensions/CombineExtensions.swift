//
//  CombineExtensions.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Combine

extension Future where Failure == ATError {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch let error as ATError {
                    promise(.failure(error))
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }
    }
}
