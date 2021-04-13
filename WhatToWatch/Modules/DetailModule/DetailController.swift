//
//  DetailController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailController: UIViewController {

    // MARK: - UI

    private lazy var collectionView: CollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.backgroundColor = .systemBackground

        collectionView.register(MainDetailSectionCell.self,
                                forCellWithReuseIdentifier: MainDetailSectionCell.reuseIdentifier)

        collectionView.register(CastDetailSectionCell.self,
                                forCellWithReuseIdentifier: CastDetailSectionCell.reuseIdentifier)

        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        return collectionView
    }()

    // MARK: - Private Properties

    private let viewModel: DetailViewModelProtocol

    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle

    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        binding()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent || isBeingDismissed {
            viewModel.input.goBack()
        }
    }

    // MARK: Configure Collection View

    enum DetailSection: String, Hashable {

        case main = "Main"
        case cast = "Cast"

    }

    struct Section<Type: Hashable, Item: Hashable> {

        let type: Type
        let items: [Item]

    }

    private var sections = [Section<DetailSection, AnyHashable>]()

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, _ in
            switch sections[sectionIndex].type {
            case .main: return createMainSection()
            case .cast: return createCastSection()
            }
        }
    }

    private func createMainSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .estimated(225))

        let item = NSCollectionLayoutItem(layoutSize: size)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)

        return section
    }

    private func createCastSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                          heightDimension: .estimated(180))

        let item = NSCollectionLayoutItem(layoutSize: size)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 15

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<DetailSection, AnyHashable> = { [unowned self] in
        let dataSource = UICollectionViewDiffableDataSource<DetailSection, AnyHashable>(collectionView: self.collectionView) { [unowned self] collectionView, indexPath, item in
            switch item {
            case let model as SearchResult:
                guard
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MainDetailSectionCell.reuseIdentifier,
                        for: indexPath) as? MainDetailSectionCell
                else { return nil }
                cell.configure(with: model, imageLoader: self.viewModel.output.loadImage)
                return cell
            case let cast as Cast:
                guard
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CastDetailSectionCell.reuseIdentifier,
                        for: indexPath) as? CastDetailSectionCell
                else { return nil }
                cell.configure(with: cast, imageLoader: self.viewModel.output.loadImage)
                return cell
            default:
                return nil
            }
        }

        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath) as? SectionHeaderView
            else { return nil }

            guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifier(containingItem: item)

            headerView.title = section?.rawValue
            headerView.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)

            return headerView
        }

        return dataSource
    }()

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<DetailSection, AnyHashable>()
        snapshot.appendSections(sections.map { $0.type })

        for section in sections {
            snapshot.appendItems(section.items, toSection: section.type)
        }

        dataSource.apply(snapshot)
    }

    // MARK: - Binding

    private func binding() {
        viewModel.output.model
            .drive(onNext: { [unowned self] model in
                switch model {
                case .movie(let info):
                    self.configure(with: info)
                case .tv(let info):
                    self.configure(with: info)
                case .person(let info):
                    self.configure(with: info)
                case nil: break
                }
            })
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .map { [unowned self] in
                return self.dataSource.itemIdentifier(for: $0)
            }
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
    }

    // MARK: - Configure UI

    private func configure(with model: Movie) {
        navigationItem.title = model.title

        let mainSection = Section<DetailSection, AnyHashable>(type: .main, items: [SearchResult.movie(model)])
        sections = [mainSection]

        if let cast = model.credit?.cast, !cast.isEmpty {
            let castSection = Section<DetailSection, AnyHashable>(type: .cast, items: cast)
            sections.append(castSection)
        }

        reloadData()
    }

    private func configure(with model: TV) {
        navigationItem.title = model.title

        let mainSection = Section<DetailSection, AnyHashable>(type: .main, items: [SearchResult.tv(model)])
        sections = [mainSection]

        if let cast = model.credit?.cast {
            let castSection = Section<DetailSection, AnyHashable>(type: .cast, items: cast)
            sections.append(castSection)
        }

        reloadData()
    }

    private func configure(with model: Person) {
        navigationItem.title = model.name

        let mainSection = Section<DetailSection, AnyHashable>(type: .main, items: [SearchResult.person(model)])
        sections = [mainSection]

        reloadData()
    }

    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(collectionView)

        collectionView.anchor(top: view.topAnchor,
                              right: view.rightAnchor,
                              bottom: view.bottomAnchor,
                              left: view.leftAnchor)
    }

}
