//
//  DefaultMediaRepository.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

final class DefaultMediaRepository {

    private let dataTransferService: DataTransferService

    private var movieCache: AnyCacheService<Movie.ID, Movie>
    private var tvCache: AnyCacheService<TV.ID, TV>
    private var personCache: AnyCacheService<Person.ID, Person>

    init<MovieCache: CacheService,
         TVCache: CacheService,
         PersonCache: CacheService>(dataTransferService: DataTransferService,
                                    movieCache: MovieCache,
                                    tvCache: TVCache,
                                    personCache: PersonCache) where MovieCache.Key == Movie.ID,
                                                                    MovieCache.Value == Movie,
                                                                    TVCache.Key == TV.ID,
                                                                    TVCache.Value == TV,
                                                                    PersonCache.Key == Person.ID,
                                                                    PersonCache.Value == Person {
        self.dataTransferService = dataTransferService

        self.movieCache = AnyCacheService(movieCache)
        self.tvCache = AnyCacheService(tvCache)
        self.personCache = AnyCacheService(personCache)
    }

    // MARK: - Private Methods

    private func request<T: Mappable & Decodable,
                         E: ResponseRequestable>(with endpoint: E,
                                                 completion: @escaping CompletionHandler<T.Result>) -> Cancellable?
                                                 where T == E.Response {
        return dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let dataTransferObject): completion(.success(dataTransferObject.toDomain()))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

}

// MARK: - Media Repository

extension DefaultMediaRepository: MediaRepository {

    func fetchMoviesList(query: String,
                         page: Int,
                         completion: @escaping CompletionHandler<MoviesPage>) -> Cancellable? {
        let endpoint = APIEndpoints.fetchMoviesList(query: query, page: page)
        return request(with: endpoint, completion: completion)
    }

    func fetchTVList(query: String,
                     page: Int,
                     completion: @escaping CompletionHandler<TVPage>) -> Cancellable? {
        let endpoint = APIEndpoints.fetchTVList(query: query, page: page)
        return request(with: endpoint, completion: completion)
    }

    func fetchPersonsList(query: String,
                          page: Int,
                          completion: @escaping CompletionHandler<PersonsPage>) -> Cancellable? {
        let endpoint = APIEndpoints.fetchPersonsList(query: query, page: page)
        return request(with: endpoint, completion: completion)
    }

    func fetchMovie(id: Int, completion: @escaping CompletionHandler<Movie>) -> Cancellable? {
        if let movie = movieCache[id] {
            completion(.success(movie))
            return nil
        }

        let endpoint = APIEndpoints.fetchMovie(id: id)

        return request(with: endpoint) { [weak self] result in
            if case .success(let movie) = result {
                self?.movieCache[movie.id] = movie
            }
            completion(result)
        }
    }

    func fetchTV(id: Int, completion: @escaping CompletionHandler<TV>) -> Cancellable? {
        if let tv = tvCache[id] {
            completion(.success(tv))
            return nil
        }

        let endpoint = APIEndpoints.fetchTV(id: id)

        return request(with: endpoint) { [weak self] result in
            if case .success(let tv) = result {
                self?.tvCache[tv.id] = tv
            }
            completion(result)
        }
    }

    func fetchPerson(id: Int, completion: @escaping CompletionHandler<Person>) -> Cancellable? {
        if let person = personCache[id] {
            completion(.success(person))
            return nil
        }

        let endpoint = APIEndpoints.fetchPerson(id: id)

        return request(with: endpoint) { [weak self] result in
            if case .success(let person) = result {
                self?.personCache[person.id] = person
            }
            completion(result)
        }
    }

}
