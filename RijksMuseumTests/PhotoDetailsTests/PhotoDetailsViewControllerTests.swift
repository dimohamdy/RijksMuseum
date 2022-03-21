//
//  PhotoDetailsViewControllerTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import Foundation
import XCTest
@testable import RijksMuseum

final class PhotoDetailsViewControllerTests: XCTestCase {
    var photoDetailsViewController: PhotoDetailsViewController!

    override func tearDown() {
        photoDetailsViewController = nil
    }

    func test_search_success() {
        let expectation = XCTestExpectation()

        let mockSession = MockURLSession.createMockSession(fromJsonFile: "ArtObjectDetailsResult", andStatusCode: 200, andError: nil)
        let repository = getMockWebArtObjectsRepository(mockSession: mockSession)

        let artObjectData = DataLoader().loadJsonData(file: "ArtObject")!
        let artObject = try! JSONDecoder().decode(ArtObject.self, from: artObjectData)

        let presenter = PhotoDetailsPresenter(artObject: artObject, photosRepository: repository)
        photoDetailsViewController = PhotoDetailsViewController(presenter: presenter)
        presenter.photoDetailsPresenterOutput = photoDetailsViewController

        setupNavigationController()

        // fire search after load viewController and load search history
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presenter.getData()
        }

        // Check the datasource after search result bind to CollectionView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.photoDetailsViewController.tableViewDataSource)
            XCTAssertEqual(self.photoDetailsViewController.tableViewDataSource?.photoTableViewCellTypes.count, 8)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }

    private func setupNavigationController() {
        // Arrange: setup UINavigationController
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = UINavigationController(rootViewController: photoDetailsViewController)
    }

    private func getMockWebArtObjectsRepository(mockSession: MockURLSession) -> WebArtObjectsRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebArtObjectsRepository(client: mockAPIClient)
    }
}
