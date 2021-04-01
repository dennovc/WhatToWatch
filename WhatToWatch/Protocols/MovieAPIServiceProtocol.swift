//
//  MovieAPIServiceProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

protocol MovieAPIServiceProtocol: class {

    func searchMovie(_ query: String,
                     page: Int,
                     completion: @escaping (Result<MovieSearchResponse, NetworkError>) -> Void)

    func searchTV(_ query: String,
                  page: Int,
                  completion: @escaping (Result<TVSearchResponse, NetworkError>) -> Void)

    func searchPerson(_ query: String,
                      page: Int,
                      completion: @escaping (Result<PersonSearchResponse, NetworkError>) -> Void)

}

// MARK: - Type Aliases

typealias MovieSearchResponse = SearchResponse<Movie>
typealias TVSearchResponse = SearchResponse<TV>
typealias PersonSearchResponse = SearchResponse<Person>
