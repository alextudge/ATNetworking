//
//  ATNetworkServiceTests.swift
//  
//
//  Created by Alex Tudge on 26/07/2023.
//

import XCTest
import Combine
@testable import ATNetworking

final class ATNetworkServiceTests: XCTestCase {
    
    var urlSessionMock: ATURLSessionMock!
    var sut: ATNetworkService!
    var anyCancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        urlSessionMock = ATURLSessionMock()
        sut = ATNetworkService(session: urlSessionMock, decoder: JSONDecoder())
    }
    
    override func tearDown() {
        super.tearDown()
        urlSessionMock = nil
        anyCancellables.removeAll()
        sut = nil
    }
}

// MARK: Async
extension ATNetworkServiceTests {
    func test_asyncData_networkError() async {
        urlSessionMock.error = .invalidUrl
        var returnedError: Error?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint)
        } catch {
            returnedError = error
        }
        XCTAssertNotNil(returnedError)
    }
    
    func test_asyncData_networkSuccess() async {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: Error?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint)
        } catch {
            returnedError = error
        }
        XCTAssertNil(returnedError)
    }
    
    func test_asyncData_statusCode_unauthorised() async {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 401
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint)
        } catch let error as ATError {
            returnedError = error
        } catch {
            return
        }
        XCTAssertEqual(returnedError, .unauthorised)
    }
    
    func test_asyncData_statusCode_unknown() async {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 1023
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint)
        } catch let error as ATError {
            returnedError = error
        } catch {
            return
        }
        XCTAssertEqual(returnedError, .unknown)
    }
}

// MARK: Async/Decode
extension ATNetworkServiceTests {
    func test_async_networkError() async {
        urlSessionMock.error = .invalidUrl
        var returnedError: Error?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint, type: String.self)
        } catch {
            returnedError = error
        }
        XCTAssertNotNil(returnedError)
    }
    
    func test_async_networkSuccess() async {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: Error?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint, type: String.self)
        } catch {
            returnedError = error
        }
        XCTAssertNil(returnedError)
    }
    
    func test_async_statusCode_unauthorised() async {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 401
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint, type: String.self)
        } catch let error as ATError {
            returnedError = error
        } catch {
            return
        }
        XCTAssertEqual(returnedError, .unauthorised)
    }
    
    func test_async_statusCode_unknown() async {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 1023
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint, type: String.self)
        } catch let error as ATError {
            returnedError = error
        } catch {
            return
        }
        XCTAssertEqual(returnedError, .unknown)
    }
    
    func test_async_decodeError() async {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        do {
            let _ = try await sut.request(endpoint: ATEndpointMock.endpoint, type: Int.self)
        } catch let error as ATError {
            returnedError = error
        } catch {
            return
        }
        XCTAssertEqual(returnedError, .decoding(message: "The data couldn’t be read because it isn’t in the correct format."))
    }
}

// MARK: Combine/Decode
extension ATNetworkServiceTests {
    func test_combine_networkError() {
        urlSessionMock.error = .invalidUrl
        var returnedError: Error?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: String.self)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let failure):
                    returnedError = failure
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(returnedError)
    }
    
    func test_combine_networkSuccess() {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: Error?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: String.self)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    expectation.fulfill()
                case .failure(let failure):
                    returnedError = failure
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNil(returnedError)
    }
    
    func test_combine_statusCode_unauthorised() {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 401
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: String.self)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let failure):
                    returnedError = failure
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .unauthorised)
    }
    
    func test_combine_statusCode_unknown() {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 1023
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: String.self)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let failure):
                    returnedError = failure
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .unknown)
    }
    
    func test_combine_decodeError() {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: Int.self)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let failure):
                    returnedError = failure
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .decoding(message: "The data couldn’t be read because it isn’t in the correct format."))
    }
}

// MARK: Combine
extension ATNetworkServiceTests {
    func test_combineData_networkError() {
        urlSessionMock.error = .invalidUrl
        var returnedError: Error?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let failure):
                    returnedError = failure
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(returnedError)
    }
    
    func test_combineData_networkSuccess() {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: Error?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    expectation.fulfill()
                case .failure(let failure):
                    returnedError = failure
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNil(returnedError)
    }
    
    func test_combineData_statusCode_unauthorised() {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 401
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let failure):
                    returnedError = failure
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .unauthorised)
    }
    
    func test_combineData_statusCode_unknown() {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 1023
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let failure):
                    returnedError = failure
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                return
            }).store(in: &anyCancellables)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .unknown)
    }
}

// MARK: Closure/Decode
extension ATNetworkServiceTests {
    func test_closure_networkError() {
        urlSessionMock.error = .invalidUrl
        var returnedError: Error?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: String.self) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(returnedError)
    }
    
    func test_closure_networkSuccess() {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: Error?
        let expectation = expectation(description: "No error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: String.self) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNil(returnedError)
    }
    
    func test_closure_statusCode_unauthorised() {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 401
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: String.self) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .unauthorised)
    }
    
    func test_closure_statusCode_unknown() {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 1023
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: String.self) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .unknown)
    }
    
    func test_closure_decodeError() {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint, type: Int.self) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .decoding(message: "The data couldn’t be read because it isn’t in the correct format."))
    }
}

// MARK: Closure
extension ATNetworkServiceTests {
    func test_closureData_networkError() {
        urlSessionMock.error = .invalidUrl
        var returnedError: Error?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(returnedError)
    }
    
    func test_closureData_networkSuccess() {
        urlSessionMock.error = nil
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: Error?
        let expectation = expectation(description: "No error returned")
        sut.request(endpoint: ATEndpointMock.endpoint) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNil(returnedError)
    }
    
    func test_closureData_statusCode_unauthorised() {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 401
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .unauthorised)
    }
    
    func test_closureData_statusCode_unknown() {
        urlSessionMock.error = nil
        urlSessionMock.statusCode = 1023
        urlSessionMock.returnedData = try? JSONEncoder().encode("string")
        var returnedError: ATError?
        let expectation = expectation(description: "Error returned")
        sut.request(endpoint: ATEndpointMock.endpoint) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                returnedError = failure
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(returnedError, .unknown)
    }
}
