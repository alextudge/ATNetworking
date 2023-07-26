//
//  ATEndpointTests.swift
//  
//
//  Created by Alex Tudge on 26/07/2023.
//

import XCTest
@testable import ATNetworking

final class ATEndpointTests: XCTestCase {
    
    var sut: ATEndpointMock!
    
    override func setUp() {
        super.setUp()
        sut = .endpoint
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}

extension ATEndpointTests {
    func test_componentsSetCorrectly() {
        let components = sut.urlComponents()
        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "endpoint-host")
        XCTAssertEqual(components.path, "/endpoint-path")
        XCTAssertEqual(components.query, "query-name=query-value")
    }
    
    func test_requestSetCorrectly() {
        let request = sut.urlRequest()
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(request?.httpBody, Data([1, 2, 3]))
        XCTAssertEqual(request?.value(forHTTPHeaderField: "header-key"), "header-value")
    }
}
