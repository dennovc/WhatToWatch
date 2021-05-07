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

    private lazy var collectionView: UICollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.backgroundColor = UIColor(named: "BackgroundColor")

        return collectionView
    }()

    // MARK: - Private Properties

    private let viewModel: AnyViewModel<DetailInput, DetailOutput>
    private let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()

    init<T: ViewModel>(viewModel: T,
                       imageRepository: ImageRepository) where T.Input == DetailInput,
                                                               T.Output == DetailOutput {
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent || isBeingDismissed {
            viewModel.input.didDismiss()
        }
    }

    // MARK: - Data Source

    private lazy var dataSource = configureDataSource()
    private var currentSnapshot = NSDiffableDataSourceSnapshot<DetailSection, AnyHashable>()

    private func configureDataSource() -> UICollectionViewDiffableDataSource
    <DetailSection, AnyHashable> {
        let itemCellRegistration = UICollectionView.CellRegistration
        <DetailItemCell, DetailItemViewModel> { [unowned self] cell, indexPath, item in
            cell.fill(with: item, imageRepository: self.imageRepository)
        }

        let castCellRegistration = UICollectionView.CellRegistration
        <DetailCastCell, DetailCastViewModel> { [unowned self] cell, indexPath, item in
            cell.fill(with: item, imageRepository: self.imageRepository)
        }

        let dataSource = UICollectionViewDiffableDataSource
        <DetailSection, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case let item as DetailItemViewModel:
                return collectionView.dequeueConfiguredReusableCell(using: itemCellRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            case let item as DetailCastViewModel:
                return collectionView.dequeueConfiguredReusableCell(using: castCellRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            default:
                return UICollectionViewCell()
            }
        }

        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] view, _, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view.title = section.rawValue
            view.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: indexPath)
        }

        currentSnapshot.appendSections([.main])
        dataSource.apply(currentSnapshot, animatingDifferences: false)

        return dataSource
    }

    // MARK: - Create Layout

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, _ in
            switch self.dataSource.snapshot().sectionIdentifiers[sectionIndex] {
            case .main: return createMainSection()
            case .cast: return createCastSection()
            }
        }
    }

    private func createMainSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .estimated(225))

        // Item
        let item = NSCollectionLayoutItem(layoutSize: size)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        return section
    }

    private func createCastSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                          heightDimension: .estimated(150))

        // Item
        let item = NSCollectionLayoutItem(layoutSize: size)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 20, trailing: 20)

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

    private func appendItems(_ items: [AnyHashable], to section: DetailSection) {
        var snapshot = dataSource.snapshot()

        if snapshot.sectionIdentifiers.contains(section) {
            let itemsInSection = snapshot.itemIdentifiers(inSection: section)
            snapshot.deleteItems(itemsInSection)
        } else {
            snapshot.appendSections([section])
        }

        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Configure UI

    private func configureUI() {
        configureNavigationBar()
        configureCollectionView()
    }

    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never

        viewModel.output.item
            .map { $0?.title }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
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
        viewModel.output.item.drive(onNext: { [unowned self] item in
            guard let item = item else { return }
            self.appendItems([item], to: .main)
        }).disposed(by: disposeBag)

        viewModel.output.cast.drive(onNext: { [unowned self] items in
            self.appendItems(items, to: .cast)
        }).disposed(by: disposeBag)

        // Input
        collectionView.rx.itemSelected.bind { [unowned self] indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            self.viewModel.input.didSelectItem(at: indexPath.row, in: section)
        }.disposed(by: disposeBag)
    }

}
