//
//  ATHTTPMethodTests.swift
//  
//
//  Created by Alex Tudge on 26/07/2023.
//

import XCTest
@testable import ATNetworking

final class ATHTTPMethodTests: XCTestCase {
    func test_rawValues() {
        XCTAssertEqual(ATHTTPMethod.delete.rawValue, "DELETE")
        XCTAssertEqual(ATHTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(ATHTTPMethod.patch.rawValue, "PATCH")
        XCTAssertEqual(ATHTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(ATHTTPMethod.put.rawValue, "PUT")
    }
    
    func test_functionValues() {
        XCTAssertEqual(ATHTTPMethod.delete(), "DELETE")
        XCTAssertEqual(ATHTTPMethod.get(), "GET")
        XCTAssertEqual(ATHTTPMethod.patch(), "PATCH")
        XCTAssertEqual(ATHTTPMethod.post(), "POST")
        XCTAssertEqual(ATHTTPMethod.put(), "PUT")
    }
}
