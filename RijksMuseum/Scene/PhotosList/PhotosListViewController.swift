//
//  PhotosListViewController.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

final class PhotosListViewController: UIViewController {

    private(set) var collectionDataSource: PhotosCollectionViewDataSource?
    
    // MARK: Outlets
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
        collectionView.tag = 1
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()

    var presenter: PhotosListPresenterInput?
    
    // MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        presenter?.search()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(photosCollectionView)
        NSLayoutConstraint.activate([
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationItem.title = Strings.rijksMuseumTitle.localized()
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
        navigationController?.hidesBarsOnSwipe = true
    }
}

// MARK: - PhotosListPresenterOutput
extension PhotosListViewController: PhotosListPresenterOutput {

    func clearCollection() {
        DispatchQueue.main.async {
            self.collectionDataSource = nil
            self.photosCollectionView.dataSource = nil
            self.photosCollectionView.dataSource = nil
            self.photosCollectionView.reloadData()
        }
    }

    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {
        clearCollection()
        photosCollectionView.setEmptyView(emptyPlaceHolderType: emptyPlaceHolderType, completionBlock: { [weak self] in
            self?.presenter?.search()
        })
    }

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

    func updateData(itemsForCollection: [ItemCollectionViewCellType]) {
        DispatchQueue.main.async {
            //Clear any placeholder view from collectionView
            self.photosCollectionView.restore()

            // Reload the collectionView
            if self.collectionDataSource == nil {
                self.collectionDataSource = PhotosCollectionViewDataSource(presenterInput: self.presenter, itemsForCollection: itemsForCollection)
                self.photosCollectionView.dataSource = self.collectionDataSource
                self.photosCollectionView.delegate = self.collectionDataSource
                self.photosCollectionView.reloadData()
            } else {

                // Reload only the updated cells

                //Get the inserted new cells
                let fromIndex = self.collectionDataSource?.itemsForCollection.count ?? 0
                let toIndex = itemsForCollection.count

                let indexes = (fromIndex ..< toIndex).map { row -> IndexPath in
                    return IndexPath(row: row, section: 0)
                }

                self.collectionDataSource?.itemsForCollection = itemsForCollection
                self.photosCollectionView.performBatchUpdates {
                    self.photosCollectionView.insertItems(at: indexes)
                }
            }

        }
        
    }
}
