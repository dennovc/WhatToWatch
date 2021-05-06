//
//  DiscoverOutput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import Foundation
import RxCocoa

protocol DiscoverOutput {

    var moviesOfDay: Driver<[DiscoverItemViewModel]> { get }
    var tvOfDay: Driver<[DiscoverItemViewModel]> { get }
    var moviesOfWeek: Driver<[DiscoverItemViewModel]> { get }
    var tvOfWeek: Driver<[DiscoverItemViewModel]> { get }

}
