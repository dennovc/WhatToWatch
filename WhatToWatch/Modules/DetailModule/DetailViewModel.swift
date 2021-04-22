//
//  DetailViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import RxSwift
import RxCocoa

final class DetailViewModel: DetailRoute {

    // MARK: - Routing

    var showDetail: ((ScopeButton, Int) -> Void)?
    var closeModule: (() -> Void)?
    var loading: ((Bool) -> Void)?

    // MARK: - Private Properties

    private let itemType: ScopeButton
    private let itemID: Int
    private let movieAPIService: MovieAPIServiceProtocol
    private let itemSelectedSubject = PublishSubject<AnyHashable?>()

    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle

    init(itemType: ScopeButton, itemID: Int, movieAPIService: MovieAPIServiceProtocol) {
        self.itemType = itemType
        self.itemID = itemID
        self.movieAPIService = movieAPIService

        itemSelectedSubject
            .bind { [unowned self] item in
                guard let item = item else { return }

                var type: ScopeButton?
                var id: Int?

                switch item {
                case let movie as SearchResult:
                    switch movie {
                    case .movie(let info):
                        type = .movie
                        id = info.id
                    case .tv(let info):
                        type = .tv
                        id = info.id
                    case .person(let info):
                        type = .person
                        id = info.id
                    }
                case let info as Cast1:
                    type = .person
                    id = info.id
                default: break
                }

                if let type = type, let id = id, type != self.itemType || id != self.itemID {
                    showDetail?(type, id)
                }
            }
            .disposed(by: disposeBag)
    }

    private func processFetchResponse<T>(from result: Result<T, NetworkError1>,
                                          to observer: AnyObserver<SearchResult?>) {
        loading?(false)
        
        switch result {
        case .success(let response):
            var item: SearchResult?

            switch response {
            case let model as Movie1:
                item = .movie(model)
            case let model as TV1:
                item = .tv(model)
            case let model as Person1:
                item = .person(model)
            default: break
            }

            observer.onNext(item)
            observer.onCompleted()
        case .failure(let error):
            print(error)
            observer.onError(error)
        }
    }

    private func fetch(_ type: ScopeButton, id: Int) -> Observable<SearchResult?> {
        self.loading?(true)

        return Observable.create { [weak self] observer in
            switch type {
            case .movie:
                self?.movieAPIService.fetchMovie(id: id) {
                    self?.processFetchResponse(from: $0, to: observer)
                }
            case .tv:
                self?.movieAPIService.fetchTV(id: id) {
                    self?.processFetchResponse(from: $0, to: observer)
                }
            case .person:
                self?.movieAPIService.fetchPerson(id: id) {
                    self?.processFetchResponse(from: $0, to: observer)
                }
            }

            return Disposables.create()
        }
    }

}

// MARK: - Input

extension DetailViewModel: DetailInput {

    var itemSelected: AnyObserver<AnyHashable?> {
        return itemSelectedSubject.asObserver()
    }

    func goBack() {
        closeModule?()
    }

}

// MARK: - Output

extension DetailViewModel: DetailOutput {

    var model: Driver<SearchResult?> {
        return fetch(self.itemType, id: self.itemID)
            .asDriver(onErrorJustReturn: nil)
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

// MARK: - View Model Protocol

extension DetailViewModel: DetailViewModelProtocol {

    var input: DetailInput { self }
    var output: DetailOutput { self }

}
