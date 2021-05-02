//
//  DiscoverViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class DiscoverViewModel: DiscoverRoute, ViewModel {
    
    var input: DiscoverInput { self }
    var output: DiscoverOutput { self }

    // MARK: - Routing

    var showDetail: ((MediaType, Int) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Private Properties

    private let movieAPIService: MovieAPIServiceProtocol

    private let itemSelectedSubject = PublishSubject<SearchResult?>()
    private let disposeBag = DisposeBag()

    init(movieAPIService: MovieAPIServiceProtocol) {
        self.movieAPIService = movieAPIService

        itemSelectedSubject
            .bind { [unowned self] item in
                guard let item = item else { return }

                var type: MediaType?
                var id: Int?

                switch item {
                case .movie(let model):
                    type = .movie
                    id = model.id
                case .tv(let model):
                    type = .tv
                    id = model.id
                case .person(let model):
                    type = .person
                    id = model.id
                }

                if let type = type, let id = id {
                    showDetail?(type, id)
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Private Properties

    private func processFetchResponse<T>(from result: Result<T, NetworkError1>,
                                          to observer: AnyObserver<[SearchResult]>) {
        self.onLoading?(false)

        switch result {
        case .success(let response):
            var item = [SearchResult]()

            switch response {
            case let model as MovieSearchResponse:
                item = model.results.map { .movie($0) }
            case let model as TVSearchResponse:
                item = model.results.map { .tv($0) }
            default: break
            }

            observer.onNext(item)
            observer.onCompleted()
        case .failure(let error):
            onError?(error.localizedDescription)
            observer.onError(error)
        }
    }

    private func fetchTrending(_ type: TrendingMediaType, timeWindow: TrendingTimeWindow) -> Observable<[SearchResult]> {
        Observable.create { [weak self] observer in
            self?.onLoading?(true)
            switch type {
            case .movie:
                self?.movieAPIService.fetchTrendingMovie(timeWindow: timeWindow) {
                    self?.processFetchResponse(from: $0, to: observer)
                }
            case .tv:
                self?.movieAPIService.fetchTrendingTV(timeWindow: timeWindow) {
                    self?.processFetchResponse(from: $0, to: observer)
                }
            }

            return Disposables.create()
        }
    }

}

// MARK: Input

extension DiscoverViewModel: DiscoverInput {

    var itemSelected: AnyObserver<SearchResult?> {
        return itemSelectedSubject.asObserver()
    }

    func loadImage(path: String?, completion: @escaping (UIImage?) -> Void) {
        guard let path = path else {
            completion(nil)
            return
        }

        movieAPIService.fetchImage(path: path) {
            switch $0 {
            case .success(let image):
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }

}

// MARK: Output

extension DiscoverViewModel: DiscoverOutput {

    var trendingMoviesOfDay: Driver<[SearchResult]> {
        return fetchTrending(.movie, timeWindow: .day)
            .asDriver(onErrorJustReturn: [])
    }

    var trendingTVOfDay: Driver<[SearchResult]> {
        return fetchTrending(.tv, timeWindow: .day)
            .asDriver(onErrorJustReturn: [])
    }

    var trendingMoviesOfWeek: Driver<[SearchResult]> {
        return fetchTrending(.movie, timeWindow: .week)
            .asDriver(onErrorJustReturn: [])
    }

    var trendingTVOfWeek: Driver<[SearchResult]> {
        return fetchTrending(.tv, timeWindow: .week)
            .asDriver(onErrorJustReturn: [])
    }

}
