//
//  PhotoDetailsViewController.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

final class PhotoDetailsViewController: UIViewController {

    private var presenter: PhotoDetailsPresenterInput?

    private var tableViewDataSource: PhotoTableViewDataSource!

    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderHeight = 40
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        tableView.register(DetailsCell.self, forCellReuseIdentifier: DetailsCell.identifier)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: PhotoDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.tintColor = UIColor.label
        resultTableView.backgroundColor = .systemBackground
        presenter?.getData()
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
    }
}

// MARK: PhotoDetailsPresenterOutput

extension PhotoDetailsViewController: PhotoDetailsPresenterOutput {

    func updateData(photoTableViewCellTypes: [PhotoTableViewCellType]) {
        tableViewDataSource = PhotoTableViewDataSource(photoTableViewCellTypes: photoTableViewCellTypes)
        DispatchQueue.main.async {
            self.resultTableView.dataSource = self.tableViewDataSource
            self.resultTableView.delegate = self.tableViewDataSource
            self.resultTableView.reloadData()
        }
    }
}
