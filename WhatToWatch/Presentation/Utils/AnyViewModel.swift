//
//  AnyViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.05.2021.
//

import Foundation

struct AnyViewModel<Input, Output>: ViewModel {

    private let box: AnyViewModelBox<Input, Output>

    init<T: ViewModel>(_ base: T) where T.Input == Input, T.Output == Output {
        box = ViewModelBox(base)
    }

    var input: Input { return box.input }
    var output: Output { return box.output }

}

// MARK: - Any View Model Box

private class AnyViewModelBox<Input, Output>: ViewModel {

    var input: Input { preconditionFailure("This property is abstract. Should be overriden") }
    var output: Output { preconditionFailure("This property is abstract. Should be overriden") }

}

// MARK: - View Model Box

private final class ViewModelBox<Base: ViewModel>: AnyViewModelBox<Base.Input, Base.Output> {

    private let base: Base

    init(_ base: Base) {
        self.base = base
    }

    override var input: Input { return base.input }
    override var output: Output { return base.output }

}
