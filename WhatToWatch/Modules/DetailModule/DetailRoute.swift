//
//  DetailRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

protocol DetailRoute: class {

    var showDetail: ((ScopeButton, Int) -> Void)? { get set }
    var closeModule: (() -> Void)? { get set }
    var loading: ((Bool) -> Void)? { get set }

}
