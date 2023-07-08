//
//  PhotoDetailsViewController.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit
import Combine

final class PhotoDetailsViewController: UIViewController {

    private let viewModel: PhotoDetailsViewModel
    private var cancellable = Set<AnyCancellable>()
    private var reachabilityCancellable: AnyCancellable?

    private(set) var tableViewDataSource: PhotoDetailsTableViewDataSource!

    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderHeight = 40
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.identifier)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: PhotoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        viewModel.getArtObjectDetails()
    }

    private func setupBinding() {

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }.store(in: &cancellable)

        viewModel.$showErrorAlert.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.dismissLoadingIndicator()
                self?.showAlert(alert: alert)
            }.store(in: &cancellable)

        viewModel.$title.sink { [weak self] title in
            self?.navigationItem.title = title
        }.store(in: &cancellable)
    }

    private func setupUI() {
        view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        view.addSubview(resultTableView)

        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIView.padding10)
        ])

        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.tintColor = UIColor.label
        resultTableView.backgroundColor = .systemBackground
    }
}

// MARK: PhotoDetailsViewModelOutput

extension PhotoDetailsViewController {

    @MainActor
    func updateData(photoTableViewCellTypes: [PhotoTableViewCellType]) {
        tableViewDataSource = PhotoDetailsTableViewDataSource(photoTableViewCellTypes: photoTableViewCellTypes)
        resultTableView.dataSource = tableViewDataSource
        resultTableView.delegate = tableViewDataSource
        resultTableView.reloadData()
    }

    private func handle(state: ListViewModelState<[PhotoTableViewCellType]>) {
        dismissLoadingIndicator()
        switch state {
        case .error(let alert):
            showAlert(alert: alert)
        case .loaded(let photoTableViewCellTypes):
            updateData(photoTableViewCellTypes: photoTableViewCellTypes)
        case .loading:
            showLoadingIndicator()
        default:
            break
        }
    }
}
