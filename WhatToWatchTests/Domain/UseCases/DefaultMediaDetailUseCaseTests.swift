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

    func testFetchMovieDetailSuccessShouldReturnMovie() {
        let expectation = self.expectation(description: "Should return movie")

        _ = sut.fetchMovieDetail(id: 1) { result in
            do {
                let movie = try result.get()
                XCTAssertEqual(movie.id, 1)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch movie detail")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchMovieDetailFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")
        mediaRepository.isFailure = true

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

        _ = sut.fetchTVDetail(id: 1) { result in
            do {
                let tv = try result.get()
                XCTAssertEqual(tv.id, 1)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch tv detail")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchTVDetailFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")
        mediaRepository.isFailure = true

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

        _ = sut.fetchPersonDetail(id: 1) { result in
            do {
                let person = try result.get()
                XCTAssertEqual(person.id, 1)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch person detail")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchPersonDetailFailureShouldThrowError() {
        let expectation = self.expectation(description: "Should throw error")
        mediaRepository.isFailure = true

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

    var isFailure = false

    func fetchMoviesList(query: String,
                         page: Int,
                         completion: @escaping CompletionHandler<MoviesPage>) -> Cancellable? {
        return nil
    }

    func fetchTVList(query: String,
                     page: Int,
                     completion: @escaping CompletionHandler<TVPage>) -> Cancellable? {
        return nil
    }

    func fetchPersonsList(query: String,
                          page: Int,
                          completion: @escaping CompletionHandler<PersonsPage>) -> Cancellable? {
        return nil
    }

    func fetchMovie(id: Int, completion: @escaping CompletionHandler<Movie>) -> Cancellable? {
        guard !isFailure else {
            completion(.failure(MockError.error))
            return nil
        }

        let movie = Movie(id: id, title: nil, overview: nil, releaseDate: nil,
                          rating: nil, posterPath: nil, backdropPath: nil,
                          runtime: nil, credit: nil, genres: nil, productionCountries: nil)
        completion(.success(movie))

        return nil
    }

    func fetchTV(id: Int, completion: @escaping CompletionHandler<TV>) -> Cancellable? {
        guard !isFailure else {
            completion(.failure(MockError.error))
            return nil
        }

        let tv = TV(id: id, title: nil, overview: nil, firstAirDate: nil,
                    rating: nil, posterPath: nil, backdropPath: nil, episodeRuntime: nil,
                    credit: nil, genres: nil, productionCountries: nil)
        completion(.success(tv))

        return nil
    }

    func fetchPerson(id: Int, completion: @escaping CompletionHandler<Person>) -> Cancellable? {
        guard !isFailure else {
            completion(.failure(MockError.error))
            return nil
        }

        let person = Person(id: id, name: nil, biography: nil, birthday: nil,
                            photoPath: nil, knownForDepartment: nil, placeOfBirth: nil)
        completion(.success(person))

        return nil
    }

}
