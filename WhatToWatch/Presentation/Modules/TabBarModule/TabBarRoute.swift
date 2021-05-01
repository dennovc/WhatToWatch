//
//  TabBarRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import Foundation

protocol TabBarRoute: AnyObject {

    var onStart: ((NavigationRouter) -> Void)? { get set }
    var onDiscoverSelect: ((NavigationRouter) -> Void)? { get set }
    var onSearchSelect: ((NavigationRouter) -> Void)? { get set }

}
