//
//  TMDBService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

import UIKit

final class TMDBService: MovieAPIServiceProtocol {

    static let shared = TMDBService(networkService: NetworkService1())

    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol

    // TODO: Inject
    private let imageCache = CacheService<String, UIImage>()
    private let movieCache = CacheService<Int, Movie>()
    private let tvCache = CacheService<Int, TV>()
    private let personCache = CacheService<Int, Person>()

    // MARK: - Life Cycle

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - API

    func searchMovie(_ query: String,
                     page: Int,
                     completion: @escaping (Result<MovieSearchResponse, NetworkError1>) -> Void) {
        let request = TMDBRequest.searchMovie(query, page: page)
        networkService.requestAndDecode(request, completion: completion)
    }

    func searchTV(_ query: String,
                  page: Int,
                  completion: @escaping (Result<TVSearchResponse, NetworkError1>) -> Void) {
        let request = TMDBRequest.searchTV(query, page: page)
        networkService.requestAndDecode(request, completion: completion)
    }

    func searchPerson(_ query: String,
                      page: Int,
                      completion: @escaping (Result<PersonSearchResponse, NetworkError1>) -> Void) {
        let request = TMDBRequest.searchPerson(query, page: page)
        networkService.requestAndDecode(request, completion: completion)
    }

    func fetchImage(path: String, completion: @escaping (Result<UIImage, NetworkError1>) -> Void) {
        if let image = imageCache[path] {
            completion(.success(image))
            return
        }

        let request = TMDBRequest.fetchImage(path: path)
        networkService.request(request) { [unowned self] in
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

    func fetchMovie(id: Int, completion: @escaping (Result<Movie, NetworkError1>) -> Void) {
        if let movie = movieCache[id] {
            completion(.success(movie))
            return
        }

        let request = TMDBRequest.fetchMovie(id: id)

        networkService.requestAndDecode(request) { [unowned self] (result: Result<Movie, NetworkError1>) in
            if case .success(let movie) = result {
                self.movieCache[id] = movie
            }

            completion(result)
        }
    }

    func fetchTV(id: Int, completion: @escaping (Result<TV, NetworkError1>) -> Void) {
        let request = TMDBRequest.fetchTV(id: id)
        networkService.requestAndDecode(request) { [weak self] (result: Result<TV, NetworkError1>) in
            if case .success(let tv) = result {
                self?.tvCache.insert(tv, forKey: tv.id)
            }

            completion(result)
        }
    }

    func fetchPerson(id: Int, completion: @escaping (Result<Person, NetworkError1>) -> Void) {
        let request = TMDBRequest.fetchPerson(id: id)
        networkService.requestAndDecode(request) { [weak self] (result: Result<Person, NetworkError1>) in
            if case .success(let person) = result {
                self?.personCache.insert(person, forKey: person.id)
            }

            completion(result)
        }
    }

    func fetchTrendingMovie(timeWindow: TrendingTimeWindow, completion: @escaping (Result<MovieSearchResponse, NetworkError1>) -> Void) {
        let request = TMDBRequest.fetchTrending(.movie, timeWindow)
        networkService.requestAndDecode(request, completion: completion)
    }

    func fetchTrendingTV(timeWindow: TrendingTimeWindow, completion: @escaping (Result<TVSearchResponse, NetworkError1>) -> Void) {
        let request = TMDBRequest.fetchTrending(.tv, timeWindow)
        networkService.requestAndDecode(request, completion: completion)
    }

}

// MARK: - TMDB Request

enum TrendingMediaType: String {

    case movie
    case tv

}

enum TrendingTimeWindow: String {

    case day
    case week

}

extension TMDBService {

    private enum TMDBRequest: NetworkRequestProtocol {

        // MARK: - Cases

        case searchMovie(String, page: Int)
        case searchTV(String, page: Int)
        case searchPerson(String, page: Int)
        case fetchImage(path: String)
        case fetchMovie(id: Int)
        case fetchTV(id: Int)
        case fetchPerson(id: Int)
        case fetchTrending(TrendingMediaType, TrendingTimeWindow)

        // MARK: - Properties

        var scheme: String { "https" }

        var host: String {
            switch self {
            case .searchMovie,
                 .searchTV,
                 .searchPerson,
                 .fetchMovie,
                 .fetchTV,
                 .fetchPerson,
                 .fetchTrending:
                return "api.themoviedb.org"
            case .fetchImage: return "image.tmdb.org"
            }
        }

        var path: String {
            switch self {
            case .searchMovie:
                return "/3/search/movie"
            case .searchTV:
                return "/3/search/tv"
            case .searchPerson:
                return "/3/search/person"
            case .fetchImage(let path):
                return "/t/p/w500\(path)"
            case .fetchMovie(let id):
                return "/3/movie/\(id)"
            case .fetchTV(let id):
                return "/3/tv/\(id)"
            case .fetchPerson(let id):
                return "/3/person/\(id)"
            case .fetchTrending(let type, let timeWindow):
                return "/3/trending/\(type)/\(timeWindow)"
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
            case .fetchMovie,
                 .fetchTV:
                parameters["append_to_response"] = "credits"
            case .fetchImage,
                 .fetchPerson,
                 .fetchTrending:
                break
            }

            return parameters
        }

        // MARK: - Private Properties

        private var apiKey: String { "4c6613f08d2d799160f955117ab330bb" }

    }

}
