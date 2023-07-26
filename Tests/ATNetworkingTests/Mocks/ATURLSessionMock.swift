//
//  ATURLSessionMock.swift
//  
//
//  Created by Alex Tudge on 26/07/2023.
//

import Foundation
@testable import ATNetworking

class ATURLSessionMock: ATURLSession {
    
    var error: ATError?
    var returnedData: Data?
    var statusCode = 200
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let returnedData {
            let urlResponse = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: [:])!
            return (returnedData, urlResponse as URLResponse)
        } else {
            throw error ?? .unknown
        }
    }
}
