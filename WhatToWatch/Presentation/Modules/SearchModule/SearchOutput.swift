//
//  SearchOutput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import RxCocoa

protocol SearchOutput: class {

    var scopeButtonTitles: [String] { get }
    var searchBarPlaceholder: Driver<String> { get }
    var searchResults: Driver<[SearchResult]> { get }
    var isLoading: Driver<Bool> { get }
    var error: Driver<SearchError?> { get }

    func fetchImage(path: String?, completion: @escaping (UIImage?) -> Void)

}
