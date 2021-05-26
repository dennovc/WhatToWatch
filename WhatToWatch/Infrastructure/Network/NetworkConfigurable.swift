//
//  NetworkConfigurable.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 19.04.2021.
//

import Foundation

/// A configuration of network service.
protocol NetworkConfigurable {

    /// The base URL.
    var baseURL: String { get }

    /// An array of query parameters for each request.
    var queryParameters: [String: Any] { get }

}
