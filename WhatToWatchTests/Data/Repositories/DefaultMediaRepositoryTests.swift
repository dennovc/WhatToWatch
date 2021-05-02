//
//  DefaultMediaRepositoryTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 23.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultMediaRepositoryTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultMediaRepository!
    private var dataTransferService: MockDataTransferService!
    private var cacheService: MockCacheService!

    private let mediaDTO: MediaDTO = .movie(.init(id: 1,
                                                  title: "Foo",
                                                  overview: "Bar",
                                                  releaseDate: nil,
                                                  rating: nil,
                                                  posterPath: nil,
                                                  backdropPath: nil,
                                                  runtime: nil,
                                                  credit: nil,
                                                  genres: nil,
                                                  productionCountries: nil))

    override func setUp() {
        super.setUp()

        dataTransferService = MockDataTransferService()
        cacheService = MockCacheService()

        sut = DefaultMediaRepository(dataTransferService: dataTransferService,
                                     cacheService: cacheService)
    }

    override func tearDown() {
        sut = nil
        dataTransferService = nil
        cacheService = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testFetchMediaListSuccessShouldReturnMediaPage() {
        let expectation = self.expectation(description: "Should return media page")

        let media = mediaDTO.toDomain()
        let expectedPage = MediaPage(page: 1, totalPages: 2, media: [media])

        dataTransferService.result = MediaPageDTO(page: 1, totalPages: 2, media: [mediaDTO])

        _ = sut.fetchMediaList(type: .movie, query: "Foo", page: 1) { result in
            do {
                let page = try result.get()
                XCTAssertEqual(page, expectedPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch media list")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchMediaListFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchMediaList(type: .movie, query: "Foo", page: 1) { result in
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

    func testFetchMediaSuccessShouldSaveResultToCacheAndReturnMedia() {
        let expectation = self.expectation(description: "Should return media")
        let expectedMedia = mediaDTO.toDomain()
        let expectedCache = [MediaRepositoryCacheKey(type: .movie, id: 1): expectedMedia]

        dataTransferService.result = mediaDTO

        _ = sut.fetchMedia(type: .movie, id: 1) { result in
            do {
                let media = try result.get()
                XCTAssertEqual(media, expectedMedia)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch media")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(cacheService.container, expectedCache)
    }

    func testFetchMediaFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchMedia(type: .movie, id: 1) { result in
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

    func testFetchMediaFromCacheShouldReturnMedia() {
        let expectation = self.expectation(description: "Should return media")
        let expectedMedia = mediaDTO.toDomain()

        let cacheKey = MediaRepositoryCacheKey(type: .movie, id: 1)
        let expectedCache = [cacheKey: expectedMedia]
        cacheService[cacheKey] = expectedMedia

        _ = sut.fetchMedia(type: .movie, id: 1) { result in
            do {
                let media = try result.get()
                XCTAssertEqual(media, expectedMedia)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch media")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(cacheService.container, expectedCache)
    }

}

// MARK: - Mock Cache Service

private final class MockCacheService: CacheService {

    typealias Key = MediaRepositoryCacheKey
    typealias Value = Media

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

    var result: Decodable?

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
