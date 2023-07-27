//
//  ATNetworkingInitialiser.swift
//
//
//  Created by Alex Tudge on 27/07/2023.
//

import Foundation

/**
 An object used for initialising a network service instance with a URLSession.
 
 This object is just a wrapper to avoid exposing implementation details publically.
 
     let networkService = ATNetworkingInitialiser().generateNetworkService(session: URLSession.shared)
 
 */
public class ATNetworkingInitialiser {
    
    public init() {}
    
    public func generateNetworkService(session: URLSession) -> ATNetworkServiceProtocol {
        let networkService = ATNetworkService(session: session)
        return networkService
    }
}
