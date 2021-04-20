//
//  Cancellable.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 18.04.2021.
//

import Foundation

/// Indicating that an activity or action supports cancellation.
protocol Cancellable {

    /// Cancel the activity.
    func cancel()

}

extension URLSessionTask: Cancellable {}
