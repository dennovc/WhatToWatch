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
                XCTAssertEqual(error.localizedDescription,
                               DataTransferError.networkFailure(.notConnected).localizedDescription)
                expectation.fulfill()
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
                XCTAssertEqual(error.localizedDescription,
                               DataTransferError.noResponse.localizedDescription)
                expectation.fulfill()
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
                XCTAssertEqual(error.localizedDescription,
                               DataTransferError.parsing(MockError.error).localizedDescription)
                expectation.fulfill()
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

// MARK: - Mock Error

private enum MockError: Error {

    case error

}

// MARK: - Mock Model

private struct MockModel: Decodable {

    let data: String

}

// MARK: - Mock Endpoint

private struct MockEndpoint: ResponseRequestable {

    typealias Response = MockModel

    let responseDecoder: ResponseDecoder

    let path = "path"
    let method: HTTPMethod = .get
    let queryParameters: [String: Any] = [:]

}

// MARK: - Mock Response Decoder

private final class MockResponseDecoder: ResponseDecoder {

    var dataIsValid = true

    func decode<T: Decodable>(_ data: Data) throws -> T {
        guard dataIsValid else { throw MockError.error }

        let dataString = String(data: data, encoding: .utf8)!
        return MockModel(data: dataString) as! T
    }

}

// MARK: - Mock Network Service

private final class MockNetworkService: NetworkService {

    var result: Result<Data?, NetworkError> = .success(nil)

    func request(with endpoint: Requestable, completion: @escaping CompletionHandler) -> Cancellable? {
        completion(result)
        return nil
    }

}
