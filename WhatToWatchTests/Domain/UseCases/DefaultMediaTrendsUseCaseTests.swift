//
//  DefaultMediaTrendsUseCaseTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 02.05.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultMediaTrendsUseCaseTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultMediaTrendsUseCase!
    private var mediaRepository: MockMediaRepository!

    override func setUp() {
        super.setUp()

        mediaRepository = MockMediaRepository()
        sut = DefaultMediaTrendsUseCase(mediaRepository: mediaRepository)
    }

    override func tearDown() {
        sut = nil
        mediaRepository = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testFetchTrendsSuccessShouldReturnMediaPage() {
        let expectation = self.expectation(description: "Should return media page")

        let media: Media = .movie(.init(id: 1,
                                        title: "Bar",
                                        overview: "Baz",
                                        releaseDate: nil,
                                        rating: nil,
                                        posterPath: nil,
                                        backdropPath: nil,
                                        runtime: nil,
                                        credit: nil,
                                        genres: nil,
                                        productionCountries: nil))

        let expectedMediaPage = MediaPage(page: 2, totalPages: 3, media: [media])

        mediaRepository.result = .success(expectedMediaPage)

        _ = sut.fetchTrends(type: .movie, timeWindow: .day, page: 2) { result in
            do {
                let mediaPage = try result.get()
                XCTAssertEqual(mediaPage, expectedMediaPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch trends")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(mediaRepository.receivedType, .movie)
        XCTAssertEqual(mediaRepository.receivedTimeWindow, .day)
        XCTAssertEqual(mediaRepository.receivedPage, 2)
    }

    func testFetchMediaTrendsFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.fetchTrends(type: .movie, timeWindow: .day, page: 2) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                if case MockError.error = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

}

// MARK: - Mock Error

private enum MockError: Error {

    case error

}

// MARK: - Mock Media Repository

private final class MockMediaRepository: MediaRepository {

    var result: Result<MediaPage, Error>!

    private(set) var receivedType: MediaType?
    private(set) var receivedTimeWindow: TimeWindow?
    private(set) var receivedPage: Int?

    func fetchTrends(type: MediaType,
                     timeWindow: TimeWindow,
                     page: Int,
                     completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        receivedType = type
        receivedTimeWindow = timeWindow
        receivedPage = page

        completion(result)
        return nil
    }

    func fetchMediaList(type: MediaType,
                        query: String,
                        page: Int,
                        completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        return nil
    }

    func fetchMedia(type: MediaType,
                    id: Int,
                    completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        return nil
    }

}
