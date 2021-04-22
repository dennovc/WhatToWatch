//
//  MediaDetailUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol MediaDetailUseCase {

    typealias CompletionHandler<T> = (Result<T, Error>) -> Void

    func fetchMovieDetail(id: Int, completion: @escaping CompletionHandler<Movie>) -> Cancellable?

    func fetchTVDetail(id: Int, completion: @escaping CompletionHandler<TV>) -> Cancellable?

    func fetchPersonDetail(id: Int, completion: @escaping CompletionHandler<Person>) -> Cancellable?

}
