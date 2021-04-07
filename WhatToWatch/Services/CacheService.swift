//
//  CacheService.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 06.04.2021.
//

import Foundation

final class CacheService<Key: Hashable, Value>: CacheServiceProtocol {

    // MARK: - Private Properties

    private let wrapped = NSCache<WrappedKey, Entry>()

    // MARK: - API

    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }

    func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }

    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
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

private extension CacheService {

    // MARK: - Wrapped Key

    final class WrappedKey: NSObject {

        // MARK: - Properties

        let key: Key

        // MARK: - Life Cycle

        init(_ key: Key) {
            self.key = key
        }

        // MARK: - Override

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return key == value.key
        }

    }

    // MARK: - Entry

    final class Entry {

        // MARK: - Properties

        let value: Value

        // MARK: - Life Cycle

        init(_ value: Value) {
            self.value = value
        }

    }

}
