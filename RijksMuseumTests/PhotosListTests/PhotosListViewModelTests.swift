//
//  PhotosListViewModelTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import XCTest
import Combine
@testable import RijksMuseum

final class PhotosListViewModelTests: XCTestCase {
    private var cancellable = Set<AnyCancellable>()

    func test_search_success() throws {
        let expectation = XCTestExpectation()

        let viewModel = getPhotosListViewModel(fromJsonFile: "data_collection")
        viewModel.search()
        viewModel.$state.receive(on: DispatchQueue.main).sink { state in
            if case let .loaded(collectionViewCellType) = state {
                if case let .section(section , photos) = collectionViewCellType {
                    XCTAssertEqual(section,  "\(Strings.page.localized) 1")
                    XCTAssertEqual(photos.count, 10)
                }
            }
            expectation.fulfill()
        }.store(in: &cancellable)
        wait(for: [expectation], timeout: 3)
    }

    func test_loadMore_success() throws {
        let expectation = XCTestExpectation()
        let viewModel = getPhotosListViewModel(fromJsonFile: "data_collection")
        viewModel.loadMoreData(1)
        viewModel.$state.receive(on: DispatchQueue.main).sink { state in
            if case let .loaded(.section(section , photos)) = state {
                XCTAssertEqual(section,  "\(Strings.page.localized) 2")
                XCTAssertEqual(photos.count, 10)
            }
            expectation.fulfill()
        }.store(in: &cancellable)
        wait(for: [expectation], timeout: 3)
    }

    func test_search_noResult() throws {
        let expectation = XCTestExpectation()
        let viewModel = getPhotosListViewModel(fromJsonFile: "noData_collection")
        viewModel.search()
        viewModel.$state.receive(on: DispatchQueue.main).sink { state in
            if case let .loaded(.section(section , photos)) = state {
                XCTAssertEqual(section,  "\(Strings.page.localized) 1")
                XCTAssertEqual(photos.count, 10)
            }
            expectation.fulfill()
        }.store(in: &cancellable)
        wait(for: [expectation], timeout: 3)
    }

    func test_search_noInternetConnection() throws {
        let expectation = XCTestExpectation()
        let viewModel = getPhotosListViewModel(fromJsonFile: "noData_collection")
        viewModel.search()
        viewModel.$state.receive(on: DispatchQueue.main).sink { state in
            if case let .placeholder(placeholder) = state {
                XCTAssertEqual(placeholder, EmptyPlaceHolderType.noResults)
            }
            expectation.fulfill()
        }.store(in: &cancellable)

        wait(for: [expectation], timeout: 3)
    }

    private func getMockWebArtObjectsRepository(mockSession: URLSessionMock) -> WebArtObjectsRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebArtObjectsRepository(client: mockAPIClient)
    }

    private func getPhotosListViewModel(fromJsonFile file: String) -> PhotosListViewModel {
        let mockSession = URLSessionMock.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        let repository = getMockWebArtObjectsRepository(mockSession: mockSession)
        let logger = ProxyLogger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: PhotosListUseCase.self))
        let photosListUseCase = PhotosListUseCase(photosRepository: repository,  logger: logger)
        return PhotosListViewModel(photosListUseCase: photosListUseCase)
    }
}
