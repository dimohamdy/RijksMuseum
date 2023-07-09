//
//  PhotosListViewModel.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import Foundation
import Combine

protocol PhotosListViewModelInput: AnyObject {
    func showDetails(artObject: ArtObject)
    func loadMoreData(_ page: Int)
}

final class PhotosListViewModel {

    // MARK: Injections
    private let photosListUseCase: PhotosListUseCaseProtocol

    var router: PhotoListRouter?

    // MARK: Internal
    @Published private(set) var title = Strings.rijksMuseumTitle.localized
    @Published private(set) var state: ListViewModelState<ItemCollectionViewCellType> = .loading(show: true)
    @Published private(set) var showErrorAlert: RijksMuseumAlert?

    private var reachabilityCancellable: AnyCancellable?

    // MARK: LifeCycle
    init(photosListUseCase: PhotosListUseCaseProtocol, reachable: Reachable = Reachability.shared) {
        self.photosListUseCase = photosListUseCase
        [Notifications.Reachability.connected.name,
         Notifications.Reachability.notConnected.name].forEach { (notification) in
            NotificationCenter.default.addObserver(self, selector: #selector(changeInternetConnection), name: notification, object: nil)
        }

        reachabilityCancellable = reachable.isConnected.sink(receiveValue: { [weak self] isConnected in
            if isConnected {
                self?.search()
            }
        })
    }

    @objc
    private func changeInternetConnection(notification: Notification) {
        if notification.name == Notifications.Reachability.notConnected.name {
            if photosListUseCase.haveData {
                showErrorAlert = RijksMuseumAlert(title: Strings.noInternetConnectionTitle.localized, subtitle: Strings.noInternetConnectionSubtitle.localized)

            } else {
                state = .placeholder(emptyPlaceHolderType: .noInternetConnection)
            }
        }
    }
}

// MARK: - PhotosListViewModelInput
extension PhotosListViewModel: PhotosListViewModelInput {

    func showDetails(artObject: ArtObject) {
        // show ArtObject
        router?.show(artObject: artObject)
    }

    func search() {
        state = .loading(show: true)
        Task {
            do {
                let photos = try await photosListUseCase.search()
                handleNewPhotos(photos: photos)
            } catch let error {
                handle(error: error)
            }
        }
    }

    func loadMoreData(_ page: Int) {
        state = .loading(show: true)
        Task {
            do {
                let photos = try await photosListUseCase.loadMoreArtObjects(page)
                handleNewPhotos(photos: photos)
            } catch let error {
                handle(error: error)
            }
        }
    }
}

// MARK: Setup

extension PhotosListViewModel {

    private func handleNewPhotos(photos: [ArtObject]) {
        state = .loading(show: false)
        let newSection: ItemCollectionViewCellType = createItemsForCollection(photosArray: photos)
        if !photosListUseCase.haveData {
            state = .placeholder(emptyPlaceHolderType: .noResults)
        } else {
            state = .loaded(data: newSection)
        }
    }

    private func handle(error: Error) {
        state = .loading(show: false)
        guard let error = error as? RijksMuseumError, error != .canNotLoadMore  else {
            return
        }
        guard !photosListUseCase.haveData else {
            showErrorAlert = RijksMuseumAlert(title: Strings.commonGeneralError.localized, subtitle: error.localizedDescription)
            return
        }
        if error ==  RijksMuseumError.noResults {
            state = .placeholder(emptyPlaceHolderType: .noResults)
        } else if error ==  RijksMuseumError.noInternetConnection {
            state = .placeholder(emptyPlaceHolderType: .noInternetConnection)
        } else {
            state = .placeholder(emptyPlaceHolderType: .error(message: error.localizedDescription))
        }
    }

    private func handleNoPhotos() {
        state = .loading(show: false)
        if !photosListUseCase.haveData {
            state = .placeholder(emptyPlaceHolderType: .noResults)
        }
    }

    private func createItemsForCollection(photosArray: [ArtObject]) -> ItemCollectionViewCellType {
        return .section(section: Strings.page.localized + " \(photosListUseCase.page + 1)", photos: photosArray)
    }
}
