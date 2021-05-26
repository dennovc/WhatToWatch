//
//  JSONResponseDecoderTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 18.04.2021.
//

import XCTest
@testable import WhatToWatch

final class JSONResponseDecoderTests: XCTestCase {

    // MARK: - Prepare

    private var sut: JSONResponseDecoder!

    override func setUp() {
        super.setUp()
        sut = JSONResponseDecoder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testDecodeValidJSONShouldReturnDecodedModel() {
        let validJSON = """
        {"name": "foo", "age": 1}
        """.data(using: .utf8)!

        let expectedModel = MockModel(name: "foo", age: 1)

        do {
            let decodedModel: MockModel = try sut.decode(validJSON)
            XCTAssertEqual(decodedModel, expectedModel)
        } catch {
            XCTFail("Failed decoding")
        }
    }

    func testDecodeInvalidJSONShouldThrowDecodingError() {
        let invalidJSON = "{}".data(using: .utf8)!

        do {
            let _: MockModel = try sut.decode(invalidJSON)
            XCTFail("Should not happen")
        } catch {
            if !(error is DecodingError) {
                XCTFail("Wrong error")
            }
        }
    }

}

// MARK: - Mock Model

private struct MockModel: Decodable, Equatable {

    let name: String
    let age: Int

}
