//
//  MovieNetworkManagerProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

protocol MovieNetworkManagerProtocol: class {

    // MARK: - Type Aliases

    typealias MovieSearchResult = SearchResult<Movie>
    typealias TVSearchResult = SearchResult<TV>
    typealias PersonSearchResult = SearchResult<Person>

    // MARK: - Methods

    func searchMovie(_ query: String, page: Int, completion: @escaping (Result<MovieSearchResult, Error>) -> Void)
    func searchTV(_ query: String, page: Int, completion: @escaping (Result<TVSearchResult, Error>) -> Void)
    func searchPerson(_ query: String, page: Int, completion: @escaping (Result<PersonSearchResult, Error>) -> Void)

}
