//
//  MovieNetworkManager.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

import Foundation

final class MovieNetworkManager: MovieNetworkManagerProtocol {

    // MARK: - Private Properties

    private let networkManager: NetworkManagerProtocol

    // MARK: - Life Cycle

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    // MARK: - Methods

    func searchMovie(_ query: String, page: Int, completion: @escaping (Result<MovieSearchResult, Error>) -> Void) {
        let request = MovieRequest.searchMovie(query, page: page)
        search(MovieSearchResult.self, by: request, completion: completion)
    }

    func searchTV(_ query: String, page: Int, completion: @escaping (Result<TVSearchResult, Error>) -> Void) {
        let request = MovieRequest.searchTV(query, page: page)
        search(TVSearchResult.self, by: request, completion: completion)
    }

    func searchPerson(_ query: String, page: Int, completion: @escaping (Result<PersonSearchResult, Error>) -> Void) {
        let request = MovieRequest.searchPerson(query, page: page)
        search(PersonSearchResult.self, by: request, completion: completion)
    }

    // MARK: - Private Methods

    private func checkSearchParameters(_ parameters: [String: String]) -> Bool {
        guard
            let query = parameters["query"], !query.isEmpty,
            let page = parameters["page"], "1" <= page && page <= "1000"
        else { return false }

        return true
    }

    private func search<T: Decodable>(_ type: T.Type,
                                      by request: MovieRequest,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        guard checkSearchParameters(request.parameters) else {
            let error = MovieNetworkManagerError.invalidArgument("parameters: \(request.parameters)")
            completion(.failure(error))
            return
        }

        networkManager.request(request) {
            switch $0 {
            case .success(let data):
                do {
                    let searchResult = try JSONDecoder().decode(type, from: data)
                    completion(.success(searchResult))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

// MARK: - Movie Network Manager Error

extension MovieNetworkManager {

    private enum MovieNetworkManagerError: Error {

        case invalidArgument(String)

    }

}

// MARK: - Movie Request

extension MovieNetworkManager {

    private enum MovieRequest: NetworkRequestProtocol {

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
