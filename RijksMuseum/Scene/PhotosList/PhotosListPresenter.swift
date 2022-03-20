//
//  PhotosListPresenter.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import Foundation

protocol PhotosListPresenterInput: BasePresenterInput {
    func search()
    func loadMoreData(_ page: Int)
    func showDetails(artObject: ArtObject)
    var collectionType: CollectionType { get set }
}

protocol PhotosListPresenterOutput: BasePresenterOutput {
    func clearCollection()
    func updateData(error: Error)
    func updateData(itemsForCollection: [ItemCollectionViewCellType])
    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType)
}

final class PhotosListPresenter {
    
    // MARK: Injections
    private weak var output: PhotosListPresenterOutput?
    private let photosRepository: WebArtObjectsRepository

    var router: PhotoListRouter?

    fileprivate var page: Int = 1
    fileprivate var canLoadMore = true
    // internal
    private var itemsForCollection: [ItemCollectionViewCellType] = [ItemCollectionViewCellType]()
    
    var collectionType: CollectionType = .print {
        didSet {
            search()
        }
    }
    
    // MARK: LifeCycle
    init(output: PhotosListPresenterOutput, photosRepository: WebArtObjectsRepository = WebArtObjectsRepository()) {
        
        self.output = output
        self.photosRepository = photosRepository
        [Notifications.Reachability.connected.name,
         Notifications.Reachability.notConnected.name].forEach { (notification) in
            NotificationCenter.default.addObserver(self, selector: #selector(changeInternetConnection), name: notification, object: nil)
        }
    }
}

// MARK: - PhotosListPresenterInput
extension PhotosListPresenter: PhotosListPresenterInput {

    func search() {
        itemsForCollection = []
        output?.clearCollection()
        self.page = 1
        self.canLoadMore = true
        getData(collectionType: collectionType)
    }
    
    func loadMoreData(_ page: Int) {
        if self.page <= page && canLoadMore == true {
            self.page = page
            getData(collectionType: collectionType)
        }
    }

    func showDetails(artObject: ArtObject) {
        // show ArtObject
        router?.show(artObject: artObject)
    }
    
    @objc
    private func changeInternetConnection(notification: Notification) {
        if notification.name == Notifications.Reachability.notConnected.name {
            output?.showError(title: Strings.noInternetConnectionTitle.localized(), subtitle: Strings.noInternetConnectionSubtitle.localized())
            output?.updateData(error: RijksMuseumError.noInternetConnection)
        }
    }
}

// MARK: Setup

extension PhotosListPresenter {
    
    private func getData(collectionType: CollectionType) {
        
        guard Reachability.shared.isConnected else {
            self.output?.updateData(error: RijksMuseumError.noInternetConnection)
            return
        }
        output?.showLoading()
        canLoadMore = false
        
        photosRepository.artObjects(for: collectionType.rawValue, page: page) { [weak self] result in
            
            guard let self =  self else {
                return
            }
            self.output?.hideLoading()
            
            switch result {
            case .success(let searchResult):
                guard !searchResult.artObjects.isEmpty else {
                    self.handleNoPhotos()
                    return
                }
                self.handleNewPhotos(photos: searchResult.artObjects)
                self.canLoadMore = true
                
            case .failure(let error):
                self.output?.updateData(error: error)
            }
        }
    }
    
    private func handleNewPhotos(photos: [ArtObject]) {
        let newItems: [ItemCollectionViewCellType] = createItemsForCollection(photosArray: photos)
        itemsForCollection.append(contentsOf: newItems)
        if itemsForCollection.isEmpty {
            output?.updateData(error: RijksMuseumError.noResults)
        } else {
            output?.updateData(itemsForCollection: itemsForCollection)
        }
    }
    
    private func handleNoPhotos() {
        if  itemsForCollection.isEmpty {
            output?.updateData(error: RijksMuseumError.noResults)
        }
    }
    
    private func createItemsForCollection(photosArray: [ArtObject]) -> [ItemCollectionViewCellType] {
        return photosArray.map { photo -> ItemCollectionViewCellType  in
                .photo(photo: photo)
        }
    }
}
