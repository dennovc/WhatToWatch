//
//  SearchController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 02.04.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchController: UIViewController {

    // MARK: - UI

    private let searchController = UISearchController()

    private let tableView: UITableView = {
        let tableView = UITableView()

        tableView.register(SearchItemCell.self, forCellReuseIdentifier: SearchItemCell.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 180

        return tableView
    }()

    private let loadingView: UIView = {
        let loadingView = UIView()

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()

        loadingView.backgroundColor = UIColor(named: "BackgroundColor")

        loadingView.addSubview(spinner)
        spinner.anchor(centerX: loadingView.centerXAnchor, centerY: loadingView.centerYAnchor)

        return loadingView
    }()

    private lazy var footerLoadingView: UIView = {
        let footerLoadingView = UIView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 50.0))

        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()

        footerLoadingView.addSubview(spinner)
        spinner.anchor(centerX: footerLoadingView.centerXAnchor, centerY: footerLoadingView.centerYAnchor)

        return footerLoadingView
    }()

    private let errorView: UIView = {
        let errorView = UIView()

        errorView.isHidden = true
        errorView.backgroundColor = UIColor(named: "BackgroundColor")

        return errorView
    }()

    // MARK: - Private Properties

    private let viewModel: AnyViewModel<SearchInput, SearchOutput>
    private let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()

    init<T: ViewModel>(viewModel: T,
                       imageRepository: ImageRepository) where T.Input == SearchInput,
                                                               T.Output == SearchOutput {
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
    }

    // MARK: - Private Methods

    private func loadNextPageIfNeeded(after index: Int) {
        let numberOfItemsInSection = tableView.numberOfRows(inSection: 0)

        if index == numberOfItemsInSection - 1 {
            viewModel.input.didLoadNextPage()
        }
    }

    // MARK: - Configure UI

    private func configureUI() {
        configureNavigationBar()
        configureSearchController()
        configureTableView()
        configureLoadingView()
        configureErrorView()
    }

    private func configureNavigationBar() {
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureSearchController() {
        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.obscuresBackgroundDuringPresentation = false
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor)
    }

    private func configureLoadingView() {
        view.addSubview(loadingView)
        loadingView.anchor(top: view.topAnchor,
                           left: view.leftAnchor,
                           bottom: view.bottomAnchor,
                           right: view.rightAnchor)
    }

    private func configureErrorView() {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0

        errorView.addSubview(label)
        label.anchor(left: errorView.leftAnchor,
                     right: errorView.rightAnchor,
                     centerY: errorView.centerYAnchor,
                     paddingLeft: 20, paddingRight: 20)

        viewModel.output.error
            .map { $0?.localizedDescription.capitalized }
            .drive(label.rx.text)
            .disposed(by: disposeBag)

        view.addSubview(errorView)
        errorView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor)
    }

    // MARK: - Binding

    private func bind() {
        bindSearchController()
        bindTableView()
        bindLoadingView()
        bindErrorView()
    }

    private func bindSearchController() {
        // Output
        viewModel.output.scopeButtonTitles
            .drive(searchController.searchBar.rx.scopeButtonTitles)
            .disposed(by: disposeBag)

        viewModel.output.searchBarPlaceholder
            .drive(searchController.searchBar.rx.placeholder)
            .disposed(by: disposeBag)

        // Input
        Observable.merge(
            searchController.searchBar.rx.text.orEmpty.asObservable(),
            searchController.searchBar.rx.cancelButtonClicked.map { "" })
            .bind { [unowned self] query in
                self.viewModel.input.didSearch(query: query)
            }.disposed(by: disposeBag)

        searchController.searchBar.rx.selectedScopeButtonIndex
            .bind { [unowned self] index in
                self.viewModel.input.didSelectScopeButton(at: index)
            }
            .disposed(by: disposeBag)
    }

    private func bindTableView() {
        // Output
        viewModel.output.items
            .drive(tableView.rx.items(cellIdentifier: SearchItemCell.reuseIdentifier,
                                      cellType: SearchItemCell.self)) { [unowned self] index, item, cell in
                cell.fill(with: item, imageRepository: self.imageRepository)
                self.loadNextPageIfNeeded(after: index)
            }
            .disposed(by: disposeBag)

        // Input
        tableView.rx.itemSelected
            .map(\.row)
            .bind { [unowned self] index in
                self.viewModel.input.didSelectItem(at: index)
            }
            .disposed(by: disposeBag)
    }

    private func bindLoadingView() {
        viewModel.output.loading
            .drive(onNext: { [unowned self] loading in
                switch loading {
                case .fullScreen: self.loadingView.isHidden = false
                case .nextPage: self.tableView.tableFooterView = self.footerLoadingView
                case .none:
                    self.loadingView.isHidden = true
                    self.tableView.tableFooterView = UIView()
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindErrorView() {
        viewModel.output.error
            .map { $0 == nil }
            .drive(errorView.rx.isHidden)
            .disposed(by: disposeBag)
    }

}
