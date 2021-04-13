//
//  TabBarRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

protocol TabBarRoute: class {

    var onStart: ((RouterProtocol) -> Void)? { get set }
    var onDiscoverSelect: ((RouterProtocol) -> Void)? { get set }
    var onSearchSelect: ((RouterProtocol) -> Void)? { get set }

}
