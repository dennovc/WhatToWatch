//
//  RawDataResponseDecoderTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 23.04.2021.
//

import XCTest
@testable import WhatToWatch

final class RawDataResponseDecoderTests: XCTestCase {

    // MARK: - Prepare

    private var sut: RawDataResponseDecoder!

    override func setUp() {
        super.setUp()
        sut = RawDataResponseDecoder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testDecodeDataShouldReturnDecodedData() {
        let expectedData = "Foo".data(using: .utf8)!

        do {
            let data: Data = try sut.decode(expectedData)
            XCTAssertEqual(data, expectedData)
        } catch {
            XCTFail("Failed decoding")
        }
    }

    func testDecodeNoDataShouldThrowDecodingError() {
        let data = "Foo".data(using: .utf8)!

        do {
            let _: Int = try sut.decode(data)
            XCTFail("Should not happen")
        } catch {
            if !(error is DecodingError) {
                XCTFail("Wrong error")
            }
        }
    }

}
