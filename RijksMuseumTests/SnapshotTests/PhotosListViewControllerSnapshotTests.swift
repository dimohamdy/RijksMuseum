//
//  PhotosListViewControllerTests.swift
//  PhotosTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import Foundation
import SnapshotTesting
@testable import RijksMuseum
import XCTest
import Network

final class PhotosListViewControllerSnapshotTests: XCTestCase {
    var photosListViewController: PhotosListViewController!

    override func tearDown() {
        photosListViewController = nil
    }

    func test_snapshot_get_onlinePhotos_success() {
        setVC(internetConnectionState: .satisfied)
        assertSnapshot(matching: photosListViewController, as: .wait(for: 5, on: .image))
    }

    func test_snapshot_noResult() {
        let connectToInternet = MockReachability(internetConnectionState: .satisfied)
        let dataProvider: ArtObjectsRepository =  MockNoDataPhotosRepository()
        photosListViewController = PhotosListBuilder.viewController(artObjectsRepository: dataProvider, reachable: connectToInternet)
        let view = photosListViewController.view
        assertSnapshot(matching: photosListViewController, as: .wait(for: 5, on: .image))
    }

    func test_snapshot_noInternet_NoOfflinePhotos() {
        setVC(internetConnectionState: .unsatisfied)
        assertSnapshot(matching: photosListViewController, as: .wait(for: 5, on: .image))
    }
}

extension PhotosListViewControllerSnapshotTests {

    func setVC(internetConnectionState: NWPath.Status) {
        let connectToInternet = MockReachability(internetConnectionState: internetConnectionState)
        let dataProvider: ArtObjectsRepository =  internetConnectionState == .satisfied ? MockDataPhotosRepository() : MockNoDataPhotosRepository()
        photosListViewController = PhotosListBuilder.viewController(artObjectsRepository: dataProvider, reachable: connectToInternet)
        let view = photosListViewController.view
    }
}
