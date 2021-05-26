//
//  NetworkConfig.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 19.04.2021.
//

import Foundation

struct NetworkConfig: NetworkConfigurable {

    let baseURL: String
    let queryParameters: [String: Any]

}
