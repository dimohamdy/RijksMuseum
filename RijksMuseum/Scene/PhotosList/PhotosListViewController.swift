//
//  PhotosListViewController.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit
import Combine

final class PhotosListViewController: UIViewController {

    private(set) var collectionDataSource: PhotosCollectionViewDataSource?
    private var cancellable = Set<AnyCancellable>()

    // MARK: Views
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 90, height: 90)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: PhotoCollectionCell.identifier)
        collectionView.register(PageHeaderCollectionCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PageHeaderCollectionCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.accessibilityIdentifier = AccessibilityIdentifiers.PhotosListViewController.collectionViewId
        return collectionView
    }()

    // MARK: View lifeCycle

    private let viewModel: PhotosListViewModel

    init(viewModel: PhotosListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        configureNavigationBar()
    }

    // MARK: - Setup UI

    private func setupBinding() {

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.dismissLoadingIndicator()
                switch state {
                case .error(let alert):
                    self?.showAlert(alert: alert)
                case .loaded(let collectionViewCellType):
                    self?.updateData(collectionViewCellType: collectionViewCellType)
                case .loading(let show):
                    if show {
                        self?.showLoadingIndicator()

                    } else {
                        self?.dismissLoadingIndicator()
                    }
                case .placeholder(let emptyPlaceHolderType):
                    self?.emptyState(emptyPlaceHolderType: emptyPlaceHolderType)
                }

            }.store(in: &cancellable)

        viewModel.$showErrorAlert.compactMap { $0 }.removeDuplicates()
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
        view.backgroundColor = .systemBackground
        view.addSubview(photosCollectionView)
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIView.padding10),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIView.padding10),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationItem.title = Strings.rijksMuseumTitle.localized
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - PhotosListViewModelOutput
extension PhotosListViewController {

    @MainActor
    func clearCollection() {
        collectionDataSource = nil
        photosCollectionView.setContentOffset(.zero, animated: false)
        photosCollectionView.dataSource = nil
        photosCollectionView.dataSource = nil
        photosCollectionView.reloadData()
    }

    @MainActor
    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {
        clearCollection()
        photosCollectionView.setEmptyView(emptyPlaceHolderType: emptyPlaceHolderType, completionBlock: { [weak self] in
            self?.viewModel.search()
        })
    }

    @MainActor
    func updateData(error: Error) {
        switch error as? RijksMuseumError {
        case .noResults:
            emptyState(emptyPlaceHolderType: .noResults)
        case .noInternetConnection:
            emptyState(emptyPlaceHolderType: .noInternetConnection)
        default:
            emptyState(emptyPlaceHolderType: .error(message: error.localizedDescription))
        }
    }

    @MainActor
    func updateData(collectionViewCellType: ItemCollectionViewCellType) {
        // Clear any placeholder view from collectionView
        photosCollectionView.restore()

        // Reload the collectionView
        if collectionDataSource == nil {
            collectionDataSource = PhotosCollectionViewDataSource(viewModelInput: viewModel, collectionViewCellTypes: [collectionViewCellType])
            photosCollectionView.dataSource = collectionDataSource
            photosCollectionView.delegate = collectionDataSource
            photosCollectionView.reloadData()
        } else {

            // Reload only the updated cells

            // Get the inserted section
            let fromIndex = collectionDataSource?.collectionViewCellTypes.count ?? 0
            let indexSet = IndexSet(integer: fromIndex)

            collectionDataSource?.collectionViewCellTypes.append(collectionViewCellType)
            photosCollectionView.performBatchUpdates {
                photosCollectionView.insertSections(indexSet)
            }
        }
    }

}
