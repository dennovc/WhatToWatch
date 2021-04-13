//
//  DiscoverRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

protocol DiscoverRoute: class {

    var showDetail: ((ScopeButton, Int) -> Void)? { get set }

}
