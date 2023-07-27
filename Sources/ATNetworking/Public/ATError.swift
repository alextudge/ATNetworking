//
//  ATError.swift
//
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation

/// Error types returned by the network service
public enum ATError: Error, Equatable {
    case invalidUrl
    
    /// Represents a network response with code 401
    case unauthorised
    
    /// Represents an unhandled error code. Only codes 401 and 200-299 are handled.
    case unknown
    
    /// Represents an error with decoding. The associated message is the one returned from the `JSONDecoder`
    case decoding(message: String?)
}
