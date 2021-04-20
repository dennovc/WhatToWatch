//
//  DefaultNetworkSessionManagerTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 20.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultNetworkSessionManagerTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultNetworkSessionManager!
    private var urlSession: MockURLSession!

    override func setUp() {
        super.setUp()

        urlSession = MockURLSession()
        sut = DefaultNetworkSessionManager(session: urlSession)
    }

    override func tearDown() {
        sut = nil
        urlSession = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testRequestShouldCallCompletionHandler() {
        let expectation = self.expectation(description: "Should call a completion handler")
        let url = URL(string: "scheme://host")!
        let request = URLRequest(url: url)

        let expectedData = "Foo".data(using: .utf8)
        urlSession.data = expectedData

        _ = sut.request(request) { data, _, _ in
            XCTAssertEqual(data, expectedData)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(urlSession.receivedRequest, request)
    }

}

// MARK: - Test Doubles

private extension DefaultNetworkSessionManagerTests {

    // MARK: - Mock URL Session Data Task

    final class MockURLSessionDataTask: URLSessionDataTask {

        private let closure: () -> Void

        init(closure: @escaping () -> Void) {
            self.closure = closure
        }

        override func resume() {
            closure()
        }

    }

    // MARK: - Mock URL Session

    final class MockURLSession: URLSession {

        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

        var data: Data?
        private(set) var receivedRequest: URLRequest?

        override init() {}

        override func dataTask(with request: URLRequest,
                               completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
            let data = self.data
            receivedRequest = request

            return MockURLSessionDataTask {
                completionHandler(data, nil, nil)
            }
        }

    }

}
