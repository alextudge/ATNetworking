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
    var data: Data?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let data {
            let urlResponse = URLResponse(url: request.url!, mimeType: nil, expectedContentLength: 10, textEncodingName: nil)
            return (data, urlResponse)
        } else {
            throw error ?? .unknown
        }
    }
}
