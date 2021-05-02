//
//  MediaRepository.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol MediaRepository {

    typealias CompletionHandler<T> = (Result<T, Error>) -> Void

    func fetchMediaList(type: MediaType,
                        query: String,
                        page: Int,
                        completion: @escaping CompletionHandler<MediaPage>) -> Cancellable?

    func fetchMedia(type: MediaType,
                    id: Int,
                    completion: @escaping CompletionHandler<Media>) -> Cancellable?

}
