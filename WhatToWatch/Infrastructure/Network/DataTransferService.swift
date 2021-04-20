//
//  DataTransferService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 18.04.2021.
//

import Foundation

/// An error that occurs during perform data transfer.
enum DataTransferError: LocalizedError {

    /// An indication that data wasn't received from server.
    case noResponse

    /// An indication that the data is corrupted or otherwise invalid.
    case parsing(Error)

    /// An indication that an error occurred on the network request.
    case networkFailure(NetworkError)

    var errorDescription: String? {
        switch self {
        case .noResponse: return "Failed to fetch data"
        case .parsing(let error): return error.localizedDescription
        case .networkFailure(let error): return error.localizedDescription
        }
    }

}

/// Service, that sends a request to the server and decodes the data received from it.
protocol DataTransferService {

    /**
     A completion handler type.

     - Parameter result: Value of the type you specify on success. `DataTransferError` on failure.
     */
    typealias CompletionHandler<T> = (_ result: Result<T, DataTransferError>) -> Void

    /**
     Receives and decodes data from an endpoint.

     - Parameters:
        - endpoint: A `ResponseRequestable` object.
        - completion: The completion handler to call when the load and decode is complete.

     - Returns: `Cancelable` if the request was sent, otherwise `nil`.
     */
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>) -> Cancellable? where E.Response == T

}
