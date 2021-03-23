//
//  NetworkManagerProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

import Foundation

protocol NetworkManagerProtocol: class {

    func request(router: NetworkRouterProtocol, completion: @escaping (Result<Data, Error>) -> Void)

}
