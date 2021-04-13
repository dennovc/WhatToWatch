//
//  DetailInput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import UIKit
import RxSwift

protocol DetailInput: class {

    var itemSelected: AnyObserver<AnyHashable?> { get }
    func goBack()

}
