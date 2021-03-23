//
//  NetworkRouterProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

protocol NetworkRequestProtocol {

    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [String: String] { get }

}
