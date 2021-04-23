//
//  APIEndpoints.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

struct APIEndpoints {

    // MARK: - Fetch List

    static func fetchMoviesList(query: String, page: Int) -> Endpoint<MoviesPageDTO> {
        return .init(path: "3/search/movie",
                     method: .get,
                     queryParameters: ["query": query, "page": page])
    }

    static func fetchTVList(query: String, page: Int) -> Endpoint<TVPageDTO> {
        return .init(path: "3/search/tv",
                     method: .get,
                     queryParameters: ["query": query, "page": page])
    }

    static func fetchPersonsList(query: String, page: Int) -> Endpoint<PersonsPageDTO> {
        return .init(path: "3/search/person",
                     method: .get,
                     queryParameters: ["query": query, "page": page])
    }

    // MARK: - Fetch Detail

    static func fetchMovie(id: Int) -> Endpoint<MovieDTO> {
        return .init(path: "3/movie/\(id)", method: .get)
    }

    static func fetchTV(id: Int) -> Endpoint<TVDTO> {
        return .init(path: "3/tv/\(id)", method: .get)
    }

    static func fetchPerson(id: Int) -> Endpoint<PersonDTO> {
        return .init(path: "3/person/\(id)", method: .get)
    }

    // MARK: - Fetch Image

    static func fetchMediaImage(path: String, width: Int) -> Endpoint<Data> {
        // TODO: Load from server
        // From API documentation
        let sizes = [45, 92, 154, 185, 300, 342, 500, 780, 1280]
        let closestWidth = sizes.min { abs($0 - width) < abs($1 - width) }!

        return .init(path: "t/p/w\(closestWidth)\(path)",
                     method: .get,
                     responseDecoder: RawDataResponseDecoder())
    }

}
