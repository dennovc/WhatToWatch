//
//  SearchMediaUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol SearchMediaUseCase {

    typealias CompletionHandler = (Result<MediaPage, Error>) -> Void

    func searchMovie(query: String, page: Int, completion: @escaping CompletionHandler) -> Cancellable?

    func searchTV(query: String, page: Int, completion: @escaping CompletionHandler) -> Cancellable?

    func searchPerson(query: String, page: Int, completion: @escaping CompletionHandler) -> Cancellable?

}
