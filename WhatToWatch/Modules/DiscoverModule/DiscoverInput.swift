//
//  DiscoverInput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import RxSwift

protocol DiscoverInput: class {

    var itemSelected: AnyObserver<SearchResult?> { get }

}
