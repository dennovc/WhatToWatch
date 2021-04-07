//
//  SearchInput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import RxSwift

protocol SearchInput: class {

    var searchQuery: AnyObserver<String> { get }
    var selectedScopeButton: AnyObserver<Int> { get }

}
