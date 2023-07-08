//
//  PhotoDetailsViewModelTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import XCTest
@testable import RijksMuseum
import Combine

final class PhotoDetailsViewModelTests: XCTestCase {

    private var cancellable = Set<AnyCancellable>()

    func test_getData_success() {
        let expectation = XCTestExpectation()

        let viewModel = getPhotoDetailsViewModel(reachable: MockReachability(internetConnectionState: .satisfied), fromJsonFile: "ArtObjectDetailsResult")

        viewModel.getArtObjectDetails()
        viewModel.$state.dropFirst(1).receive(on: DispatchQueue.main).sink { state in
            if case let .loaded( photoTableViewCellType) = state {
                XCTAssertEqual(photoTableViewCellType.count, 8)
            }
            expectation.fulfill()
        }.store(in: &cancellable)

        wait(for: [expectation], timeout: 8)
    }

    func test_getData_noResult() {
        let expectation = XCTestExpectation()
        let viewModel = getPhotoDetailsViewModel(reachable: MockReachability(internetConnectionState: .unsatisfied), fromJsonFile: "noData_collection")
        viewModel.getArtObjectDetails()
        viewModel.$state.receive(on: DispatchQueue.main).sink { state in
            if case let .loaded(photoTableViewCellType) = state {
                XCTAssertEqual(photoTableViewCellType.count, 3)
            }
            expectation.fulfill()

        }.store(in: &cancellable)
        wait(for: [expectation], timeout: 3)
    }

    func test_getData_noInternetConnection() {
        let expectation = XCTestExpectation()

        let viewModel = getPhotoDetailsViewModel(reachable: MockReachability(internetConnectionState: .unsatisfied), fromJsonFile: "noData_collection")
        viewModel.getArtObjectDetails()

        viewModel.$state.sink { state in
            if case let .loaded(photoTableViewCellType) = state {
                XCTAssertEqual(photoTableViewCellType.count, 3)
            }
            expectation.fulfill()

        }.store(in: &cancellable)
        wait(for: [expectation], timeout: 3)
    }

    private func getMockWebArtObjectsRepository(mockSession: URLSessionMock) -> WebArtObjectsRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebArtObjectsRepository(client: mockAPIClient)
    }

    private func getPhotoDetailsViewModel(reachable: Reachable, fromJsonFile file: String) -> PhotoDetailsViewModel {
        let mockSession = URLSessionMock.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        let repository = getMockWebArtObjectsRepository(mockSession: mockSession)
        let artObjectData = DataLoader().loadJsonData(file: "ArtObject")!
        let artObject =  try! JSONDecoder().decode(ArtObject.self, from: artObjectData)
        let logger = ProxyLogger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: PhotosListUseCase.self))
        let photoDetailsUseCase = PhotoDetailsUseCase(photosRepository: repository, reachable: reachable , logger: logger)
        let viewModel = PhotoDetailsViewModel(artObject: artObject, photoDetailsUseCase: photoDetailsUseCase)
        return viewModel
    }
}
