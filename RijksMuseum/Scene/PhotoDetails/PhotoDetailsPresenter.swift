//
//  PhotoDetailsPresenter.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import Foundation

enum PhotoTableViewCellType {
    case photoCell(model: PhotoTableViewCell.UIModel)
    case detailsCell(model: DetailsTableViewCell.UIModel)
}

// MARK: PhotoDetailsPresenterInput

protocol PhotoDetailsPresenterInput: AnyObject {
    func getData()
}

// MARK: PhotoDetailsPresenterOutput

protocol PhotoDetailsPresenterOutput: BasePresenterOutput {
    func updateData(photoTableViewCellTypes: [PhotoTableViewCellType])
}

final class PhotoDetailsPresenter {

    // input
    private let detailsArtObject: ArtObjectDetails
    private let photosRepository: WebArtObjectsRepository

    // output
    weak var photoDetailsPresenterOutput: PhotoDetailsPresenterOutput? {
        didSet {
            let cells = self.getActivePhotoCell(photo: detailsArtObject)
            photoDetailsPresenterOutput?.updateData(photoTableViewCellTypes: cells)
        }
    }

    init(artObject: ArtObject, photosRepository: WebArtObjectsRepository = WebArtObjectsRepository()) {
        self.detailsArtObject = ArtObjectDetails(artObject: artObject)
        self.photosRepository = photosRepository
    }

    // MARK: - Mapping to PhotoTableViewCellType

    private func getActivePhotoCell(photo: ArtObjectDetails) -> [PhotoTableViewCellType] {
        var cellTypes: [PhotoTableViewCellType] = []
        let photoCellType = PhotoTableViewCellType.photoCell(model: PhotoTableViewCell.UIModel(photoURL: photo.webImage.url))
        cellTypes.append(photoCellType)

        cellTypes.append(detailsModel(title: Strings.title.localized(), subTitle: photo.title))

        cellTypes.append(detailsModel(title: Strings.principalOrFirstMaker.localized(), subTitle: photo.principalOrFirstMaker))

        if let longTitle = photo.longTitle {
            cellTypes.append(detailsModel(title: Strings.longTile.localized(), subTitle: longTitle))
        }

        if let description = photo.description {
            cellTypes.append(detailsModel(title: Strings.description.localized(), subTitle: description))
        }

        let formatter = ListFormatter()

        if let materials = photo.materials, let materialsString = formatter.string(from: materials) {
            cellTypes.append(detailsModel(title: Strings.materials.localized(), subTitle: materialsString))
        }

        if let techniques = photo.techniques, let techniquesString = formatter.string(from: techniques) {
            cellTypes.append(detailsModel(title: Strings.techniques.localized(), subTitle: techniquesString))
        }

        if let subTitle = photo.subTitle {
            cellTypes.append(detailsModel(title: Strings.subTitle.localized(), subTitle: subTitle))
        }
        return cellTypes
    }

    private func detailsModel(title: String, subTitle: String) -> PhotoTableViewCellType {
        return PhotoTableViewCellType.detailsCell(model: DetailsTableViewCell.UIModel(title: title, subTitle: subTitle))
    }
}

// MARK: PhotoDetailsPresenterInput

extension PhotoDetailsPresenter: PhotoDetailsPresenterInput {
    func getData() {

        photosRepository.artObjectDetails(for: detailsArtObject.objectNumber) { [weak self] result in
            guard let self =  self else {
                return
            }
            self.photoDetailsPresenterOutput?.hideLoading()

            switch result {
            case .success(let detailsArtObjectResult):
                let cells = self.getActivePhotoCell(photo: detailsArtObjectResult.artObject)
                self.photoDetailsPresenterOutput?.updateData(photoTableViewCellTypes: cells)

            case .failure(let error):
                self.photoDetailsPresenterOutput?.showError(error: error)

            }
        }
    }
}
