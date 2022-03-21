//
//  PhotosListViewControllerTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import Foundation
import XCTest
@testable import RijksMuseum

final class PhotosListViewControllerTests: XCTestCase {
    var photosListViewController: PhotosListViewController!
    override func setUp() {
        super.setUp()
        photosListViewController =  PhotosListBuilder.viewController()

        // Arrange: setup UINavigationController
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = UINavigationController(rootViewController: photosListViewController)
    }

    override func tearDown() {
        photosListViewController = nil
    }

    func test_search_success() {
        let expectation = XCTestExpectation()

        let mockSession = MockURLSession.createMockSession(fromJsonFile: "data_collection", andStatusCode: 200, andError: nil)
        let repository = getMockWebArtObjectsRepository(mockSession: mockSession)
        let presenter = PhotosListPresenter(output: photosListViewController, photosRepository: repository)
        photosListViewController.presenter = presenter

        // fire search after load viewController and load search history
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presenter.collectionType = .coin
            presenter.search()
        }

        // Check the datasource after search result bind to CollectionView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.photosListViewController.collectionDataSource)
            XCTAssertNotNil(self.photosListViewController.collectionDataSource?.presenterInput)
            XCTAssertEqual(self.photosListViewController.collectionDataSource?.itemsForCollection.count, 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

    func getMockWebArtObjectsRepository(mockSession: MockURLSession) -> WebArtObjectsRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebArtObjectsRepository(client: mockAPIClient)
    }
}
