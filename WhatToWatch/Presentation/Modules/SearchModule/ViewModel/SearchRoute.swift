//
//  SearchRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import Foundation

protocol SearchRoute: AnyObject {

    var onDetail: ((Media) -> Void)? { get set }

}
