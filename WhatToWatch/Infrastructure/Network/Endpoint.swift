//
//  Endpoint.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 17.04.2021.
//

import Foundation

struct Endpoint<Response>: ResponseRequestable {

    let path: String
    let method: HTTPMethod
    let queryParameters: [String: Any]
    let responseDecoder: ResponseDecoder

    init(path: String,
         method: HTTPMethod,
         queryParameters: [String: Any] = [:],
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.responseDecoder = responseDecoder
    }

}
