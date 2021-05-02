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

    func testSearchMovieSuccessShouldReturnMoviesPage() {
        let expectation = self.expectation(description: "Should return movies page")

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

        _ = sut.searchMovie(query: "Foo", page: 4) { result in
            do {
                let mediaPage = try result.get()
                XCTAssertEqual(mediaPage, expectedMediaPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to search movie")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(mediaRepository.receivedQuery, "Foo")
        XCTAssertEqual(mediaRepository.receivedPage, 4)
    }

    func testSearchMovieFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.searchMovie(query: "Foo", page: 1) { result in
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

    func testSearchTVSuccessShouldReturnTVPage() {
        let expectation = self.expectation(description: "Should return tv page")

        let media: Media = .tv(.init(id: 1,
                                     title: "Bar",
                                     overview: "Baz",
                                     firstAirDate: nil,
                                     rating: nil,
                                     posterPath: nil,
                                     backdropPath: nil,
                                     episodeRuntime: nil,
                                     credit: nil,
                                     genres: nil,
                                     productionCountries: nil))

        let expectedMediaPage = MediaPage(page: 2, totalPages: 3, media: [media])

        mediaRepository.result = .success(expectedMediaPage)

        _ = sut.searchTV(query: "Foo", page: 4) { result in
            do {
                let mediaPage = try result.get()
                XCTAssertEqual(mediaPage, expectedMediaPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to search tv")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(mediaRepository.receivedQuery, "Foo")
        XCTAssertEqual(mediaRepository.receivedPage, 4)
    }

    func testSearchTVFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.searchTV(query: "Foo", page: 1) { result in
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

    func testSearchPersonSuccessShouldReturnPersonsPage() {
        let expectation = self.expectation(description: "Should return persons page")

        let media: Media = .person(.init(id: 1,
                                         name: "Bar",
                                         biography: "Baz",
                                         birthday: nil,
                                         photoPath: nil,
                                         knownForDepartment: nil,
                                         placeOfBirth: nil))

        let expectedMediaPage = MediaPage(page: 2, totalPages: 3, media: [media])

        mediaRepository.result = .success(expectedMediaPage)

        _ = sut.searchPerson(query: "Foo", page: 4) { result in
            do {
                let mediaPage = try result.get()
                XCTAssertEqual(mediaPage, expectedMediaPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to search person")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(mediaRepository.receivedQuery, "Foo")
        XCTAssertEqual(mediaRepository.receivedPage, 4)
    }

    func testSearchPersonFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.searchPerson(query: "Foo", page: 1) { result in
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

    func fetchMoviesList(query: String,
                         page: Int,
                         completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        receivedQuery = query
        receivedPage = page
        completion(result)
        return nil
    }

    func fetchTVList(query: String,
                     page: Int,
                     completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        receivedQuery = query
        receivedPage = page
        completion(result)
        return nil
    }

    func fetchPersonsList(query: String,
                          page: Int,
                          completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        receivedQuery = query
        receivedPage = page
        completion(result)
        return nil
    }

    func fetchMovie(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        return nil
    }

    func fetchTV(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        return nil
    }

    func fetchPerson(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        return nil
    }

}
