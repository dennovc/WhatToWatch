//
//  NetworkManagerProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.03.2021.
//

import Foundation

protocol NetworkManagerProtocol: class {

    func request(_ request: NetworkRequestProtocol, completion: @escaping (Result<Data, Error>) -> Void)

}
