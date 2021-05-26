//
//  SearchViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import Foundation
import RxSwift
import RxCocoa

private enum SearchScopeButton: String, CaseIterable {

    case movie = "Movie"
    case tv = "TV"
    case person = "Person"

    var mediaType: MediaType {
        switch self {
        case .movie: return .movie
        case .tv: return .tv
        case .person: return .person
        }
    }

}

final class SearchViewModel: SearchRoute {

    // MARK: - Routing

    var onDetail: ((Media) -> Void)?

    // MARK: - Private Properties

    private let searchUseCase: SearchMediaUseCase

    private let searchQuery = BehaviorRelay<String>(value: "")
    private let selectedScopeButton = BehaviorRelay<SearchScopeButton>(value: SearchScopeButton.allCases[0])

    private let searchResult = PublishRelay<Observable<MediaPage>>()

    private let pages = BehaviorRelay<[MediaPage]>(value: [])
    private var media: [Media] { pages.value.flatMap(\.media) }

    private var currentPage = 0
    private var totalPages = 1
    private var hasMorePages: Bool { currentPage < totalPages }
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    private let loadingRelay = BehaviorRelay<SearchLoading?>(value: .none)
    private let errorRelay = PublishRelay<SearchError?>()

    private var mediaLoadTask: Cancellable? { willSet { mediaLoadTask?.cancel() } }

    private let disposeBag = DisposeBag()

    init(searchUseCase: SearchMediaUseCase) {
        self.searchUseCase = searchUseCase
        bind()
    }

    // MARK: - Private Methods

    private func appendPage(_ page: MediaPage) {
        currentPage = page.page
        totalPages = page.totalPages
        pages.accept(pages.value + [page])
    }

    private func resetPages() {
        currentPage = 0
        totalPages = 1
        pages.accept([])
    }

    private func load(type: MediaType, query: String, loading: SearchLoading) {
        loadingRelay.accept(loading)

        searchResult.accept(.create { [unowned self] observer in
            self.mediaLoadTask = searchUseCase.searchMedia(type: type,
                                                           query: query,
                                                           page: self.nextPage) { result in
                self.loadingRelay.accept(.none)

                switch result {
                case .success(let page):
                    observer.onNext(page)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create()
        })
    }

    private func bind() {
        Observable
            .combineLatest(searchQuery, selectedScopeButton)
            .distinctUntilChanged { $0 == $1 }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .filter { !$0.0.isEmpty }
            .bind { [unowned self] query, scopeButton in
                self.resetPages()
                self.load(type: scopeButton.mediaType, query: query, loading: .fullScreen)
            }
            .disposed(by: disposeBag)

        searchResult
            .flatMapLatest { [unowned self] observable -> Observable<MediaPage> in
                return observable
                    .catch { error in
                        self.errorRelay.accept(.underlyingError(error))
                        return .empty()
                    }
            }
            .bind { [unowned self] page in
                if page.media.isEmpty {
                    self.errorRelay.accept(.notFound)
                } else {
                    self.appendPage(page)
                }
            }.disposed(by: disposeBag)

        searchQuery
            .filter(\.isEmpty)
            .bind { [unowned self] _ in
                self.loadingRelay.accept(.none)
                self.resetPages()
            }
            .disposed(by: disposeBag)

        loadingRelay
            .map { _ in return nil }
            .bind(to: errorRelay)
            .disposed(by: disposeBag)
    }

}

// MARK: - Input

extension SearchViewModel: SearchInput {

    func didSearch(query: String) {
        searchQuery.accept(query)
    }

    func didSelectItem(at index: Int) {
        onDetail?(media[index])
    }

    func didSelectScopeButton(at index: Int) {
        let scopeButton = SearchScopeButton.allCases[index]
        selectedScopeButton.accept(scopeButton)
    }

    func didLoadNextPage() {
        guard hasMorePages, loadingRelay.value == .none else { return }

        load(type: selectedScopeButton.value.mediaType,
             query: searchQuery.value,
             loading: .nextPage)
    }

}

// MARK: - Output

extension SearchViewModel: SearchOutput {

    var scopeButtonTitles: Driver<[String]> {
        return Observable
            .just(SearchScopeButton.allCases.map(\.rawValue))
            .asDriver(onErrorJustReturn: [])
    }

    var searchBarPlaceholder: Driver<String> {
        return selectedScopeButton
            .map(\.rawValue)
            .asDriver(onErrorJustReturn: "")
    }

    var items: Driver<[SearchItemViewModel]> {
        return pages
            .map { $0.flatMap(\.media).map(SearchItemViewModel.init) }
            .asDriver(onErrorJustReturn: [])
    }

    var loading: Driver<SearchLoading?> {
        return loadingRelay.asDriver(onErrorJustReturn: .none)
    }

    var error: Driver<SearchError?> {
        return errorRelay.asDriver(onErrorJustReturn: .unknown)
    }

}

// MARK: - View Model

extension SearchViewModel: ViewModel {

    var input: SearchInput { self }
    var output: SearchOutput { self }

}
