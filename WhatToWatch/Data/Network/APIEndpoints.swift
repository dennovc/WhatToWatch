//
//  APIEndpoints.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 23.04.2021.
//

import Foundation

struct APIEndpoints {

    static func fetchTrends(type: MediaType, timeWindow: TimeWindow, page: Int) -> Endpoint<MediaPageDTO> {
        let mediaString = APIEndpoints.mediaString(from: type)
        let timeWindowString = APIEndpoints.timeWindowString(from: timeWindow)

        return .init(path: "3/trending/\(mediaString)/\(timeWindowString)",
                     method: .get,
                     queryParameters: ["page": page])
    }

    static func fetchMediaList(type: MediaType, query: String, page: Int) -> Endpoint<MediaPageDTO> {
        let mediaString = APIEndpoints.mediaString(from: type)

        return .init(path: "3/search/\(mediaString)",
                     method: .get,
                     queryParameters: ["query": query, "page": page])
    }

    static func fetchMedia(type: MediaType, id: Int) -> Endpoint<MediaDTO> {
        let mediaString = APIEndpoints.mediaString(from: type)
        return .init(path: "3/\(mediaString)/\(id)", method: .get)
    }

    static func fetchMediaImage(path: String, width: Int) -> Endpoint<Data> {
        // TODO: Load from server
        // From API documentation
        let sizes = [45, 92, 154, 185, 300, 342, 500, 780, 1280]
        let closestWidth = sizes.min { abs($0 - width) < abs($1 - width) }!

        return .init(path: "t/p/w\(closestWidth)\(path)",
                     method: .get,
                     responseDecoder: RawDataResponseDecoder())
    }

    // MARK: - Mapping

    private static func timeWindowString(from timeWindow: TimeWindow) -> String {
        switch timeWindow {
        case .day: return "day"
        case .week: return "week"
        }
    }

    private static func mediaString(from type: MediaType) -> String {
        switch type {
        case .movie: return "movie"
        case .tv: return "tv"
        case .person: return "person"
        }
    }

}
