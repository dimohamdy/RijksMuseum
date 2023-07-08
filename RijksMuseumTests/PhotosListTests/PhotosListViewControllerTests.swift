//
//  PhotosListViewControllerTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import Foundation
import XCTest
@testable import RijksMuseum
/*
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

        let mockSession = URLSessionMock.createMockSession(fromJsonFile: "data_collection", andStatusCode: 200, andError: nil)
        let repository = getMockWebArtObjectsRepository(mockSession: mockSession)
        let viewModel = PhotosListViewModel(output: photosListViewController, photosRepository: repository)
        photosListViewController.viewModel = viewModel

        // fire search after load viewController and load search history
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            viewModel.collectionType = .coin
            viewModel.search()
        }

        // Check the datasource after search result bind to CollectionView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.photosListViewController.collectionDataSource)
            XCTAssertNotNil(self.photosListViewController.collectionDataSource?.viewModelInput)
            XCTAssertEqual(self.photosListViewController.collectionDataSource?.collectionViewCellTypes.count, 1)
            if case let .section(_, photos) = self.photosListViewController.collectionDataSource?.collectionViewCellTypes.first {
                XCTAssertEqual(photos.count, 10)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

    func getMockWebArtObjectsRepository(mockSession: SessionMock) -> WebArtObjectsRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebArtObjectsRepository(client: mockAPIClient)
    }
}
*/
