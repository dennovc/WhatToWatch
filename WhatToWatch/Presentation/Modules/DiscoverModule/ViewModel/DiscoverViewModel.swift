//
//  DiscoverViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import Foundation
import RxSwift
import RxCocoa

private final class SectionData {

    let pages = BehaviorRelay<[MediaPage]>(value: [])
    var currentPage = 0
    var totalPages = 1
    var hasMorePages: Bool { currentPage < totalPages }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    var loading = false

    var media: [Media] {
        return pages.value.flatMap(\.media)
    }

    var itemDriver: Driver<[DiscoverItemViewModel]> {
        return pages
            .filter { !$0.isEmpty }
            .map { $0.flatMap(\.media).map(DiscoverItemViewModel.init) }
            .asDriver(onErrorJustReturn: [])
    }

}

final class DiscoverViewModel: DiscoverRoute {

    // MARK: - Routing

    var onDetail: ((Media) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Private Properties

    private let trendsUseCase: MediaTrendsUseCase

    private let moviesOfDayData = SectionData()
    private let tvOfDayData = SectionData()
    private let moviesOfWeekData = SectionData()
    private let tvOfWeekData = SectionData()

    private var isLoading = true

    init(trendsUseCase: MediaTrendsUseCase) {
        self.trendsUseCase = trendsUseCase
    }

    // MARK: - Private Methods

    private func appendPage(_ page: MediaPage, to sectionData: SectionData) {
        sectionData.currentPage = page.page
        sectionData.totalPages = page.totalPages

        let pages = sectionData.pages.value + [page]
        sectionData.pages.accept(pages)
    }

    private func fetchTrends(for type: MediaType,
                             timeWindow: TimeWindow,
                             sectionData: SectionData) {
        sectionData.loading = true

        trendsUseCase.fetchTrends(type: type,
                                  timeWindow: timeWindow,
                                  page: sectionData.nextPage) { [weak self] result in
            sectionData.loading = false

            if self?.isLoading == true {
                self?.isLoading = false
                self?.onLoading?(false)
            }

            switch result {
            case .success(let page): self?.appendPage(page, to: sectionData)
            case .failure(let error): self?.onError?(error.localizedDescription)
            }
        }
    }

    private func fetchTrends() {
        fetchTrends(for: .movie, timeWindow: .day, sectionData: moviesOfDayData)
        fetchTrends(for: .tv, timeWindow: .day, sectionData: tvOfDayData)
        fetchTrends(for: .movie, timeWindow: .week, sectionData: moviesOfWeekData)
        fetchTrends(for: .tv, timeWindow: .week, sectionData: tvOfWeekData)
    }

    private func loadNextPage(for type: MediaType, timeWindow: TimeWindow, sectionData: SectionData) {
        guard sectionData.hasMorePages, sectionData.loading == false else { return }
        fetchTrends(for: type, timeWindow: timeWindow, sectionData: sectionData)
    }

}

// MARK: - Input

extension DiscoverViewModel: DiscoverInput {

    func viewDidLoad() {
        onLoading?(true)
        fetchTrends()
    }

    func didSelectItem(at index: Int, in section: DiscoverSection) {
        switch section {
        case .moviesOfDay: onDetail?(moviesOfDayData.media[index])
        case .tvOfDay: onDetail?(tvOfDayData.media[index])
        case .moviesOfWeek: onDetail?(moviesOfWeekData.media[index])
        case .tvOfWeek: onDetail?(tvOfWeekData.media[index])
        }
    }

    func didLoadNextPage(for section: DiscoverSection) {
        switch section {
        case .moviesOfDay: loadNextPage(for: .movie, timeWindow: .day, sectionData: moviesOfDayData)
        case .tvOfDay: loadNextPage(for: .tv, timeWindow: .day, sectionData: tvOfDayData)
        case .moviesOfWeek: loadNextPage(for: .movie, timeWindow: .week, sectionData: moviesOfWeekData)
        case .tvOfWeek: loadNextPage(for: .tv, timeWindow: .week, sectionData: tvOfWeekData)
        }
    }

}

// MARK: - Output

extension DiscoverViewModel: DiscoverOutput {

    var moviesOfDay: Driver<[DiscoverItemViewModel]> {
        return moviesOfDayData.itemDriver
    }

    var tvOfDay: Driver<[DiscoverItemViewModel]> {
        return tvOfDayData.itemDriver
    }

    var moviesOfWeek: Driver<[DiscoverItemViewModel]> {
        return moviesOfWeekData.itemDriver
    }

    var tvOfWeek: Driver<[DiscoverItemViewModel]> {
        return tvOfWeekData.itemDriver
    }

}

// MARK: - View Model

extension DiscoverViewModel: ViewModel {

    var input: DiscoverInput { self }
    var output: DiscoverOutput { self }

}
