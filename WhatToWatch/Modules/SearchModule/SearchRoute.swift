//
//  SearchRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

protocol SearchRoute: class {

    var showDetail: ((MediaType, Int) -> Void)? { get set }

}
