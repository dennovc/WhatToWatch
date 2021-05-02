//
//  ViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.05.2021.
//

import Foundation

protocol ViewModel {

    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }

}

// MARK: - Default Implementation

extension ViewModel where Self == Input, Self == Output {

    var input: Input { self }
    var output: Output { self }

}
