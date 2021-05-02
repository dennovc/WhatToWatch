//
//  MediaDetailUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol MediaDetailUseCase {

    typealias CompletionHandler = (Result<Media, Error>) -> Void

    func fetchMovieDetail(id: Int, completion: @escaping CompletionHandler) -> Cancellable?

    func fetchTVDetail(id: Int, completion: @escaping CompletionHandler) -> Cancellable?

    func fetchPersonDetail(id: Int, completion: @escaping CompletionHandler) -> Cancellable?

}
