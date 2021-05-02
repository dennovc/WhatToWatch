//
//  DetailRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

protocol DetailRoute: class {

    var showDetail: ((MediaType, Int) -> Void)? { get set }
    var onDismiss: (() -> Void)? { get set }
    var onLoading: ((Bool) -> Void)? { get set }

}
