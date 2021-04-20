//
//  NetworkService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 18.04.2021.
//

import Foundation

/// An error that occurs during perform a request.
enum NetworkError: LocalizedError {

    /// A network resource returned an error.
    case error(statusCode: Int, data: Data?)

    /// A network resource was requested, but an internet connection hasn’t been established.
    case notConnected

    /// An asynchronous load has been canceled.
    case cancelled

    /// Failed to generate URL.
    case urlGeneration

    /// Encountered an error that cannot be interpreted.
    case generic(Error)

    var errorDescription: String? {
        switch self {
        case .error(let statusCode, let data):
            var errorMessage = "Received an error with status code \(statusCode)"

            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                errorMessage.append(". \(dataString)")
            }

            return errorMessage
        case .notConnected: return "No internet connection"
        case .cancelled: return "A request has been canceled"
        case .urlGeneration: return "Failed to generate URL"
        case .generic(let error): return error.localizedDescription
        }
    }

}

/// Allows to send network requests and receive responses.
protocol NetworkService {

    /**
     A completion handler type.

     - Parameter result: The data returned by the server on success.
                         An `NetworkError` object that indicates why the request failed on failure.
     */
    typealias CompletionHandler = (_ result: Result<Data?, NetworkError>) -> Void

    /**
     Sends a request to the server.

     - Parameters:
        - endpoint: A request object.
        - completion: The completion handler to call when the load request is complete.

     - Returns: `Cancelable` if the request was sent, otherwise `nil`.
     */
    func request(with endpoint: Requestable, completion: @escaping CompletionHandler) -> Cancellable?

}
