//
//  DefaultCacheService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 21.04.2021.
//

import Foundation

final class DefaultCacheService<Key: Hashable, Value> {

    private let wrapped = NSCache<WrappedKey, Entry>()

}

// MARK: - Cache Service

extension DefaultCacheService: CacheService {

    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value)
        let wrappedKey = WrappedKey(key)
        wrapped.setObject(entry, forKey: wrappedKey)
    }

    func value(forKey key: Key) -> Value? {
        let wrappedKey = WrappedKey(key)
        let entry = wrapped.object(forKey: wrappedKey)
        return entry?.value
    }

    func removeValue(forKey key: Key) {
        let wrappedKey = WrappedKey(key)
        wrapped.removeObject(forKey: wrappedKey)
    }

    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }

}

// MARK: - Private Types

private extension DefaultCacheService {

    // MARK: - Wrapped Key

    final class WrappedKey: NSObject {

        let key: Key

        init(_ key: Key) {
            self.key = key
        }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false }
            return key == value.key
        }

    }

    // MARK: - Entry

    final class Entry {

        let value: Value

        init(_ value: Value) {
            self.value = value
        }

    }

}
