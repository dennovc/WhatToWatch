//
//  DefaultNetworkServiceTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 18.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultNetworkServiceTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultNetworkService!
    private var config: MockNetworkConfig!
    private var sessionManager: MockNetworkSessionManager!

    override func setUp() {
        super.setUp()

        config = MockNetworkConfig()
        sessionManager = MockNetworkSessionManager()
        sut = DefaultNetworkService(config: config, sessionManager: sessionManager)
    }

    override func tearDown() {
        sut = nil
        config = nil
        sessionManager = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testRequestInvalidEndpointShouldThrowURLGenerationError() {
        let expectation = self.expectation(description: "Should throw urlGeneration error")
        let invalidEndpoint = MockEndpoint(path: "invalid path")

        let request = sut.request(with: invalidEndpoint) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case NetworkError.urlGeneration = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertNil(request)
    }

    func testRequestSuccessShouldReturnData() {
        let expectation = self.expectation(description: "Should return data")
        let endpoint = MockEndpoint(path: "path")

        let expectedData = "Foo".data(using: .utf8)
        sessionManager.resultForCompletion = (expectedData, nil, nil)

        let request = sut.request(with: endpoint) { result in
            do {
                let data = try result.get()
                XCTAssertEqual(data, expectedData)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to request")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(request)
    }

    func testRequestReceivedErrorFromServerShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")
        let endpoint = MockEndpoint(path: "path")
        let url = URL(string: "scheme://host/path")!

        let expectedData = "Foo".data(using: .utf8)
        let response = HTTPURLResponse(url: url, statusCode: 1, httpVersion: nil, headerFields: nil)
        let error: MockError = .error
        sessionManager.resultForCompletion = (expectedData, response, error)

        let request = sut.request(with: endpoint) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case NetworkError.error(let statusCode, let data) = error {
                    XCTAssertEqual(statusCode, 1)
                    XCTAssertEqual(data, expectedData)
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(request)
    }

    func testRequestReceivedUnknownErrorShouldThrowGenericError() {
        let expectation = self.expectation(description: "Should throw generic error")
        let endpoint = MockEndpoint(path: "path")

        let error: MockError = .error
        sessionManager.resultForCompletion = (nil, nil, error)

        let request = sut.request(with: endpoint) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case NetworkError.generic(let error) = error {
                    XCTAssertTrue(error is MockError)
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(request)
    }

    func testRequestReceivedNotConnectedToInternetErrorShouldThrowNotConnectedError() {
        let expectation = self.expectation(description: "Should throw notConnected error")
        let endpoint = MockEndpoint(path: "path")

        let error = URLError(.notConnectedToInternet)
        sessionManager.resultForCompletion = (nil, nil, error)

        let request = sut.request(with: endpoint) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case NetworkError.notConnected = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(request)
    }

    func testRequestReceivedCancelledErrorShouldThrowCancelledError() {
        let expectation = self.expectation(description: "Should throw cancelled error")
        let endpoint = MockEndpoint(path: "path")
        
        let error = URLError(.cancelled)
        sessionManager.resultForCompletion = (nil, nil, error)

        let request = sut.request(with: endpoint) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case NetworkError.cancelled = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(request)
    }

}

// MARK: - Test Doubles

private extension DefaultNetworkServiceTests {

    // MARK: - Mock Error

    enum MockError: Error {

        case error

    }

    // MARK: - Mock Endpoint

    struct MockEndpoint: Requestable {

        let path: String
        let method: HTTPMethod = .get
        let queryParameters: [String: Any] = [:]

    }

    // MARK: - Mock Network Config

    struct MockNetworkConfig: NetworkConfigurable {

        let baseURL = "scheme://host"
        let queryParameters: [String: Any] = [:]

    }

    // MARK: - Mock Request

    final class MockRequest: Cancellable {

        func cancel() {}

    }

    // MARK: - Mock Network Session Manager

    final class MockNetworkSessionManager: NetworkSessionManager {

        var resultForCompletion: (Data?, URLResponse?, Error?)

        func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> Cancellable {
            let (data, response, error) = resultForCompletion
            completion(data, response, error)

            return MockRequest()
        }

    }

}
