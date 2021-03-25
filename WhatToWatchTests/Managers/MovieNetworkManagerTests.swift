//
//  MovieNetworkManagerTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 24.03.2021.
//

import XCTest
@testable import WhatToWatch

final class MovieNetworkManagerTests: XCTestCase {

    // MARK: - Prepare

    private var expectation: XCTestExpectation!
    private var networkManager: MockNetworkManager!
    private var sut: MovieNetworkManager!

    override func setUp() {
        super.setUp()

        expectation = XCTestExpectation()
        networkManager = MockNetworkManager()
        sut = MovieNetworkManager(networkManager: networkManager)
    }

    override func tearDown() {
        sut = nil
        expectation = nil
        networkManager = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testMovieNetworkManagerConformsToMovieNetworkManagerProtocol() {
        XCTAssertTrue((sut as AnyObject) is MovieNetworkManagerProtocol)
    }

    func testSearchMovieSuccess() {
        let json = """
            {"total_pages": 2, "results": [{"id": 3, "title": "Bar"}]}
            """
        var result: Result<MovieNetworkManager.MovieSearchResult, Error>!

        sut.searchMovie("Foo", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        networkManager.completion!(.success(json.data(using: .utf8)!))

        wait(for: [expectation], timeout: 5.0)

        let searchResult = try! result.get()
        let request = networkManager.request!

        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.host, "api.themoviedb.org")
        XCTAssertEqual(request.path, "/3/search/movie")
        XCTAssertEqual(request.parameters.count, 3)
        XCTAssertEqual(request.parameters["query"], "Foo")
        XCTAssertEqual(request.parameters["page"], "1")
        XCTAssertFalse(request.parameters["api_key"]!.isEmpty)

        XCTAssertEqual(searchResult.numberOfPages, 2)
        XCTAssertEqual(searchResult.results, [Movie(id: 3, title: "Bar")])
    }

    func testSearchMovieFailureWhenEmptyQuery() {
        var result: Result<MovieNetworkManager.MovieSearchResult, Error>!

        sut.searchMovie("", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchMovieFailureWhenPagesLessThanOne() {
        var result: Result<MovieNetworkManager.MovieSearchResult, Error>!

        sut.searchMovie("Foo", page: 0) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchMovieFailureWhenPagesMoreThanThousand() {
        var result: Result<MovieNetworkManager.MovieSearchResult, Error>!

        sut.searchMovie("Foo", page: 1001) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchMovieFailureWhenErrorFromNetworkManager() {
        var result: Result<MovieNetworkManager.MovieSearchResult, Error>!

        sut.searchMovie("Foo", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        networkManager.completion!(.failure(NSError()))

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchTVSuccess() {
        let json = """
            {"total_pages": 2, "results": [{"id": 3, "name": "Bar"}]}
            """
        var result: Result<MovieNetworkManager.TVSearchResult, Error>!

        sut.searchTV("Foo", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        networkManager.completion!(.success(json.data(using: .utf8)!))

        wait(for: [expectation], timeout: 5.0)

        let searchResult = try! result.get()
        let request = networkManager.request!

        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.host, "api.themoviedb.org")
        XCTAssertEqual(request.path, "/3/search/tv")
        XCTAssertEqual(request.parameters.count, 3)
        XCTAssertEqual(request.parameters["query"], "Foo")
        XCTAssertEqual(request.parameters["page"], "1")
        XCTAssertFalse(request.parameters["api_key"]!.isEmpty)

        XCTAssertEqual(searchResult.numberOfPages, 2)
        XCTAssertEqual(searchResult.results, [TV(id: 3, title: "Bar")])
    }

    func testSearchTVFailureWhenEmptyQuery() {
        var result: Result<MovieNetworkManager.TVSearchResult, Error>!

        sut.searchTV("", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchTVFailureWhenPagesLessThanOne() {
        var result: Result<MovieNetworkManager.TVSearchResult, Error>!

        sut.searchTV("Foo", page: 0) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchTVFailureWhenPagesMoreThanThousand() {
        var result: Result<MovieNetworkManager.TVSearchResult, Error>!

        sut.searchTV("Foo", page: 1001) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchTVFailureWhenErrorFromNetworkManager() {
        var result: Result<MovieNetworkManager.TVSearchResult, Error>!

        sut.searchTV("Foo", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        networkManager.completion!(.failure(NSError()))

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try result.get())
    }


    func testSearchPersonSuccess() {
        let json = """
            {"total_pages": 2, "results": [{"id": 3, "name": "Bar"}]}
            """
        var result: Result<MovieNetworkManager.PersonSearchResult, Error>!

        sut.searchPerson("Foo", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        networkManager.completion!(.success(json.data(using: .utf8)!))

        wait(for: [expectation], timeout: 5.0)

        let searchResult = try! result.get()
        let request = networkManager.request!

        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.host, "api.themoviedb.org")
        XCTAssertEqual(request.path, "/3/search/person")
        XCTAssertEqual(request.parameters.count, 3)
        XCTAssertEqual(request.parameters["query"], "Foo")
        XCTAssertEqual(request.parameters["page"], "1")
        XCTAssertFalse(request.parameters["api_key"]!.isEmpty)

        XCTAssertEqual(searchResult.numberOfPages, 2)
        XCTAssertEqual(searchResult.results, [Person(id: 3, name: "Bar")])
    }

    func testSearchPersonFailureWhenEmptyQuery() {
        var result: Result<MovieNetworkManager.PersonSearchResult, Error>!

        sut.searchPerson("", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchPersonFailureWhenPagesLessThanOne() {
        var result: Result<MovieNetworkManager.PersonSearchResult, Error>!

        sut.searchPerson("Foo", page: 0) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchPersonFailureWhenPagesMoreThanThousand() {
        var result: Result<MovieNetworkManager.PersonSearchResult, Error>!

        sut.searchPerson("Foo", page: 1001) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(networkManager.request)
        XCTAssertNil(networkManager.completion)
        XCTAssertThrowsError(try result.get())
    }

    func testSearchPersonFailureWhenErrorFromNetworkManager() {
        var result: Result<MovieNetworkManager.PersonSearchResult, Error>!

        sut.searchPerson("Foo", page: 1) { [unowned self] in
            result = $0
            self.expectation.fulfill()
        }

        networkManager.completion!(.failure(NSError()))

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try result.get())
    }

}

// MARK: - Mock Classes

extension MovieNetworkManagerTests {

    // MARK: - Mock Network Manager

    private final class MockNetworkManager: NetworkManagerProtocol {

        // MARK: - Properties

        private(set) var request: NetworkRequestProtocol?
        private(set) var completion: ((Result<Data, Error>) -> Void)?

        // MARK: - Methods

        func request(_ request: NetworkRequestProtocol, completion: @escaping (Result<Data, Error>) -> Void) {
            self.request = request
            self.completion = completion
        }

    }

}
