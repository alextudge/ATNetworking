//
//  ATNetworkingInitialiser.swift
//
//
//  Created by Alex Tudge on 27/07/2023.
//

import Foundation

/**
 An object used for initialising a network service instance with a URLSession. Optionally pass in a JSON decoder with custom settings.
 
 This object is just a wrapper to avoid exposing implementation details publically.
 
 - Parameter session: A URLSession.
 - Parameter decoder: A custom decoder for specific use cases and server setups
 
     let networkService = ATNetworkingInitialiser().generateNetworkService(session: URLSession.shared)
 
 */
public final class ATNetworkingInitialiser {
    
    public init() {}
    
    public func generateNetworkService(session: URLSession,
                                       decoder: JSONDecoder = JSONDecoder()) -> ATNetworkServiceProtocol {
        let networkService = ATNetworkService(session: session)
        return networkService
    }
}
