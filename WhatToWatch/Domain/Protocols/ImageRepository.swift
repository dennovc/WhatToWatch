//
//  ImageRepository.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 22.04.2021.
//

import Foundation

protocol ImageRepository {

    typealias CompletionHandler = (Result<Data, Error>) -> Void

    @discardableResult
    func fetchImage(path: String, width: Int, completion: @escaping CompletionHandler) -> Cancellable?

}
