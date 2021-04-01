//
//  TMDBServiceTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 24.03.2021.
//

import XCTest
@testable import WhatToWatch

final class TMDBServiceTests: XCTestCase {

    // MARK: - Prepare

    private var expectation: XCTestExpectation!
    private var networkService: MockNetworkService!
    private var sut: TMDBService!

    override func setUp() {
        super.setUp()

        expectation = XCTestExpectation()
        networkService = MockNetworkService()
        sut = TMDBService(networkService: networkService)
    }

    override func tearDown() {
        sut = nil
        expectation = nil
        networkService = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testTMDBServiceConformsToMovieAPIServiceProtocol() {
        XCTAssertTrue((sut as AnyObject) is MovieAPIServiceProtocol)
    }

    func testSearchMovieSuccess() {
        var response: Result<MovieSearchResponse, NetworkError>!
        let movies = [Movie(id: 1, title: "Foo")]

        let completion: (Result<MovieSearchResponse, NetworkError>) -> Void = { [unowned self] in
            response = $0
            self.expectation.fulfill()
        }

        sut.searchMovie("Bar", page: 2, completion: completion)
        completion(.success(MovieSearchResponse(results: movies)))

        wait(for: [expectation], timeout: 5.0)

        let searchResult = try! response.get()
        let request = networkService.receivedRequest!

        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.host, "api.themoviedb.org")
        XCTAssertEqual(request.path, "/3/search/movie")
        XCTAssertEqual(request.parameters.count, 3)
        XCTAssertEqual(request.parameters["query"], "Bar")
        XCTAssertEqual(request.parameters["page"], "2")
        XCTAssertFalse(request.parameters["api_key"]!.isEmpty)
        XCTAssertEqual(searchResult.results, movies)
    }

    func testSearchMovieFailureWhenErrorFromNetworkService() {
        var response: Result<MovieSearchResponse, NetworkError>!

        let completion: (Result<MovieSearchResponse, NetworkError>) -> Void = { [unowned self] in
            response = $0
            self.expectation.fulfill()
        }

        sut.searchMovie("Foo", page: 1, completion: completion)
        completion(.failure(.apiError))

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try response.get())
    }

    func testSearchTVSuccess() {
        var response: Result<TVSearchResponse, NetworkError>!
        let tv = [TV(id: 1, title: "Foo")]

        let completion: (Result<TVSearchResponse, NetworkError>) -> Void = { [unowned self] in
            response = $0
            self.expectation.fulfill()
        }

        sut.searchTV("Bar", page: 2, completion: completion)
        completion(.success(TVSearchResponse(results: tv)))

        wait(for: [expectation], timeout: 5.0)

        let searchResult = try! response.get()
        let request = networkService.receivedRequest!

        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.host, "api.themoviedb.org")
        XCTAssertEqual(request.path, "/3/search/tv")
        XCTAssertEqual(request.parameters.count, 3)
        XCTAssertEqual(request.parameters["query"], "Bar")
        XCTAssertEqual(request.parameters["page"], "2")
        XCTAssertFalse(request.parameters["api_key"]!.isEmpty)
        XCTAssertEqual(searchResult.results, tv)
    }

    func testSearchTVFailureWhenErrorFromNetworkService() {
        var response: Result<TVSearchResponse, NetworkError>!

        let completion: (Result<TVSearchResponse, NetworkError>) -> Void = { [unowned self] in
            response = $0
            self.expectation.fulfill()
        }

        sut.searchTV("Foo", page: 1, completion: completion)
        completion(.failure(.apiError))

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try response.get())
    }

    func testSearchPersonSuccess() {
        var response: Result<PersonSearchResponse, NetworkError>!
        let persons = [Person(id: 1, name: "Foo")]

        let completion: (Result<PersonSearchResponse, NetworkError>) -> Void = { [unowned self] in
            response = $0
            self.expectation.fulfill()
        }

        sut.searchPerson("Bar", page: 2, completion: completion)
        completion(.success(PersonSearchResponse(results: persons)))

        wait(for: [expectation], timeout: 5.0)

        let searchResult = try! response.get()
        let request = networkService.receivedRequest!

        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.host, "api.themoviedb.org")
        XCTAssertEqual(request.path, "/3/search/person")
        XCTAssertEqual(request.parameters.count, 3)
        XCTAssertEqual(request.parameters["query"], "Bar")
        XCTAssertEqual(request.parameters["page"], "2")
        XCTAssertFalse(request.parameters["api_key"]!.isEmpty)
        XCTAssertEqual(searchResult.results, persons)
    }

    func testSearchPersonFailureWhenErrorFromNetworkService() {
        var response: Result<PersonSearchResponse, NetworkError>!

        let completion: (Result<PersonSearchResponse, NetworkError>) -> Void = { [unowned self] in
            response = $0
            self.expectation.fulfill()
        }

        sut.searchPerson("Foo", page: 1, completion: completion)
        completion(.failure(.apiError))

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try response.get())
    }

}