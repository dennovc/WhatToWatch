//
//  DiscoverController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class DiscoverController: UIViewController {

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.backgroundColor = UIColor(named: "BackgroundColor")

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    // MARK: - Private Properties

    private let viewModel: AnyViewModel<DiscoverInput, DiscoverOutput>
    private let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()

    init<T: ViewModel>(viewModel: T,
                       imageRepository: ImageRepository) where T.Input == DiscoverInput,
                                                               T.Output == DiscoverOutput {
        self.viewModel = AnyViewModel(viewModel)
        self.imageRepository = imageRepository

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()

        viewModel.input.viewDidLoad()
    }

    // MARK: - Data Source

    private lazy var dataSource = configureDataSource()
    private var currentSnapshot = NSDiffableDataSourceSnapshot<DiscoverSection, DiscoverItemViewModel>()

    private func configureDataSource() -> UICollectionViewDiffableDataSource
    <DiscoverSection, DiscoverItemViewModel> {
        let cellRegistration = UICollectionView.CellRegistration
        <DiscoverItemCell, DiscoverItemViewModel> { [unowned self] cell, indexPath, item in
            cell.fill(with: item, imageRepository: self.imageRepository)
            self.loadNextPageIfNeeded(after: indexPath)
        }

        let dataSource = UICollectionViewDiffableDataSource
        <DiscoverSection, DiscoverItemViewModel>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] view, _, indexPath in
            let section = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            view.title = section.rawValue
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: indexPath)
        }

        currentSnapshot.appendSections(DiscoverSection.allCases)
        dataSource.apply(currentSnapshot, animatingDifferences: false)

        return dataSource
    }

    // MARK: - Create Layout

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, layoutEnvironment in
            switch self.currentSnapshot.sectionIdentifiers[sectionIndex] {
            case .moviesOfDay: return createNarrowSection(layoutEnvironment)
            case .tvOfDay: return createWideSection(layoutEnvironment)
            case .moviesOfWeek: return createNarrowSection(layoutEnvironment)
            case .tvOfWeek: return createWideSection(layoutEnvironment)
            }
        }
    }

    private func createNarrowSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(175),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 30, trailing: 20)

        // Supplementary
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)

        section.boundarySupplementaryItems = [titleSupplementary]

        return section
    }

    private func createWideSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
            0.425 : 0.85)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                               heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 30, trailing: 20)

        // Supplementary
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)

        section.boundarySupplementaryItems = [titleSupplementary]

        return section
    }

    // MARK: - Private Methods

    private func appendItems(_ items: [DiscoverItemViewModel], to section: DiscoverSection) {
        var snapshot = dataSource.snapshot()

        let itemsInSection = snapshot.itemIdentifiers(inSection: section)
        snapshot.deleteItems(itemsInSection)

        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot)
    }

    private func loadNextPageIfNeeded(after indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        let numberOfItemsInSection = snapshot.numberOfItems(inSection: section)

        if indexPath.row == numberOfItemsInSection - 1 {
            viewModel.input.didLoadNextPage(for: section)
        }
    }

    // MARK: - Configure UI

    private func configureUI() {
        configureNavigationBar()
        configureCollectionView()
    }

    private func configureNavigationBar() {
        navigationItem.title = "Discover"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)

        collectionView.anchor(top: view.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor)
    }

    // MARK: - Binding

    private func bind() {
        // Output
        viewModel.output.moviesOfDay.drive(onNext: { [unowned self] items in
            self.appendItems(items, to: .moviesOfDay)
        }).disposed(by: disposeBag)

        viewModel.output.tvOfDay.drive(onNext: { [unowned self] items in
            self.appendItems(items, to: .tvOfDay)
        }).disposed(by: disposeBag)

        viewModel.output.moviesOfWeek.drive(onNext: { [unowned self] items in
            self.appendItems(items, to: .moviesOfWeek)
        }).disposed(by: disposeBag)

        viewModel.output.tvOfWeek.drive(onNext: { [unowned self] items in
            self.appendItems(items, to: .tvOfWeek)
        }).disposed(by: disposeBag)

        // Input
        collectionView.rx.itemSelected.bind { [unowned self] indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            self.viewModel.input.didSelectItem(at: indexPath.row, in: section)
        }.disposed(by: disposeBag)
    }

}
