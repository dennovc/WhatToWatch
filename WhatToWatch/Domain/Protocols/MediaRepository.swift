//
//  MediaRepository.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol MediaRepository {

    typealias CompletionHandler<T> = (Result<T, Error>) -> Void

    func fetchMoviesList(query: String,
                        page: Int,
                        completion: @escaping CompletionHandler<MoviesPage>) -> Cancellable?

    func fetchTVList(query: String,
                     page: Int,
                     completion: @escaping CompletionHandler<TVPage>) -> Cancellable?

    func fetchPersonsList(query: String,
                         page: Int,
                         completion: @escaping CompletionHandler<PersonsPage>) -> Cancellable?

    func fetchMovie(id: Int, completion: @escaping CompletionHandler<Movie>) -> Cancellable?

    func fetchTV(id: Int, completion: @escaping CompletionHandler<TV>) -> Cancellable?

    func fetchPerson(id: Int, completion: @escaping CompletionHandler<Person>) -> Cancellable?

}
