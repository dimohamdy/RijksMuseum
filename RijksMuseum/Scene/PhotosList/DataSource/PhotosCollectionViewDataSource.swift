//
//  PhotosCollectionViewDataSource.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

final class PhotosCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var collectionViewCellTypes: [ItemCollectionViewCellType?] = []

    weak var presenterInput: PhotosListPresenterInput?

    private struct CellHeightConstant {
        static let heightOfPhotoCell: CGFloat = 120
    }

    init(presenterInput: PhotosListPresenterInput?, collectionViewCellTypes: [ItemCollectionViewCellType?]) {
        self.collectionViewCellTypes = collectionViewCellTypes
        self.presenterInput = presenterInput
    }

    // MARK: - Collection view data source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewCellTypes.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if case let .section(_, photos) = collectionViewCellTypes[section] {
            return photos.count
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard case let .section(_, photos) = collectionViewCellTypes[indexPath.section] else {
            return UICollectionViewCell()
        }
        let artObject = photos[indexPath.row]
        if let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(for: indexPath) {
            cell.configCell(model: PhotoCollectionCell.UIModel(artObject: artObject))
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if case .section = collectionViewCellTypes[indexPath.section] {
            return getPhotoCellSize(collectionView: collectionView)
        } else {
            return getPhotoCellSize(collectionView: collectionView)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if case UICollectionView.elementKindSectionHeader = kind {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: PageHeaderCollectionCell.identifier,
                                                                                for: indexPath)  as? PageHeaderCollectionCell {
                if case let .section(page, _) = collectionViewCellTypes[indexPath.section] {
                    headerView.configCell(pageNumber: page)
                }
                return headerView
            }
        }
        assert(false, "Unexpected element kind")
    }

    private func getPhotoCellSize(collectionView: UICollectionView) -> CGSize {
        let widthAndHeight = collectionView.bounds.width / 2.1
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case let .section(_, photos) = collectionViewCellTypes[indexPath.section] {
            let artObject = photos[indexPath.row]
            presenterInput?.showDetails(artObject: artObject)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if case let .section(section: _, photos: photos) = collectionViewCellTypes[indexPath.section], indexPath.row == photos.count - 2 {
            let pageToGet = indexPath.section + 1
            presenterInput?.loadMoreData(pageToGet)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
