//
//  PhotoDetailsPresenter.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import Foundation

enum PhotoTableViewCellType {
    case photoCell(model: PhotoCell.UIModel)
    case detailsCell(model: DetailsCell.UIModel)
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
    private let detailsArtObject: DetailsArtObject
    private let photosRepository: WebArtObjectsRepository

    // output
    weak var photoDetailsPresenterOutput: PhotoDetailsPresenterOutput?

    init(artObject: ArtObject, photosRepository: WebArtObjectsRepository = WebArtObjectsRepository()) {
        self.detailsArtObject = DetailsArtObject(artObject: artObject)
        self.photosRepository = photosRepository
        updateUI()
    }

    private func updateUI() {
        let cells = self.getActivePhotoCell(photo: detailsArtObject)
        photoDetailsPresenterOutput?.updateData(photoTableViewCellTypes: cells)
    }

    // MARK: - Mapping to PhotoTableViewCellType

    private func getActivePhotoCell(photo: DetailsArtObject) -> [PhotoTableViewCellType] {
        var cellTypes: [PhotoTableViewCellType] = []
        let photoCellType = PhotoTableViewCellType.photoCell(model: PhotoCell.UIModel(photoURL: photo.webImage.url))
        cellTypes.append(photoCellType)

        cellTypes.append(detailsModel(title: "Title", subTitle: photo.title))
        cellTypes.append(detailsModel(title: "Long Title", subTitle: photo.longTitle))

        cellTypes.append(detailsModel(title: "Principal or First Maker", subTitle: photo.principalOrFirstMaker))

        if let description = photo.description {
            cellTypes.append(detailsModel(title: "Description", subTitle: description))
        }

        let formatter = ListFormatter()

        if let materials = photo.materials, let materialsString = formatter.string(from: materials) {
            cellTypes.append(detailsModel(title: "Materials", subTitle: materialsString))
        }

        if let techniques = photo.techniques, let techniquesString = formatter.string(from: techniques) {
            cellTypes.append(detailsModel(title: "Techniques", subTitle: techniquesString))
        }

        if let subTitle = photo.subTitle {
            cellTypes.append(detailsModel(title: "SubTitle", subTitle: subTitle))
        }
        return cellTypes
    }

    private func detailsModel(title: String, subTitle: String) -> PhotoTableViewCellType {
        return PhotoTableViewCellType.detailsCell(model: DetailsCell.UIModel(title: title, subTitle: subTitle))
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
                print(error.localizedDescription)
//                self.photoDetailsPresenterOutput?.updateData(error: RijksMuseumError.noResults)

            }

        }
    }
}
