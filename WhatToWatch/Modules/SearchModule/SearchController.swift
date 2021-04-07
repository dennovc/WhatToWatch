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
    private let tableView = UITableView()
    private let loadingView = UIView()
    private let errorView = UIView()

    // MARK: - Private Properties

    private let viewModel: SearchViewModelProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle

    init(viewModel: SearchViewModelProtocol) {
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

    // MARK: - Binding

    private func binding() {
        bindSearchController()
        bindTableView()
        bindLoadingView()
        bindErrorView()
    }

    private func bindSearchController() {
        // Output
        viewModel.output.searchBarPlaceholder
            .drive(searchController.searchBar.rx.placeholder)
            .disposed(by: disposeBag)

        // Input
        searchController.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.selectedScopeButtonIndex
            .bind(to: viewModel.input.selectedScopeButton)
            .disposed(by: disposeBag)
    }

    private func bindTableView() {
        viewModel.output.searchResults
            .drive(tableView.rx.items(cellIdentifier: MovieCell.identifier, cellType: MovieCell.self)) { [unowned self] row, element, cell in
                switch element {
                case .movie(let info): cell.configure(with: info, fetchImage: viewModel.output.fetchImage)
                case .tv(let info): cell.configure(with: info, fetchImage: viewModel.output.fetchImage)
                case .person(let info): cell.configure(with: info, fetchImage: viewModel.output.fetchImage)
                }
            }
            .disposed(by: disposeBag)
    }

    private func bindLoadingView() {
        viewModel.output.isLoading
            .map(!)
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func bindErrorView() {
        viewModel.output.error
            .map { $0 == nil }
            .drive(errorView.rx.isHidden)
            .disposed(by: disposeBag)
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
        searchController.searchBar.scopeButtonTitles = viewModel.output.scopeButtonTitles
    }

    private func configureTableView() {
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)

        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag

        tableView.rx.rowHeight.onNext(180)

        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
                         right: view.rightAnchor,
                         bottom: view.bottomAnchor,
                         left: view.leftAnchor)
    }

    private func configureLoadingView() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()

        loadingView.isHidden = true
        loadingView.backgroundColor = .systemBackground

        loadingView.addSubview(activityIndicator)
        activityIndicator.anchor(centerX: loadingView.centerXAnchor, centerY: loadingView.centerYAnchor)

        view.addSubview(loadingView)
        loadingView.anchor(top: view.topAnchor,
                           right: view.rightAnchor,
                           bottom: view.bottomAnchor,
                           left: view.leftAnchor)
    }

    private func configureErrorView() {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        label.adjustsFontForContentSizeCategory = true

        viewModel.output.error
            .map { $0?.localizedDescription.capitalized }
            .drive(label.rx.text)
            .disposed(by: disposeBag)

        errorView.isHidden = true
        errorView.backgroundColor = .systemBackground

        errorView.addSubview(label)
        label.anchor(centerX: errorView.centerXAnchor, centerY: errorView.centerYAnchor)

        view.addSubview(errorView)
        errorView.anchor(top: view.topAnchor,
                         right: view.rightAnchor,
                         bottom: view.bottomAnchor,
                         left: view.leftAnchor)
    }
//
//    private func configureMovieCell(with info: Movie, at indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
//            return UITableViewCell()
//        }
//
//        cell.configure(with: info, fetchImage: viewModel.output.fetchImage)
//
//        return cell
//    }
//
//    private func configureMovieCell(with info: TV, at indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
//            return UITableViewCell()
//        }
//
//        cell.configure(with: info, fetchImage: viewModel.output.fetchImage)
//
//        return cell
//    }
//
//    private func configurePersonCell(with info: Person, at indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
//            return UITableViewCell()
//        }
//
//        cell.configure(with: info, fetchImage: viewModel.output.fetchImage)
//
//        return cell
//    }

}
