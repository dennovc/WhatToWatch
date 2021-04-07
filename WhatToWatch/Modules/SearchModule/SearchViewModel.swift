//
//  SearchViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import RxSwift
import RxCocoa

final class SearchViewModel: SearchRoute {

    // MARK: - Private Properties

    private let movieAPIService: MovieAPIServiceProtocol

    private let searchQuerySubject = PublishSubject<String>()
    private let selectedScopeButtonSubject = PublishSubject<Int>()
    private let searchResultsSubject = PublishSubject<[SearchResult]>()

    private let loadingSubject = PublishSubject<Bool>()
    private let errorSubject = PublishSubject<SearchError?>()

    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle

    init(movieAPIService: MovieAPIServiceProtocol) {
        self.movieAPIService = movieAPIService
        bindSearchResults()
    }

    // MARK: - Private Methods

    private func processSearchResponse<T>(from result: Result<SearchResponse<T>, NetworkError>,
                                          to observer: AnyObserver<[SearchResult]>) {
        switch result {
        case .success(let response):
            guard !response.results.isEmpty else {
                observer.onError(SearchError.notFound)
                return
            }

            var items = [SearchResult]()

            switch response {
            case let movieResponse as MovieSearchResponse:
                items = movieResponse.results.map { .movie($0) }
            case let tvResponse as TVSearchResponse:
                items = tvResponse.results.map { .tv($0) }
            case let personResponse as PersonSearchResponse:
                items = personResponse.results.map { .person($0) }
            default: break
            }

            observer.onNext(items)
            observer.onCompleted()
        case .failure(let error):
            observer.onError(error)
        }
    }

    private func search(by query: String, scopeButton: ScopeButton) -> Observable<[SearchResult]> {
        Observable.create { [unowned self] observer in
            switch scopeButton {
            case .movie:
                movieAPIService.searchMovie(query, page: 1) {
                    processSearchResponse(from: $0, to: observer)
                }
            case .tv:
                movieAPIService.searchTV(query, page: 1) {
                    processSearchResponse(from: $0, to: observer)
                }
            case .person:
                movieAPIService.searchPerson(query, page: 1) {
                    processSearchResponse(from: $0, to: observer)
                }
            }

            return Disposables.create()
        }
    }

    private func bindSearchResults() {
        Observable.combineLatest(searchQuerySubject, selectedScopeButtonSubject)
            .distinctUntilChanged { $0 == $1 }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .filter { !$0.0.isEmpty }
            .map { ($0.0, ScopeButton.allCases[$0.1]) }
            .flatMapLatest { [unowned self] query, scopeButton -> Observable<[SearchResult]> in
                loadingSubject.onNext(true)
                errorSubject.onNext(nil)

                return search(by: query, scopeButton: scopeButton)
                    .catch {
                        errorSubject.onNext(.underlyingError($0))
                        return Observable.empty()
                    }
            }
            .bind { [unowned self] results in
                loadingSubject.onNext(false)
                searchResultsSubject.onNext(results)
            }
            .disposed(by: disposeBag)

        searchQuerySubject
            .filter { $0.isEmpty }
            .bind { [unowned self] _ in
                loadingSubject.onNext(false)
                errorSubject.onNext(nil)
                searchResultsSubject.onNext([])
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - Input

extension SearchViewModel: SearchInput {

    var searchQuery: AnyObserver<String> {
        searchQuerySubject.asObserver()
    }

    var selectedScopeButton: AnyObserver<Int> {
        selectedScopeButtonSubject.asObserver()
    }

}

// MARK: - Output

extension SearchViewModel: SearchOutput {

    var scopeButtonTitles: [String] {
        ScopeButton.allCases.map { $0.rawValue }
    }

    var searchBarPlaceholder: Driver<String> {
        selectedScopeButtonSubject
            .map { [unowned self] in scopeButtonTitles[$0] }
            .asDriver(onErrorJustReturn: "")
    }

    var searchResults: Driver<[SearchResult]> {
        searchResultsSubject
            .asDriver(onErrorJustReturn: [])
    }

    var isLoading: Driver<Bool> {
        loadingSubject
            .asDriver(onErrorJustReturn: false)
    }

    var error: Driver<SearchError?> {
        errorSubject
            .asDriver(onErrorJustReturn: .unknown)
    }

    func fetchImage(path: String?, completion: @escaping (UIImage?) -> Void) {
        guard let path = path else { return }

        movieAPIService.fetchImage(path: path) { [unowned self] in
            switch $0 {
            case .success(let image):
                completion(image)
            case .failure(let error):
                errorSubject.onNext(.underlyingError(error))
                completion(nil)
            }
        }
    }

}

// MARK: - Search View Model Protocol

extension SearchViewModel: SearchViewModelProtocol {

    var input: SearchInput { self }
    var output: SearchOutput { self }

}

// MARK: - Private Types

extension SearchViewModel {

    // MARK: - Scope Button

    private enum ScopeButton: String, CaseIterable {

        case movie = "Movie"
        case tv = "TV"
        case person = "Person"

    }

}