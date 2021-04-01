//
//  TMDBService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

final class TMDBService: MovieAPIServiceProtocol {

    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol

    // MARK: - Life Cycle

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Methods

    func searchMovie(_ query: String,
                     page: Int,
                     completion: @escaping (Result<MovieSearchResponse, NetworkError>) -> Void) {
        performRequest(.searchMovie(query, page: page), completion: completion)
    }

    func searchTV(_ query: String,
                  page: Int,
                  completion: @escaping (Result<TVSearchResponse, NetworkError>) -> Void) {
        performRequest(.searchTV(query, page: page), completion: completion)
    }

    func searchPerson(_ query: String,
                      page: Int,
                      completion: @escaping (Result<PersonSearchResponse, NetworkError>) -> Void) {
        performRequest(.searchPerson(query, page: page), completion: completion)
    }

    // MARK: - Private Methods

    private func performRequest<T: Decodable>(_ request: TMDBRequest,
                                              completion: @escaping (Result<T, NetworkError>) -> Void) {
        networkService.requestAndDecode(request, completion: completion)
    }

}

// MARK: - TMDB Request

extension TMDBService {

    private enum TMDBRequest: NetworkRequestProtocol {

        // MARK: - Cases

        case searchMovie(String, page: Int)
        case searchTV(String, page: Int)
        case searchPerson(String, page: Int)

        // MARK: - Properties

        var scheme: String { "https" }

        var host: String { "api.themoviedb.org" }

        var path: String {
            switch self {
            case .searchMovie: return "/3/search/movie"
            case .searchTV: return "/3/search/tv"
            case .searchPerson: return "/3/search/person"
            }
        }

        var parameters: [String: String] {
            var parameters = ["api_key": apiKey]

            switch self {
            case .searchMovie(let query, let page),
                 .searchTV(let query, let page),
                 .searchPerson(let query, let page):
                parameters["query"] = query
                parameters["page"] = String(page)
            }

            return parameters
        }

        // MARK: - Private Properties

        private var apiKey: String { "4c6613f08d2d799160f955117ab330bb" }

    }

}
