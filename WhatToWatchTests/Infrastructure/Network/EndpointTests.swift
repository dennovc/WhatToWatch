//
//  EndpointTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 20.04.2021.
//

import XCTest
@testable import WhatToWatch

final class EndpointTests: XCTestCase {

    // MARK: - Prepare

    private var sut: Endpoint<MockModel>!

    override func setUp() {
        super.setUp()

        sut = Endpoint(path: "path",
                       method: .get,
                       queryParameters: ["Foo": 1],
                       responseDecoder: MockResponseDecoder())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testInitShouldSetProperties() {
        XCTAssertEqual(sut.path, "path")
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.queryParameters as? [String: Int], ["Foo": 1])
        XCTAssertTrue(sut.responseDecoder is MockResponseDecoder)
        XCTAssertTrue(Endpoint<MockModel>.self.Response == MockModel.self)
    }

    func testURLValidURLComponentsShouldReturnURL() {
        let validConfig = MockNetworkConfig(baseURL: "scheme://host", queryParameters: ["Bar": 2])

        do {
            let url = try sut.url(with: validConfig)
            let urlString = url.absoluteString

            XCTAssertTrue(urlString.hasPrefix("scheme://host/path?"))
            XCTAssertTrue(urlString.contains("Foo=1"))
            XCTAssertTrue(urlString.contains("Bar=2"))
        } catch {
            XCTFail("Failed to generate URL")
        }
    }

    func testURLInvalidURLComponentsShouldThrowComponentsError() {
        let invalidConfig = MockNetworkConfig(baseURL: "invalid url", queryParameters: [:])

        do {
            _ = try sut.url(with: invalidConfig)
            XCTFail("Should not happen")
        } catch {
            XCTAssertEqual(error.localizedDescription,
                           RequestGenerationError.components.localizedDescription)
        }
    }

    func testURLRequestValidURLComponentsShouldReturnURLRequest() {
        let validConfig = MockNetworkConfig(baseURL: "scheme://host", queryParameters: ["Bar": 2])

        do {
            let urlRequest = try sut.urlRequest(with: validConfig)
            let urlString = urlRequest.url?.absoluteString ?? ""

            XCTAssertTrue(urlString.hasPrefix("scheme://host/path?"))
            XCTAssertTrue(urlString.contains("Foo=1"))
            XCTAssertTrue(urlString.contains("Bar=2"))
            XCTAssertEqual(urlRequest.httpMethod, "GET")
        } catch {
            XCTFail("Failed to generate URLRequest")
        }
    }

    func testURLRequestInvalidURLComponentsShouldThrowComponentsError() {
        let invalidConfig = MockNetworkConfig(baseURL: "invalid url", queryParameters: [:])

        do {
            _ = try sut.urlRequest(with: invalidConfig)
            XCTFail("Should not happen")
        } catch {
            XCTAssertEqual(error.localizedDescription,
                           RequestGenerationError.components.localizedDescription)
        }
    }

}

// MARK: - Mock Network Config

private struct MockNetworkConfig: NetworkConfigurable {

    let baseURL: String
    let queryParameters: [String: Any]

}

// MARK: - Mock Model

private struct MockModel {}

// MARK: - Mock Response Decoder

private struct MockResponseDecoder: ResponseDecoder {

    func decode<T: Decodable>(_ data: Data) -> T {
        preconditionFailure("Should not happen")
    }

}
