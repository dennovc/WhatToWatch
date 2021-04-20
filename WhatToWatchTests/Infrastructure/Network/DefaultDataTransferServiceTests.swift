//
//  DefaultDataTransferServiceTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 20.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultDataTransferServiceTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultDataTransferService!
    private var networkService: MockNetworkService!

    override func setUp() {
        super.setUp()

        networkService = MockNetworkService()
        sut = DefaultDataTransferService(networkService: networkService)
    }

    override func tearDown() {
        sut = nil
        networkService = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testRequestNetworkServiceReturnedErrorShouldThrowNetworkFailureError() {
        let expectation = self.expectation(description: "Should throw networkFailure error")
        let responseDecoder = MockResponseDecoder()
        let endpoint = MockEndpoint(responseDecoder: responseDecoder)

        networkService.result = .failure(.notConnected)

        _ = sut.request(with: endpoint) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case DataTransferError.networkFailure(NetworkError.notConnected) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testRequestNoDataShouldThrowNoResponseError() {
        let expectation = self.expectation(description: "Should throw noResponse error")
        let responseDecoder = MockResponseDecoder()
        let endpoint = MockEndpoint(responseDecoder: responseDecoder)

        _ = sut.request(with: endpoint) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case DataTransferError.noResponse = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testRequestFailedDecodingShouldThrowParsingError() {
        let expectation = self.expectation(description: "Should throw parsing error")
        let responseDecoder = MockResponseDecoder()
        let endpoint = MockEndpoint(responseDecoder: responseDecoder)

        responseDecoder.dataIsValid = false
        networkService.result = .success("Foo".data(using: .utf8))

        _ = sut.request(with: endpoint) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case DataTransferError.parsing(MockError.error) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testRequestSuccessShouldReturnDecodedModel() {
        let expectation = self.expectation(description: "Should return decoded model")
        let responseDecoder = MockResponseDecoder()
        let endpoint = MockEndpoint(responseDecoder: responseDecoder)

        networkService.result = .success("Foo".data(using: .utf8))

        _ = sut.request(with: endpoint) { result in
            do {
                let decodedModel = try result.get()
                XCTAssertEqual(decodedModel.data, "Foo")
                expectation.fulfill()
            } catch {
                XCTFail("Failed to request")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

}

// MARK: - Test Doubles

private extension DefaultDataTransferServiceTests {

    // MARK: - Mock Error

    enum MockError: Error {

        case error

    }

    // MARK: - Mock Model

    struct MockModel: Decodable {

        let data: String

    }

    // MARK: - Mock Endpoint

    struct MockEndpoint: ResponseRequestable {

        typealias Response = MockModel

        let responseDecoder: ResponseDecoder

        let path = "path"
        let method: HTTPMethod = .get
        let queryParameters: [String : Any] = [:]

    }

    // MARK: - Mock Response Decoder

    final class MockResponseDecoder: ResponseDecoder {

        var dataIsValid = true

        func decode<T: Decodable>(_ data: Data) throws -> T {
            guard dataIsValid else { throw MockError.error }

            let dataString = String(data: data, encoding: .utf8)!
            return MockModel(data: dataString) as! T
        }

    }

    // MARK: - Mock Network Service

    final class MockNetworkService: NetworkService {

        var result: Result<Data?, NetworkError> = .success(nil)

        func request(with endpoint: Requestable, completion: @escaping CompletionHandler) -> Cancellable? {
            completion(result)
            return nil
        }

    }

}
