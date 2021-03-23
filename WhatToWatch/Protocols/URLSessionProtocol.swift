//
//  URLSessionProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

import Foundation

protocol URLSessionProtocol: class {

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

}

// MARK: - URL Session Extension

extension URLSession: URLSessionProtocol {}
