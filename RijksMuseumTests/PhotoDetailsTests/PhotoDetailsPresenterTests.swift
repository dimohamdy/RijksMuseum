//
//  PhotoDetailsPresenterTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import XCTest
@testable import RijksMuseum

final class PhotoDetailsPresenterTests: XCTestCase {
    var mockPhotoDetailsPresenterOutput: MockPhotoDetailsPresenterOutput!

    override func setUp() {
        mockPhotoDetailsPresenterOutput = MockPhotoDetailsPresenterOutput()
    }

    override func tearDown() {
        mockPhotoDetailsPresenterOutput = nil
        Reachability.shared =  MockReachability(internetConnectionState: .satisfied)
    }

    func test_getData_success() {
        let presenter = getPhotoDetailsPresenter(fromJsonFile: "ArtObjectDetailsResult")
        presenter.getData()
        XCTAssertEqual(mockPhotoDetailsPresenterOutput.photoTableViewCellType.count, 8)
    }

    func test_getData_noResult() {
        let presenter = getPhotoDetailsPresenter(fromJsonFile: "noData_collection")
        presenter.getData()
        XCTAssertEqual(mockPhotoDetailsPresenterOutput.photoTableViewCellType.count, 3)
        if let error = mockPhotoDetailsPresenterOutput.error as? RijksMuseumError {
            switch error {
            case .noResults:
                XCTAssertTrue(true)
            default:
                XCTFail("the error isn't noResults")
            }
        }
    }

    func test_getData_noInternetConnection() {
        Reachability.shared =  MockReachability(internetConnectionState: .unsatisfied)
        let presenter = getPhotoDetailsPresenter(fromJsonFile: "noData_collection")
        presenter.getData()
        XCTAssertEqual(mockPhotoDetailsPresenterOutput.photoTableViewCellType.count, 3)
        if let error = mockPhotoDetailsPresenterOutput.error as? RijksMuseumError {
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

    private func getPhotoDetailsPresenter(fromJsonFile file: String) -> PhotoDetailsPresenter {
        let mockSession = MockURLSession.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        let repository = getMockWebArtObjectsRepository(mockSession: mockSession)
        let artObjectData = DataLoader().loadJsonData(file: "ArtObject")!
        let artObject =  try! JSONDecoder().decode(ArtObject.self, from: artObjectData)
        let presenter = PhotoDetailsPresenter(artObject: artObject, photosRepository: repository)
        presenter.photoDetailsPresenterOutput = mockPhotoDetailsPresenterOutput
        return presenter
    }
}

final class MockPhotoDetailsPresenterOutput: UIViewController, PhotoDetailsPresenterOutput {

    var photoTableViewCellType: [PhotoTableViewCellType] = []
    var error: Error!

    func updateData(error: Error) {
        self.error = error
    }

    func updateData(photoTableViewCellTypes: [PhotoTableViewCellType]) {
        self.photoTableViewCellType = photoTableViewCellTypes
    }
}
