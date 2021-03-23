//
//  NetworkManagerTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 23.03.2021.
//

import XCTest
@testable import WhatToWatch

final class NetworkManagerTests: XCTestCase {

    // MARK: - Prepare

    private var session: MockURLSession!
    private var router: MockNetworkRouter!
    private var sut: NetworkManager!

    override func setUp() {
        super.setUp()

        session = MockURLSession()
        router = MockNetworkRouter()
        sut = NetworkManager(session: session)
    }

    override func tearDown() {
        sut = nil
        session = nil
        router = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testNetworkManagerConformsToNetworkManagerProtocol() {
        XCTAssertTrue((sut as AnyObject) is NetworkManagerProtocol)
    }

    func testRequestMakesURLFromRouter() {
        sut.request(router: router) { _ in }

        XCTAssertNotNil(session.url)
        XCTAssertEqual(session.url!.absoluteString, "scheme://host/path?name=value")
    }

    func testRequestCallsResumeForDataTask() {
        sut.request(router: router) { _ in }
        XCTAssertTrue(session.dataTask.didResume)
    }

    func testRequestReturnsSuccess() {
        let data = Data("Foo".utf8)
        let expectation = XCTestExpectation()
        var result: Result<Data, Error>?

        sut.request(router: router) { res in
            result = res
            expectation.fulfill()
        }

        session.completionHandler!(data, nil, nil)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(try result!.get(), data)
    }

    func testRequestReturnsFailureWhenError() {
        let error = NSError()
        let expectation = XCTestExpectation()
        var result: Result<Data, Error>?

        sut.request(router: router) { res in
            result = res
            expectation.fulfill()
        }

        session.completionHandler!(nil, nil, error)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try result!.get())
    }
}

// MARK: - Mock Classes

extension NetworkManagerTests {

    // MARK: - Mock URL Session

    private final class MockURLSession: URLSessionProtocol {

        // MARK: - Properties

        private(set) var url: URL?
        let dataTask = MockURLSessionDataTask()
        var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

        // MARK: - Methods

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            
            return dataTask
        }

    }

    // MARK: - Mock URL Session Data Task

    private final class MockURLSessionDataTask: URLSessionDataTask {

        // MARK: - Properties

        private(set) var didResume = false

        // MARK: - Life Cycle

        override init() {}

        // MARK: - Methods

        override func resume() {
            didResume = true
        }
    }

    // MARK: - Mock Network Router

    private final class MockNetworkRouter: NetworkRouterProtocol {

        var scheme: String = "scheme"
        var host: String = "host"
        var path: String = "/path"
        var parameters: [URLQueryItem] = [URLQueryItem(name: "name", value: "value")]

    }

}
