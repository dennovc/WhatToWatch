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

        let expectedMovie = Movie(id: 1, title: nil, overview: nil, releaseDate: nil,
                                  rating: nil, posterPath: nil, backdropPath: nil,
                                  runtime: nil, credit: nil, genres: nil, productionCountries: nil)

        let expectedMoviesPage = MoviesPage(page: 2, totalPages: 3, media: [expectedMovie])

        mediaRepository.moviesListResult = .success(expectedMoviesPage)

        _ = sut.searchMovie(query: "Foo", page: 4) { result in
            do {
                let moviesPage = try result.get()
                XCTAssertEqual(moviesPage.page, 2)
                XCTAssertEqual(moviesPage.totalPages, 3)
                XCTAssertEqual(moviesPage.media, [expectedMovie])
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

        let expectedTV = TV(id: 1, title: nil, overview: nil, firstAirDate: nil,
                            rating: nil, posterPath: nil, backdropPath: nil, episodeRuntime: nil,
                            credit: nil, genres: nil, productionCountries: nil)

        let expectedTVPage = TVPage(page: 2, totalPages: 3, media: [expectedTV])

        mediaRepository.tvListResult = .success(expectedTVPage)

        _ = sut.searchTV(query: "Foo", page: 4) { result in
            do {
                let tvPage = try result.get()
                XCTAssertEqual(tvPage.page, 2)
                XCTAssertEqual(tvPage.totalPages, 3)
                XCTAssertEqual(tvPage.media, [expectedTV])
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

        let expectedPerson = Person(id: 1, name: nil, biography: nil, birthday: nil,
                                    photoPath: nil, knownForDepartment: nil, placeOfBirth: nil)

        let expectedPersonsPage = PersonsPage(page: 2, totalPages: 3, media: [expectedPerson])

        mediaRepository.personsListResult = .success(expectedPersonsPage)

        _ = sut.searchPerson(query: "Foo", page: 4) { result in
            do {
                let personsPage = try result.get()
                XCTAssertEqual(personsPage.page, 2)
                XCTAssertEqual(personsPage.totalPages, 3)
                XCTAssertEqual(personsPage.media, [expectedPerson])
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

    var moviesListResult: Result<MoviesPage, Error> = .failure(MockError.error)
    var tvListResult: Result<TVPage, Error> = .failure(MockError.error)
    var personsListResult: Result<PersonsPage, Error> = .failure(MockError.error)

    private(set) var receivedQuery: String?
    private(set) var receivedPage: Int?

    func fetchMoviesList(query: String,
                         page: Int,
                         completion: @escaping CompletionHandler<MoviesPage>) -> Cancellable? {
        receivedQuery = query
        receivedPage = page
        completion(moviesListResult)
        return nil
    }

    func fetchTVList(query: String,
                     page: Int,
                     completion: @escaping CompletionHandler<TVPage>) -> Cancellable? {
        receivedQuery = query
        receivedPage = page
        completion(tvListResult)
        return nil
    }

    func fetchPersonsList(query: String,
                          page: Int,
                          completion: @escaping CompletionHandler<PersonsPage>) -> Cancellable? {
        receivedQuery = query
        receivedPage = page
        completion(personsListResult)
        return nil
    }

    func fetchMovie(id: Int, completion: @escaping CompletionHandler<Movie>) -> Cancellable? {
        return nil
    }

    func fetchTV(id: Int, completion: @escaping CompletionHandler<TV>) -> Cancellable? {
        return nil
    }

    func fetchPerson(id: Int, completion: @escaping CompletionHandler<Person>) -> Cancellable? {
        return nil
    }

}
