//
//  Requestable.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 19.04.2021.
//

import Foundation

/// The HTTP request method.
enum HTTPMethod: String {

    case get = "GET"

}

/// An error that occurs during the request generation.
enum RequestGenerationError: LocalizedError {

    /// An indication that the url components is invalid.
    case components

    var errorDescription: String? {
        switch self {
        case .components: return "Failed to create URL from component parts"
        }
    }

}

/// Represents an HTTP Request.
protocol Requestable {

    /// The path relative to base URL.
    var path: String { get }

    /// The HTTP request method.
    var method: HTTPMethod { get }

    /// An array of query parameters for the URL.
    var queryParameters: [String: Any] { get }

    /**
     Generates a `URL` for the specified `Requestable` object.

     - Parameter config: A configuration of network.

     - Throws: `RequestGenerationError` if url generation fails.

     - Returns: The generated `URL`.
     */
    func url(with config: NetworkConfigurable) throws -> URL

    /**
     Generates a `URLRequest` for the specified `Requestable` object.

     - Parameter config: A configuration of network.

     - Throws: `RequestGenerationError` if request generation fails.

     - Returns: The generated `URLRequest`.
     */
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest

}

// MARK: - Default Implementation

extension Requestable {

    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL + "/"
        let endpoint = baseURL.appending(path)

        guard var components = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var queryItems = [URLQueryItem]()

        queryParameters.forEach {
            queryItems.append(.init(name: $0.key, value: "\($0.value)"))
        }

        config.queryParameters.forEach {
            queryItems.append(.init(name: $0.key, value: "\($0.value)"))
        }

        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else { throw RequestGenerationError.components }

        return url
    }

    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        return request
    }

}
