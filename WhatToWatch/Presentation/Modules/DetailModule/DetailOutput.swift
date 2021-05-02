//
//  DetailOutput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import RxCocoa

protocol DetailOutput: class {

    var model: Driver<SearchResult?> { get }

    func loadImage(path: String?, completion: @escaping (UIImage?) -> Void)

}
