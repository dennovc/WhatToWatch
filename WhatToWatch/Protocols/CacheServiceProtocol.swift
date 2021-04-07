//
//  CacheServiceProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 06.04.2021.
//

protocol CacheServiceProtocol: class {

    associatedtype Key
    associatedtype Value

    func insert(_ value: Value, forKey key: Key)
    func value(forKey key: Key) -> Value?
    func removeValue(forKey key: Key)

    subscript(key: Key) -> Value? { get set }

}
