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
                         completion: @escaping CompletionHandler<MediaPage>) -> Cancellable?

    func fetchTVList(query: String,
                     page: Int,
                     completion: @escaping CompletionHandler<MediaPage>) -> Cancellable?

    func fetchPersonsList(query: String,
                          page: Int,
                          completion: @escaping CompletionHandler<MediaPage>) -> Cancellable?

    func fetchMovie(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable?

    func fetchTV(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable?

    func fetchPerson(id: Int, completion: @escaping CompletionHandler<Media>) -> Cancellable?

}
