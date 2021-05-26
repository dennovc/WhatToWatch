//
//  SearchInput.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import Foundation

protocol SearchInput {

    func didSearch(query: String)
    func didSelectItem(at index: Int)
    func didSelectScopeButton(at index: Int)
    func didLoadNextPage()

}
