//
//  PhotosListPresenterTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import XCTest
@testable import RijksMuseum

final class PhotosListPresenterTests: XCTestCase {
    var mockPhotosListPresenterOutput: MockPhotosListPresenterOutput!

    override func setUp() {
        mockPhotosListPresenterOutput = MockPhotosListPresenterOutput()
    }

    override func tearDown() {
        mockPhotosListPresenterOutput = nil
        Reachability.shared = MockReachability(internetConnectionState: .satisfied)
    }

    func test_search_success() {
        let presenter = getPhotosListPresenter(fromJsonFile: "data_collection")
        presenter.collectionType = .coin
        XCTAssertEqual(mockPhotosListPresenterOutput.collectionViewCellTypes.count, 1)
    }

    func test_loadMore_success() {
        let presenter = getPhotosListPresenter(fromJsonFile: "data_collection")
        presenter.collectionType = .cup
        presenter.loadMoreData(2)
        XCTAssertEqual(mockPhotosListPresenterOutput.collectionViewCellTypes.count, 2)
    }

    func test_search_noResult() {
        let presenter = getPhotosListPresenter(fromJsonFile: "noData_collection")
        presenter.collectionType = .print
        presenter.search()
        XCTAssertEqual(mockPhotosListPresenterOutput.collectionViewCellTypes.count, 0)
        if let error = mockPhotosListPresenterOutput.error as? RijksMuseumError {
            switch error {
            case .noResults:
                XCTAssertTrue(true)
            default:
                XCTFail("the error isn't noResults")
            }
        }
    }

    func test_search_noInternetConnection() {
        Reachability.shared =  MockReachability(internetConnectionState: .unsatisfied)
        let presenter = getPhotosListPresenter(fromJsonFile: "noData_collection")
        presenter.search()
        XCTAssertEqual(mockPhotosListPresenterOutput.collectionViewCellTypes.count, 0)
        if let error = mockPhotosListPresenterOutput.error as? RijksMuseumError {
            switch error {
            case .noInternetConnection:
                XCTAssertTrue(true)
            default:
                XCTFail("the error isn't noResults")
            }
        }
    }

    private func getMockWebArtObjectsRepository(mockSession: MockURLSession) -> WebArtObjectsRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebArtObjectsRepository(client: mockAPIClient)
    }

    private func getPhotosListPresenter(fromJsonFile file: String) -> PhotosListPresenter {
        let mockSession = MockURLSession.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        let repository = getMockWebArtObjectsRepository(mockSession: mockSession)
        mockPhotosListPresenterOutput.collectionViewCellTypes = []
        return PhotosListPresenter(output: mockPhotosListPresenterOutput, photosRepository: repository)
    }
}

final class MockPhotosListPresenterOutput: UIViewController, PhotosListPresenterOutput {
    func clearCollection() {

    }

    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {

    }

    var collectionViewCellTypes: [ItemCollectionViewCellType] = []
    var error: Error!

    func updateData(error: Error) {
        self.error = error
    }

    func updateData(collectionViewCellType: ItemCollectionViewCellType) {
        self.collectionViewCellTypes.append(collectionViewCellType)
        print(collectionViewCellTypes.count)
    }
}
