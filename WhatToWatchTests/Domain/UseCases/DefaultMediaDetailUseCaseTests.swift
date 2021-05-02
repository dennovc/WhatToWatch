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

    private let testMovie: Media = .movie(.init(id: 1,
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

    private let testTV: Media = .tv(.init(id: 1,
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

    private let testPerson: Media = .person(.init(id: 1,
                                                  name: "Bar",
                                                  biography: "Baz",
                                                  birthday: nil,
                                                  photoPath: nil,
                                                  knownForDepartment: nil,
                                                  placeOfBirth: nil))

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

    func testFetchMovieDetailSuccessShouldReturnMovie() {
        let expectation = self.expectation(description: "Should return movie")
        let expectedMovie = testMovie

        mediaRepository.result = .success(expectedMovie)

        _ = sut.fetchMovieDetail(id: 1) { result in
            do {
                let movie = try result.get()
                XCTAssertEqual(movie, expectedMovie)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch movie detail")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchMovieDetailFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.fetchMovieDetail(id: 1) { result in
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

    func testFetchTVDetailSuccessShouldReturnTV() {
        let expectation = self.expectation(description: "Should return tv")
        let expectedTV = testTV

        mediaRepository.result = .success(expectedTV)

        _ = sut.fetchTVDetail(id: 1) { result in
            do {
                let tv = try result.get()
                XCTAssertEqual(tv, expectedTV)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch tv detail")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchTVDetailFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.fetchTVDetail(id: 1) { result in
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

    func testFetchPersonDetailSuccessShouldReturnPerson() {
        let expectation = self.expectation(description: "Should return person")
        let expectedPerson = testPerson

        mediaRepository.result = .success(expectedPerson)

        _ = sut.fetchPersonDetail(id: 1) { result in
            do {
                let person = try result.get()
                XCTAssertEqual(person, expectedPerson)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch person detail")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchPersonDetailFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")

        mediaRepository.result = .failure(MockError.error)

        _ = sut.fetchPersonDetail(id: 1) { result in
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

    func fetchMoviesList(query: String,
                         page: Int,
                         completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        return nil
    }

    func fetchTVList(query: String,
                     page: Int,
                     completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        return nil
    }

    func fetchPersonsList(query: String,
                          page: Int,
                          completion: @escaping CompletionHandler<MediaPage>) -> Cancellable? {
        return nil
    }

    func fetchMovie(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        completion(result)
        return nil
    }

    func fetchTV(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        completion(result)
        return nil
    }

    func fetchPerson(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable? {
        completion(result)
        return nil
    }

}
