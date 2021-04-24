//
//  SearchMediaUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol SearchMediaUseCase {

    typealias CompletionHandler<T> = (Result<T, Error>) -> Void

    func searchMovie(query: String, page: Int, completion: @escaping CompletionHandler<MoviesPage>) -> Cancellable?

    func searchTV(query: String, page: Int, completion: @escaping CompletionHandler<TVPage>) -> Cancellable?

    func searchPerson(query: String, page: Int, completion: @escaping CompletionHandler<PersonsPage>) -> Cancellable?

}
