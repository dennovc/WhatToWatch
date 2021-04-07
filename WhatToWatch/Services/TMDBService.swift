//
//  TMDBService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

import UIKit

final class TMDBService: MovieAPIServiceProtocol {

    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol

    private let imageCache = CacheService<String, UIImage>()

    // MARK: - Life Cycle

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Methods

    func searchMovie(_ query: String,
                     page: Int,
                     completion: @escaping (Result<MovieSearchResponse, NetworkError>) -> Void) {
        let request = TMDBRequest.searchMovie(query, page: page)
        networkService.requestAndDecode(request, completion: completion)
    }

    func searchTV(_ query: String,
                  page: Int,
                  completion: @escaping (Result<TVSearchResponse, NetworkError>) -> Void) {
        let request = TMDBRequest.searchTV(query, page: page)
        networkService.requestAndDecode(request, completion: completion)
    }

    func searchPerson(_ query: String,
                      page: Int,
                      completion: @escaping (Result<PersonSearchResponse, NetworkError>) -> Void) {
        let request = TMDBRequest.searchPerson(query, page: page)
        networkService.requestAndDecode(request, completion: completion)
    }

    func fetchImage(path: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        if let image = imageCache[path] {
            completion(.success(image))
            return
        }

        let request = TMDBRequest.fetchImage(path: path)
        networkService.request(request) { [unowned self] in
            print($0)
            switch $0 {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.serializationError))
                    return
                }

                self.imageCache[path] = image
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

// MARK: - TMDB Request

extension TMDBService {

    private enum TMDBRequest: NetworkRequestProtocol {

        // MARK: - Cases

        case searchMovie(String, page: Int)
        case searchTV(String, page: Int)
        case searchPerson(String, page: Int)
        case fetchImage(path: String)

        // MARK: - Properties

        var scheme: String { "https" }

        var host: String {
            switch self {
            case .searchMovie, .searchTV, .searchPerson: return "api.themoviedb.org"
            case .fetchImage: return "image.tmdb.org"
            }
        }

        var path: String {
            switch self {
            case .searchMovie: return "/3/search/movie"
            case .searchTV: return "/3/search/tv"
            case .searchPerson: return "/3/search/person"
            case .fetchImage(let path): return "/t/p/w500\(path)"
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
            case .fetchImage: break
            }

            return parameters
        }

        // MARK: - Private Properties

        private var apiKey: String { "4c6613f08d2d799160f955117ab330bb" }

    }

}
