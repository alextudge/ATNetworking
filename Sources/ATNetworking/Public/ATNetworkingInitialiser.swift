//
//  ATNetworkingInitialiser.swift
//
//
//  Created by Alex Tudge on 27/07/2023.
//

import Foundation

public class ATNetworkingInitialiser {
    
    public init() {}
    
    public func generateNetworkService(session: URLSession) -> ATNetworkServiceProtocol {
        let networkService = ATNetworkService(session: session)
        return networkService
    }
}
