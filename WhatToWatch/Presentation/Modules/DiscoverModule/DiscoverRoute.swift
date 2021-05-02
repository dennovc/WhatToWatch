//
//  DiscoverRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import Foundation

protocol DiscoverRoute: AnyObject {

    var showDetail: ((MediaType, Int) -> Void)? { get set }
    var onLoading: ((Bool) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }

}
