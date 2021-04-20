//
//  NetworkSessionManager.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 19.04.2021.
//

import Foundation

/// Manages the network session instance.
protocol NetworkSessionManager {

    /**
     A completion handler type.

     - Parameters:
        - data: The data returned by the server.
        - response: An object that provides response metadata.
        - error: An error object that indicates why the request failed, or nil if the request was successful.
     */
    typealias CompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

    /**
     Creates a request that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.

     - Parameters:
        - request: A URL request object.
        - completion: The completion handler to call when the load request is complete.

     - Returns: The cancellable new request.
     */
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> Cancellable

}
