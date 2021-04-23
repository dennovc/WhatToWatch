//
//  AnyCacheService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

struct AnyCacheService<Key, Value>: CacheService {

    private let box: AnyCacheServiceBox<Key, Value>

    init<CacheServiceType: CacheService>(_ cacheService: CacheServiceType) where CacheServiceType.Key == Key,
                                                                                 CacheServiceType.Value == Value {
        box = CacheServiceBox(cacheService)
    }

    func insert(_ value: Value, forKey key: Key) {
        box.insert(value, forKey: key)
    }

    func value(forKey key: Key) -> Value? {
        return box.value(forKey: key)
    }

    func removeValue(forKey key: Key) {
        box.removeValue(forKey: key)
    }

    subscript(key: Key) -> Value? {
        get { return box[key] }
        set { box[key] = newValue }
    }

}

// MARK: - Any Cache Service Box

private class AnyCacheServiceBox<Key, Value>: CacheService {

    func insert(_ value: Value, forKey key: Key) {
        preconditionFailure("This method is abstract. Should be overriden")
    }

    func value(forKey key: Key) -> Value? {
        preconditionFailure("This method is abstract. Should be overriden")
    }

    func removeValue(forKey key: Key) {
        preconditionFailure("This method is abstract. Should be overriden")
    }

    subscript(key: Key) -> Value? {
        get { preconditionFailure("This method is abstract. Should be overriden") }
        set { preconditionFailure("This method is abstract. Should be overriden") }
    }

}

// MARK: - Cache Service Box

private final class CacheServiceBox<Base: CacheService>: AnyCacheServiceBox<Base.Key, Base.Value> {

    private var base: Base

    init(_ base: Base) {
        self.base = base
    }

    override func insert(_ value: Value, forKey key: Key) {
        base.insert(value, forKey: key)
    }

    override func value(forKey key: Key) -> Value? {
        return base.value(forKey: key)
    }

    override func removeValue(forKey key: Key) {
        base.removeValue(forKey: key)
    }

    override subscript(key: Key) -> Value? {
        get { return base[key] }
        set { base[key] = newValue }
    }

}
