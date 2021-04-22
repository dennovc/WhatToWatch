//
//  SearchMediaUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol SearchMediaUseCase {

    typealias CompletionHandler<T> = (Result<MediaPage<T>, Error>) -> Void

    func searchMovie(query: String, page: Int, completion: @escaping CompletionHandler<Movie>) -> Cancellable?

    func searchTV(query: String, page: Int, completion: @escaping CompletionHandler<TV>) -> Cancellable?

    func searchPerson(query: String, page: Int, completion: @escaping CompletionHandler<Person>) -> Cancellable?

}
