//
//  DiscoverViewController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class DiscoverViewController: UIViewController {

    private let viewModel: DiscoverViewModelProtocol
    private let disposeBag = DisposeBag()

    // MARK: UI

    private lazy var collectionView: CollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.backgroundColor = .systemBackground

        collectionView.register(TrendCell.self,
                                forCellWithReuseIdentifier: TrendCell.reuseIdentifier)

        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        return collectionView
    }()

    // MARK: - Life Cycle

    init(viewModel: DiscoverViewModelProtocol) {
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


    enum TrendSection: String, Hashable {

        case trendingMoviesOfDay
        case trendingMoviesOfWeek
        case trendingTVOfDay
        case trendingTVOfWeek

    }

    private var sections = [Section<TrendSection, SearchResult>]()

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, layoutEnvironment in
            switch sections[sectionIndex].type {
            case .trendingMoviesOfDay: return createDaySection(layoutEnvironment)
            case .trendingMoviesOfWeek: return createWeekSection(layoutEnvironment)
            case .trendingTVOfDay: return createDaySection(layoutEnvironment)
            case .trendingTVOfWeek: return createWeekSection(layoutEnvironment)
            }
        }
    }

    private func createDaySection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                  heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))

            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)

            section.boundarySupplementaryItems = [header]

            return section
    }

    private func createWeekSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                  heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))

            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)

            section.boundarySupplementaryItems = [header]

            return section
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<TrendSection, SearchResult> = { [unowned self] in
        let dataSource = UICollectionViewDiffableDataSource<TrendSection, SearchResult>(collectionView: self.collectionView) { [unowned self] collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TrendCell.reuseIdentifier,
                    for: indexPath) as? TrendCell
            else { return nil }
            cell.configure(with: item, imageLoader: self.viewModel.output.loadImage)
            return cell
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
            headerView.font = .preferredFont(forTextStyle: .title1, weight: .bold)

            return headerView
        }

        return dataSource
    }()

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<TrendSection, SearchResult>()
        snapshot.appendSections(sections.map(\.type))

        for section in sections {
            snapshot.appendItems(section.items, toSection: section.type)
        }

        dataSource.apply(snapshot)
    }

    // MARK: - Binding

    private func binding() {
        viewModel.output.trendingMoviesOfDay
            .drive(onNext: { [weak self] items in
                let mainSection = Section<TrendSection, SearchResult>(type: .trendingMoviesOfDay, items: items)
                self?.sections.append(mainSection)
                self?.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.output.trendingTVOfDay
            .drive(onNext: { [weak self] items in
                let mainSection = Section<TrendSection, SearchResult>(type: .trendingTVOfDay, items: items)
                self?.sections.append(mainSection)
                self?.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.output.trendingMoviesOfWeek
            .drive(onNext: { [weak self] items in
                let mainSection = Section<TrendSection, SearchResult>(type: .trendingMoviesOfWeek, items: items)
                self?.sections.append(mainSection)
                self?.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.output.trendingTVOfWeek
            .drive(onNext: { [weak self] items in
                let mainSection = Section<TrendSection, SearchResult>(type: .trendingTVOfWeek, items: items)
                self?.sections.append(mainSection)
                self?.reloadData()
            })
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .map { [unowned self] in
                return self.dataSource.itemIdentifier(for: $0)
            }
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        navigationItem.title = "Discover"
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(collectionView)

        collectionView.anchor(top: view.topAnchor,
                              right: view.rightAnchor,
                              bottom: view.bottomAnchor,
                              left: view.leftAnchor)
    }

}
