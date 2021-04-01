//
//  SearchResponse.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 24.03.2021.
//

struct SearchResponse<T: Decodable>: Decodable {

    let results: [T]

}
