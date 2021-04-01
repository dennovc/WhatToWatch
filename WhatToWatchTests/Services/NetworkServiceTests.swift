//
//  NetworkServiceTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 23.03.2021.
//

import XCTest
@testable import WhatToWatch

final class NetworkServiceTests: XCTestCase {

    // MARK: - Prepare

    private var session: MockURLSession!
    private var sut: NetworkService!

    private var expectation: XCTestExpectation!
    private var request: StubNetworkRequest!
    private var response: Result<Movie, NetworkError>!
    private var completion: ((Result<Movie, NetworkError>) -> Void)!
    private var httpResponse: HTTPURLResponse!

    override func setUp() {
        super.setUp()

        session = MockURLSession()
        sut = NetworkService(session: session)

        expectation = XCTestExpectation()
        request = StubNetworkRequest()
        response = nil

        completion = { [unowned self] in
            self.response = $0
            self.expectation.fulfill()
        }

        httpResponse = HTTPURLResponse(
            url: URL(string: "Foo")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
    }

    override func tearDown() {
        sut = nil
        session = nil

        expectation = nil
        request = nil
        response = nil
        completion = nil
        httpResponse = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testNetworkServiceConformsToNetworkServiceProtocol() {
        XCTAssertTrue((sut as AnyObject) is NetworkServiceProtocol)
    }

    func testRequestAndDecodeMakesURLFromRequest() {
        sut.requestAndDecode(request, completion: completion)

        XCTAssertNotNil(session.receivedURL)
        XCTAssertEqual(session.receivedURL!.absoluteString, "scheme://host/path?name=value")
    }

    func testRequestAndDecodeCallsResumeForDataTask() {
        sut.requestAndDecode(request, completion: completion)
        XCTAssertTrue(session.dataTask.didResume)
    }

    func testRequestAndDecodeReturnsSuccessWhenReceivedData() {
        let json = """
            {"id": 0, "title": "Foo"}
            """
        let movie = Movie(id: 0, title: "Foo")

        sut.requestAndDecode(request, completion: completion)
        session.receivedCompletion!(json.data(using: .utf8), httpResponse, nil)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response, .success(movie))
    }

    func testRequestAndDecodeReturnsFailureWhenReceivedError() {
        sut.requestAndDecode(request, completion: completion)
        session.receivedCompletion!(nil, nil, NetworkError.apiError)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response, .failure(.apiError))
    }

    func testRequestAndDecodeReturnsFailureWhenNoData() {
        sut.requestAndDecode(request, completion: completion)
        session.receivedCompletion!(nil, httpResponse, nil)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response, .failure(.noData))
    }

    func testRequestAndDecodeReturnsFailureWhenReceivedInvalidResponse() {
        sut.requestAndDecode(request, completion: completion)
        session.receivedCompletion!(nil, nil, nil)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response, .failure(.invalidResponse))
    }

    func testRequestAndDecodeReturnsFailureWhenFailedToDecodeData() {
        let data = "Foo".data(using: .utf8)

        sut.requestAndDecode(request, completion: completion)
        session.receivedCompletion!(data, httpResponse, nil)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response, .failure(.serializationError))
    }

    func testRequestAndDecodeReturnsFailureWhenInvalidRequest() {
        let invalidRequest = InvalidNetworkRequest()

        sut.requestAndDecode(invalidRequest, completion: completion)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response, .failure(.invalidEndpoint))
    }

}

// MARK: - Stubs

extension NetworkServiceTests {

    // MARK: - Stub Network Request

    private final class StubNetworkRequest: NetworkRequestProtocol {

        var scheme = "scheme"
        var host = "host"
        var path = "/path"
        var parameters = ["name": "value"]

    }

    // MARK: - Invalid Network Request

    private final class InvalidNetworkRequest: NetworkRequestProtocol {

        var scheme = "scheme"
        var host = "host"
        var path = "path"
        var parameters = ["name": "value"]

    }

}
