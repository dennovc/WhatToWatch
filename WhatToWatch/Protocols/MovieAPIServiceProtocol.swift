//
//  MovieAPIServiceProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

import UIKit

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

    func fetchImage(path: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void)

    func fetchMovie(id: Int, completion: @escaping (Result<Movie, NetworkError>) -> Void)

    func fetchTV(id: Int, completion: @escaping (Result<TV, NetworkError>) -> Void)

    func fetchPerson(id: Int, completion: @escaping (Result<Person, NetworkError>) -> Void)

}

// MARK: - Type Aliases

typealias MovieSearchResponse = SearchResponse<Movie>
typealias TVSearchResponse = SearchResponse<TV>
typealias PersonSearchResponse = SearchResponse<Person>
