//
//  DiscoverInput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import Foundation
import RxSwift

protocol DiscoverInput {

    var itemSelected: AnyObserver<SearchResult?> { get }

}
