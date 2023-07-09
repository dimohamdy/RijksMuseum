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


final class PhotoDetailsViewControllerSnapshotTests: XCTestCase {
    var photoDetailsViewController: PhotoDetailsViewController!

    override func tearDown() {
        photoDetailsViewController = nil
    }

    func test_snapshot_show_ArtObject_details_success() {
        setVC(internetConnectionState: .satisfied)
        assertSnapshot(matching: photoDetailsViewController, as: .wait(for: 2, on: .image))
    }

    func test_snapshot_noInternet_show_ArtObject_success() {
        setVC(internetConnectionState: .unsatisfied)
        assertSnapshot(matching: photoDetailsViewController, as: .wait(for: 2, on: .image))
    }
}

extension PhotoDetailsViewControllerSnapshotTests {

    func setVC(internetConnectionState: NWPath.Status) {
        let connectToInternet = MockReachability(internetConnectionState: internetConnectionState)
        let dataProvider: ArtObjectsRepository =  internetConnectionState == .satisfied ? MockDataPhotosRepository() : MockNoDataPhotosRepository()
        let artObjectData = DataLoader().loadJsonData(file: "ArtObject")!
        let artObject = try! JSONDecoder().decode(ArtObject.self, from: artObjectData)
        photoDetailsViewController = PhotoDetailsBuilder.viewController(photo: artObject, artObjectsRepository: dataProvider, reachable: connectToInternet)
        photoDetailsViewController.overrideUserInterfaceStyle = .light

        let view = photoDetailsViewController.view
    }
}
