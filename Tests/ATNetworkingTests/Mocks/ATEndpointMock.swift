//
//  ATEndpointMock.swift
//  
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation
@testable import ATNetworking

enum ATEndpointMock: ATEndpoint {
    
    case endpoint
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "endpoint-host"
    }
    
    var path: String {
        switch self {
        case .endpoint:
            return "/endpoint-path"
        }
    }
    
    var method: ATNetworking.ATHTTPMethod {
        switch self {
        case .endpoint:
            return .get
        }
    }
    
    var headers: [String : String] {
        ["header-key": "header-value"]
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .endpoint:
            return [URLQueryItem(name: "query-name", value: "query-value")]
        }
    }
    
    var parameters: Data? {
        switch self {
        case .endpoint:
            return Data([1, 2, 3])
        }
    }
}
