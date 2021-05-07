//
//  DetailViewModel.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: DetailRoute {

    // MARK: - Routing

    var onDetail: ((Media) -> Void)?
    var onDismiss: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Private Properties

    private let detailUseCase: MediaDetailUseCase

    private let itemRelay: BehaviorRelay<Media>
    private let castRelay = BehaviorRelay<[Cast]>(value: [])

    private let disposeBag = DisposeBag()

    init(media: Media, detailUseCase: MediaDetailUseCase) {
        self.detailUseCase = detailUseCase
        self.itemRelay = .init(value: media)

        bind()
    }

    // MARK: - Private Methods

    private func fetchDetail() {
        let media = itemRelay.value

        detailUseCase.fetchMediaDetail(type: media.type, id: media.id) { [weak self] result in
            self?.onLoading?(false)

            switch result {
            case .success(let mediaDetail): self?.itemRelay.accept(mediaDetail)
            case .failure(let error): self?.onError?(error.localizedDescription)
            }
        }
    }

    private func bind() {
        itemRelay.bind { [unowned self] item in
            var cast: [Cast]?

            switch item {
            case .movie(let movie): cast = movie.credit?.cast
            case .tv(let tv): cast = tv.credit?.cast
            case .person: return
            }

            self.castRelay.accept(cast ?? [])
        }.disposed(by: disposeBag)
    }

}

// MARK: - Input

extension DetailViewModel: DetailInput {

    func viewDidLoad() {
        onLoading?(true)
        fetchDetail()
    }

    func didDismiss() {
        onDismiss?()
    }

    func didSelectItem(at index: Int, in section: DetailSection) {
        switch section {
        case .main: break
        case .cast:
            let person = Person(cast: castRelay.value[index])
            onDetail?(.person(person))
        }
    }

}

// MARK: - Output

extension DetailViewModel: DetailOutput {

    var item: Driver<DetailItemViewModel?> {
        return itemRelay
            .map(DetailItemViewModel.init)
            .asDriver(onErrorJustReturn: nil)
    }

    var cast: Driver<[DetailCastViewModel]> {
        return castRelay
            .filter { !$0.isEmpty }
            .map { $0.map(DetailCastViewModel.init) }
            .asDriver(onErrorJustReturn: [])
    }

}

// MARK: - View Model

extension DetailViewModel: ViewModel {

    var input: DetailInput { self }
    var output: DetailOutput { self }

}
