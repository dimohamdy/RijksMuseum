//
//  PhotosCollectionViewDataSource.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

final class PhotosCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var itemsForCollection: [ItemCollectionViewCellType?] = []
    
    weak var presenterInput: PhotosListPresenterInput?
    
    private struct CellHeightConstant {
        static let heightOfPhotoCell: CGFloat = 120
        static let heightOfSearchTermCell: CGFloat = 50
        static let heightOfHistoryHeader: CGFloat = 120
    }
    
    init(presenterInput: PhotosListPresenterInput?, itemsForCollection: [ItemCollectionViewCellType?]) {
        self.itemsForCollection = itemsForCollection
        self.presenterInput = presenterInput
    }
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !itemsForCollection.isEmpty else {
            return 1
        }
        return itemsForCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemsForCollection[indexPath.row]
        switch item {
        case .photo(let photo):
            if let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(for: indexPath) {
                cell.configCell(photo: photo)
                return cell
            }
        case .none:
            return UICollectionViewCell()
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let item = itemsForCollection[indexPath.row] {
            switch item {
            case .photo:
                return getPhotoCellSize(collectionView: collectionView)
            }
        } else {
            return getPhotoCellSize(collectionView: collectionView)
        }
    }
    
    private func getPhotoCellSize(collectionView: UICollectionView) -> CGSize {
        let widthAndHeight = collectionView.bounds.width / 2.1
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = itemsForCollection[indexPath.row] {
            switch item {
            case .photo(let artObject):
                presenterInput?.showDetails(artObject: artObject)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if case .photo = itemsForCollection[indexPath.row], indexPath.row == itemsForCollection.count - 1 {
            let pageToGet = Int(indexPath.row / Constant.pageSize) + 1
            presenterInput?.loadMoreData(pageToGet)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}
