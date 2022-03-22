//
//  PhotosListViewController.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

final class PhotosListViewController: UIViewController {

    private(set) var collectionDataSource: PhotosCollectionViewDataSource?

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
        collectionView.tag = 1
        return collectionView
    }()

    private let collectionTypeTabBar: CollectionTypeTabBar = {
        let collectionTypeTabBar = CollectionTypeTabBar(collectionTypes: CollectionType.allCases)
        collectionTypeTabBar.translatesAutoresizingMaskIntoConstraints = false
        return collectionTypeTabBar
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
        view.addSubview(collectionTypeTabBar)

        NSLayoutConstraint.activate([
            collectionTypeTabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionTypeTabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionTypeTabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionTypeTabBar.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: collectionTypeTabBar.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIView.padding10),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIView.padding10),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionTypeTabBar.delegate = self
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
    }
}

// MARK: - PhotosListPresenterOutput
extension PhotosListViewController: PhotosListPresenterOutput {

    func clearCollection() {
        DispatchQueue.main.async {
            self.collectionDataSource = nil
            self.photosCollectionView.setContentOffset(.zero, animated: false)
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

    func updateData(collectionViewCellTypes: [ItemCollectionViewCellType]) {
        DispatchQueue.main.async {
            //Clear any placeholder view from collectionView
            self.photosCollectionView.restore()

            // Reload the collectionView
            if self.collectionDataSource == nil {
                self.collectionDataSource = PhotosCollectionViewDataSource(presenterInput: self.presenter, collectionViewCellTypes: collectionViewCellTypes)
                self.photosCollectionView.dataSource = self.collectionDataSource
                self.photosCollectionView.delegate = self.collectionDataSource
                self.photosCollectionView.reloadData()
            } else {

                // Reload only the updated cells

                //Get the inserted section
                let fromIndex = self.collectionDataSource?.collectionViewCellTypes.count ?? 0
                let indexSet = IndexSet(integer: fromIndex)

                self.collectionDataSource?.collectionViewCellTypes = collectionViewCellTypes
                self.photosCollectionView.performBatchUpdates {
                    self.photosCollectionView.insertSections(indexSet)
                }
            }

        }

    }
}

extension PhotosListViewController: CollectionTypeTabBarDelegate {

    func collectionTypeTabBar(_ tabBar: CollectionTypeTabBar, didSelectItem collectionType: CollectionType, at index: Int) {
        presenter?.collectionType = collectionType
    }
}
