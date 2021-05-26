//
//  DetailRoute.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import Foundation

protocol DetailRoute: AnyObject {

    var onDetail: ((Media) -> Void)? { get set }
    var onDismiss: (() -> Void)? { get set }
    var onLoading: ((Bool) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }

}
