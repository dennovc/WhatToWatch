//
//  SearchMediaUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol SearchMediaUseCase {

    typealias CompletionHandler = (Result<MediaPage, Error>) -> Void

    @discardableResult
    func searchMedia(type: MediaType,
                     query: String,
                     page: Int,
                     completion: @escaping CompletionHandler) -> Cancellable?

}
