//
//  ResponseRequestable.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 17.04.2021.
//

import Foundation

/// Represents an HTTP request with a response.
protocol ResponseRequestable: Requestable {

    /// A response type.
    associatedtype Response

    /// An object that decodes instances of a `Response` type.
    var responseDecoder: ResponseDecoder { get }

}
