//
//  DefaultMediaDetailUseCaseTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 22.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultMediaDetailUseCaseTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultMediaDetailUseCase!
    private var mediaRepository: MockMediaRepository!

    override func setUp() {
        super.setUp()

        mediaRepository = MockMediaRepository()
        sut = DefaultMediaDetailUseCase(mediaRepository: mediaRepository)
    }

    override func tearDown() {
        sut = nil
        mediaRepository = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testFetchMediaDetailSuccessShouldReturnMedia() {
        let expectation = self.expectation(description: "Should return media")

        let expectedMedia: Media = .movie(.init(id: 1,
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

        mediaRepository.result = .success(expectedMedia)

        _ = sut.fetchMediaDetail(type: .movie, id: 1) { result in
            do {
                let media = try result.get()
                XCTAssertEqual(media, expectedMedia)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch media detail")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchMediaDetailFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.fetchMediaDetail(type: .movie, id: 1) { result in
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

    var result: Result<Media, Error>!

    func fetchTrends(type: MediaType,
                     timeWindow: TimeWindow,
                     page: Int,
                     completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
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
        completion(result)
        return nil
    }

}
