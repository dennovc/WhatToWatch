//
//  DefaultSearchMediaUseCaseTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 22.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultSearchMediaUseCaseTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultSearchMediaUseCase!
    private var mediaRepository: MockMediaRepository!

    override func setUp() {
        super.setUp()

        mediaRepository = MockMediaRepository()
        sut = DefaultSearchMediaUseCase(mediaRepository: mediaRepository)
    }

    override func tearDown() {
        sut = nil
        mediaRepository = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testSearchMediaSuccessShouldReturnMediaPage() {
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

        _ = sut.searchMedia(type: .movie, query: "Foo", page: 4) { result in
            do {
                let mediaPage = try result.get()
                XCTAssertEqual(mediaPage, expectedMediaPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to search media")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(mediaRepository.receivedQuery, "Foo")
        XCTAssertEqual(mediaRepository.receivedPage, 4)
    }

    func testSearchMediaFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.searchMedia(type: .movie, query: "Foo", page: 1) { result in
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

    private(set) var receivedQuery: String?
    private(set) var receivedPage: Int?

    func fetchMediaList(type: MediaType,
                        query: String,
                        page: Int,
                        completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        receivedQuery = query
        receivedPage = page
        completion(result)
        return nil
    }

    func fetchMedia(type: MediaType,
                    id: Int,
                    completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        return nil
    }

}
