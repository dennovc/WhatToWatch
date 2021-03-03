//
//  TabBarRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import UIKit

protocol TabBarRoute: class {

    var onStart: ((UINavigationController) -> Void)? { get set }

}
