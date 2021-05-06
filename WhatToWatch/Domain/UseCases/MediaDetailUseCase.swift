//
//  MediaDetailUseCase.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol MediaDetailUseCase {

    typealias CompletionHandler = (Result<Media, Error>) -> Void

    @discardableResult
    func fetchMediaDetail(type: MediaType,
                          id: Int,
                          completion: @escaping CompletionHandler) -> Cancellable?

}
