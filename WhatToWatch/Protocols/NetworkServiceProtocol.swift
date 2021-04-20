//
//  NetworkServiceProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

import Foundation

protocol NetworkServiceProtocol: class {

    func request(_ networkRequest: NetworkRequestProtocol,
                 completion: @escaping (Result<Data, NetworkError1>) -> Void)

    func requestAndDecode<T: Decodable>(_ networkRequest: NetworkRequestProtocol,
                                        completion: @escaping (Result<T, NetworkError1>) -> Void)

}

// MARK: - Network Error

enum NetworkError1: LocalizedError {

    // MARK: - Cases

    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError

    // MARK: - Properties

    var errorDescription: String? {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }

}
