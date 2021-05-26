//
//  DefaultImageRepositoryTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 23.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultImageRepositoryTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultImageRepository!
    private var dataTransferService: MockDataTransferService!
    private var cacheService: MockCacheService!

    override func setUp() {
        super.setUp()

        dataTransferService = MockDataTransferService()
        cacheService = MockCacheService()
        sut = DefaultImageRepository(dataTransferService: dataTransferService, cacheService: cacheService)
    }

    override func tearDown() {
        sut = nil
        dataTransferService = nil
        cacheService = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testFetchImageSuccessShouldSaveResultToCacheAndReturnImageData() {
        let expectation = self.expectation(description: "Should return image data")
        let expectedImageData = "image data".data(using: .utf8)

        dataTransferService.result = expectedImageData

        _ = sut.fetchImage(path: "path", width: 1) { result in
            do {
                let imageData = try result.get()
                XCTAssertEqual(imageData, expectedImageData)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch image")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(cacheService.container, ["path": expectedImageData])
    }

    func testFetchImageFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchImage(path: "path", width: 1) { result in
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

    func testFetchImageFromCacheShouldReturnImageData() {
        let expectation = self.expectation(description: "Should return image data")
        let expectedImageData = "image data".data(using: .utf8)

        cacheService["path"] = expectedImageData

        _ = sut.fetchImage(path: "path", width: 1) { result in
            do {
                let imageData = try result.get()
                XCTAssertEqual(imageData, expectedImageData)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch image")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(cacheService.container, ["path": expectedImageData])
    }

}

// MARK: - Mock Cache Service

private final class MockCacheService: CacheService {

    typealias Key = String
    typealias Value = Data

    private(set) var container = [Key: Value]()

    func insert(_ value: Value, forKey key: Key) {
        container[key] = value
    }

    func value(forKey key: Key) -> Value? {
        return container[key]
    }

    func removeValue(forKey key: Key) {
        container[key] = nil
    }

    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }

}

// MARK: - Mock Data Transfer Service

private final class MockDataTransferService: DataTransferService {

    var result: Data?

    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                       completion: @escaping CompletionHandler<T>) -> Cancellable?
                                                       where E.Response == T {
        if let result = result {
            completion(.success(result as! T))
        } else {
            completion(.failure(.noResponse))
        }

        return nil
    }

}
