//
//  DetailOutput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import Foundation
import RxCocoa

protocol DetailOutput {

    var item: Driver<DetailItemViewModel?> { get }
    var cast: Driver<[DetailCastViewModel]> { get }

}
