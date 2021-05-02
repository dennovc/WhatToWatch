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
    private var movieCache: MockCacheService<Movie.ID, Media>!
    private var tvCache: MockCacheService<TV.ID, Media>!
    private var personCache: MockCacheService<Person.ID, Media>!

    private let testMovie: MediaDTO = .movie(.init(id: 1,
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

    private let testTV: MediaDTO = .tv(.init(id: 2,
                                             title: "Foo",
                                             overview: "Bar",
                                             firstAirDate: nil,
                                             rating: nil,
                                             posterPath: nil,
                                             backdropPath: nil,
                                             episodeRuntime: nil,
                                             credit: nil,
                                             genres: nil,
                                             productionCountries: nil))

    private let testPerson: MediaDTO = .person(.init(id: 3,
                                                     name: "Foo",
                                                     biography: "Bar",
                                                     birthday: nil,
                                                     photoPath: nil,
                                                     knownForDepartment: nil,
                                                     placeOfBirth: nil))

    override func setUp() {
        super.setUp()

        dataTransferService = MockDataTransferService()
        movieCache = MockCacheService()
        tvCache = MockCacheService()
        personCache = MockCacheService()

        sut = DefaultMediaRepository(dataTransferService: dataTransferService,
                                     movieCache: movieCache,
                                     tvCache: tvCache,
                                     personCache: personCache)
    }

    override func tearDown() {
        sut = nil
        dataTransferService = nil
        movieCache = nil
        tvCache = nil
        personCache = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testFetchMoviesListSuccessShouldReturnMoviesPage() {
        let expectation = self.expectation(description: "Should return movies page")
        let movie = testMovie.toDomain()
        let expectedPage = MediaPage(page: 1, totalPages: 2, media: [movie])

        dataTransferService.result = MediaPageDTO(page: 1, totalPages: 2, media: [testMovie])

        _ = sut.fetchMoviesList(query: "Foo", page: 1) { result in
            do {
                let page = try result.get()
                XCTAssertEqual(page, expectedPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch movies list")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchMoviesListFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchMoviesList(query: "Foo", page: 1) { result in
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

    func testFetchTVListSuccessShouldReturnTVPage() {
        let expectation = self.expectation(description: "Should return tv page")
        let tv = testTV.toDomain()
        let expectedPage = MediaPage(page: 1, totalPages: 2, media: [tv])

        dataTransferService.result = MediaPageDTO(page: 1, totalPages: 2, media: [testTV])

        _ = sut.fetchTVList(query: "Foo", page: 1) { result in
            do {
                let page = try result.get()
                XCTAssertEqual(page, expectedPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch tv list")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchTVListFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchTVList(query: "Foo", page: 1) { result in
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

    func testFetchPersonsListSuccessShouldReturnPersonsPage() {
        let expectation = self.expectation(description: "Should return persons page")
        let person = testPerson.toDomain()
        let expectedPage = MediaPage(page: 1, totalPages: 2, media: [person])

        dataTransferService.result = MediaPageDTO(page: 1, totalPages: 2, media: [testPerson])

        _ = sut.fetchPersonsList(query: "Foo", page: 1) { result in
            do {
                let page = try result.get()
                XCTAssertEqual(page, expectedPage)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch persons list")
            }
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testFetchPersonsListFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchPersonsList(query: "Foo", page: 1) { result in
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

    func testFetchMovieSuccessShouldSaveResultToCacheAndReturnMovie() {
        let expectation = self.expectation(description: "Should return movie")
        let expectedMovie = testMovie.toDomain()

        dataTransferService.result = testMovie

        _ = sut.fetchMovie(id: 1) { result in
            do {
                let movie = try result.get()
                XCTAssertEqual(movie, expectedMovie)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch movie")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(movieCache.container, [1: expectedMovie])
    }

    func testFetchMovieFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchMovie(id: 1) { result in
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

    func testFetchMovieFromCacheShouldReturnMovie() {
        let expectation = self.expectation(description: "Should return movie")
        let expectedMovie = testMovie.toDomain()

        movieCache[1] = expectedMovie

        _ = sut.fetchMovie(id: 1) { result in
            do {
                let movie = try result.get()
                XCTAssertEqual(movie, expectedMovie)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch movie")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(movieCache.container, [1: expectedMovie])
    }

    func testFetchTVSuccessShouldSaveResultToCacheAndReturnTV() {
        let expectation = self.expectation(description: "Should return tv")
        let expectedTV = testTV.toDomain()

        dataTransferService.result = testTV

        _ = sut.fetchTV(id: 2) { result in
            do {
                let tv = try result.get()
                XCTAssertEqual(tv, expectedTV)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch tv")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(tvCache.container, [2: expectedTV])
    }

    func testFetchTVFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchTV(id: 2) { result in
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

    func testFetchTVFromCacheShouldReturnTV() {
        let expectation = self.expectation(description: "Should return tv")
        let expectedTV = testTV.toDomain()

        tvCache[2] = expectedTV

        _ = sut.fetchTV(id: 2) { result in
            do {
                let tv = try result.get()
                XCTAssertEqual(tv, expectedTV)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch tv")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(tvCache.container, [2: expectedTV])
    }

    func testFetchPersonSuccessShouldSaveResultToCacheAndReturnPerson() {
        let expectation = self.expectation(description: "Should return person")
        let expectedPerson = testPerson.toDomain()

        dataTransferService.result = testPerson

        _ = sut.fetchPerson(id: 3) { result in
            do {
                let person = try result.get()
                XCTAssertEqual(person, expectedPerson)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch person")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(personCache.container, [3: expectedPerson])
    }

    func testFetchPersonFailedShouldThrowDataTransferError() {
        let expectation = self.expectation(description: "Should throw DataTransferError")

        _ = sut.fetchPerson(id: 3) { result in
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

    func testFetchPersonFromCacheShouldReturnPerson() {
        let expectation = self.expectation(description: "Should return person")
        let expectedPerson = testPerson.toDomain()

        personCache[3] = expectedPerson

        _ = sut.fetchPerson(id: 3) { result in
            do {
                let person = try result.get()
                XCTAssertEqual(person, expectedPerson)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch person")
            }
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(personCache.container, [3: expectedPerson])
    }

}

// MARK: - Mock Cache Service

private final class MockCacheService<Key: Hashable, Value>: CacheService {

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
