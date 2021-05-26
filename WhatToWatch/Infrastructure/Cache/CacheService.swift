//
//  CacheService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 06.04.2021.
//

import Foundation

/// A mutable collection you use to temporarily store transient key-value pairs that are subject to eviction when resources are low.
protocol CacheService {

    /// A key type.
    associatedtype Key

    /// A value type.
    associatedtype Value

    /**
     Sets the value of the specified key in the cache.

     - Parameters:
        - value: The value to be stored in the cache.
        - key: The key with which to associate the value.
     */
    func insert(_ value: Value, forKey key: Key)

    /**
     Returns the value associated with a given key.

     - Parameter key: An object identifying the value.

     - Returns: The value associated with key, or nil if no value is associated with key.
     */
    func value(forKey key: Key) -> Value?

    /**
     Removes the value of the specified key in the cache

     - Parameter key: The key identifying the value to be removed.
     */
    func removeValue(forKey key: Key)

    /**
     Accesses the value associated with the given key for reading and writing.

     - Parameter key: An object identifying the value.

     - Returns: The value associated with key, or nil if no value is associated with key.
     */
    subscript(key: Key) -> Value? { get set }

}
