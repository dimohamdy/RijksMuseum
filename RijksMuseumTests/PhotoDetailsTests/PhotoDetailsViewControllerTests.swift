//
//  PhotoDetailsViewControllerTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import Foundation
import XCTest
@testable import RijksMuseum

//final class PhotoDetailsViewControllerTests: XCTestCase {
//    var photoDetailsViewController: PhotoDetailsViewController!
//
//    override func tearDown() {
//        photoDetailsViewController = nil
//    }
//
//    func test_search_success() {
//        let expectation = XCTestExpectation()
//
//        let mockSession = URLSessionMock.createMockSession(fromJsonFile: "ArtObjectDetailsResult", andStatusCode: 200, andError: nil)
//        let repository = getMockWebArtObjectsRepository(mockSession: mockSession)
//
//        let artObjectData = DataLoader().loadJsonData(file: "ArtObject")!
//        let artObject = try! JSONDecoder().decode(ArtObject.self, from: artObjectData)
//
//        let logger = ProxyLogger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: PhotoDetailsUseCase.self))
//
//        let photoDetailsUseCase = PhotoDetailsUseCase(photosRepository: repository, logger: logger)
//        let viewModel = PhotoDetailsViewModel(artObject: artObject, photoDetailsUseCase: photoDetailsUseCase)
//        photoDetailsViewController = PhotoDetailsViewController(viewModel: viewModel)
////        viewModel.PhotoDetailsViewModelOutput = photoDetailsViewController
//
//        setupNavigationController()
//
//        // fire search after load viewController and load search history
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            viewModel.getArtObjectDetails()
//        }
//
//        // Check the datasource after search result bind to CollectionView
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            XCTAssertNotNil(self.photoDetailsViewController.tableViewDataSource)
//            XCTAssertEqual(self.photoDetailsViewController.tableViewDataSource?.photoTableViewCellTypes.count, 8)
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 3)
//    }
//
//    private func setupNavigationController() {
//        // Arrange: setup UINavigationController
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
//        keyWindow?.rootViewController = UINavigationController(rootViewController: photoDetailsViewController)
//    }
//
//    private func getMockWebArtObjectsRepository(mockSession: URLSessionMock) -> WebArtObjectsRepository {
//        let mockAPIClient =  APIClient(withSession: mockSession)
//        return WebArtObjectsRepository(client: mockAPIClient)
//    }
//}
