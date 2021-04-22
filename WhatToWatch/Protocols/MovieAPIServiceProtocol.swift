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
                     completion: @escaping (Result<MovieSearchResponse, NetworkError1>) -> Void)

    func searchTV(_ query: String,
                  page: Int,
                  completion: @escaping (Result<TVSearchResponse, NetworkError1>) -> Void)

    func searchPerson(_ query: String,
                      page: Int,
                      completion: @escaping (Result<PersonSearchResponse, NetworkError1>) -> Void)

    func fetchImage(path: String, completion: @escaping (Result<UIImage, NetworkError1>) -> Void)

    func fetchMovie(id: Int, completion: @escaping (Result<Movie1, NetworkError1>) -> Void)

    func fetchTV(id: Int, completion: @escaping (Result<TV1, NetworkError1>) -> Void)

    func fetchPerson(id: Int, completion: @escaping (Result<Person1, NetworkError1>) -> Void)

    func fetchTrendingMovie(timeWindow: TrendingTimeWindow, completion: @escaping (Result<MovieSearchResponse, NetworkError1>) -> Void)

    func fetchTrendingTV(timeWindow: TrendingTimeWindow, completion: @escaping (Result<TVSearchResponse, NetworkError1>) -> Void)

}

// MARK: - Type Aliases

typealias MovieSearchResponse = SearchResponse<Movie1>
typealias TVSearchResponse = SearchResponse<TV1>
typealias PersonSearchResponse = SearchResponse<Person1>
