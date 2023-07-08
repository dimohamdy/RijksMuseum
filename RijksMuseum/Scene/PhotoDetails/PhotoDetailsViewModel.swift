//
//  PhotoDetailsViewModel.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import Foundation

enum PhotoTableViewCellType {
    case photoCell(model: PhotoTableViewCell.UIModel)
    case detailsCell(model: DetailsTableViewCell.UIModel)
}

final class PhotoDetailsViewModel {

    // input
    private let detailsArtObject: ArtObjectDetails
    private let photoDetailsUseCase: PhotoDetailsUseCaseProtocol

    // MARK: Internal
    @Published private(set) var title: String
    @Published private(set) var state: ListViewModelState<[PhotoTableViewCellType]> = .loading(show: true)
    @Published private(set) var showErrorAlert: RijksMuseumAlert?

    init(artObject: ArtObject, photoDetailsUseCase: PhotoDetailsUseCaseProtocol) {
        self.title = artObject.title
        self.detailsArtObject = ArtObjectDetails(artObject: artObject)
        self.photoDetailsUseCase = photoDetailsUseCase
        state = .loaded(data: convertArtObjectToCells(photo: detailsArtObject))
    }

    // MARK: - Mapping to PhotoTableViewCellType

    private func convertArtObjectToCells(photo: ArtObjectDetails) -> [PhotoTableViewCellType] {
        var cellTypes: [PhotoTableViewCellType] = []
        let photoCellType = PhotoTableViewCellType.photoCell(model: PhotoTableViewCell.UIModel(photoURL: photo.webImage.url))
        cellTypes.append(photoCellType)

        cellTypes.append(detailsModel(title: Strings.title.localized,
                                      subTitle: photo.title,
                                      accessibilityIdentifier: AccessibilityIdentifiers.PhotoDetailsViewController.titleId))

        cellTypes.append(detailsModel(title: Strings.principalOrFirstMaker.localized,
                                      subTitle: photo.principalOrFirstMaker,
                                      accessibilityIdentifier: AccessibilityIdentifiers.PhotoDetailsViewController.principalOrFirstMakerId))

        if let longTitle = photo.longTitle {
            cellTypes.append(detailsModel(title: Strings.longTile.localized,
                                          subTitle: longTitle,
                                          accessibilityIdentifier: AccessibilityIdentifiers.PhotoDetailsViewController.longTitleId))
        }

        if let description = photo.description {
            cellTypes.append(detailsModel(title: Strings.description.localized,
                                          subTitle: description,
                                          accessibilityIdentifier: AccessibilityIdentifiers.PhotoDetailsViewController.descriptionId))
        }

        let formatter = ListFormatter()

        if let materials = photo.materials, let materialsString = formatter.string(from: materials) {
            cellTypes.append(detailsModel(title: Strings.materials.localized,
                                          subTitle: materialsString,
                                          accessibilityIdentifier: AccessibilityIdentifiers.PhotoDetailsViewController.materialsId))
        }

        if let techniques = photo.techniques, let techniquesString = formatter.string(from: techniques) {
            cellTypes.append(detailsModel(title: Strings.techniques.localized,
                                          subTitle: techniquesString,
                                          accessibilityIdentifier: AccessibilityIdentifiers.PhotoDetailsViewController.techniquesId))
        }

        if let subTitle = photo.subTitle {
            cellTypes.append(detailsModel(title: Strings.subTitle.localized,
                                          subTitle: subTitle,
                                          accessibilityIdentifier: AccessibilityIdentifiers.PhotoDetailsViewController.subTitleId))
        }
        return cellTypes
    }

    private func detailsModel(title: String, subTitle: String, accessibilityIdentifier: String) -> PhotoTableViewCellType {
        return PhotoTableViewCellType.detailsCell(model: DetailsTableViewCell.UIModel(title: title, subTitle: subTitle, accessibilityIdentifier: accessibilityIdentifier))
    }
}

// MARK: PhotoDetailsViewModelInput

extension PhotoDetailsViewModel {

    func getArtObjectDetails() {
        Task {
            do {
                state = .loading(show: true)
                let artObjectDetailsResult = try await photoDetailsUseCase.artObjectDetails(for: detailsArtObject.objectNumber)
                let cells = self.convertArtObjectToCells(photo: artObjectDetailsResult.artObject)
                state = .loaded(data: cells)
            } catch let error {
                showErrorAlert = RijksMuseumAlert(title: Strings.commonGeneralError.localized, subtitle: error.localizedDescription)
            }
        }
    }

}
