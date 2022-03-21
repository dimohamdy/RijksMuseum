//
//  UICollectionView+EmptyState.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

extension UICollectionView {

    func setEmptyView(emptyPlaceHolderType: EmptyPlaceHolderType, completionBlock: (() -> Void)? = nil) {
        DispatchQueue.main.async {

            let frame = CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height)
            let emptyPlaceHolderView = EmptyPlaceHolderView(frame: frame)
            emptyPlaceHolderView.translatesAutoresizingMaskIntoConstraints = false
            emptyPlaceHolderView.emptyPlaceHolderType = emptyPlaceHolderType
            emptyPlaceHolderView.completionBlock = completionBlock
            self.backgroundView = emptyPlaceHolderView
            NSLayoutConstraint.activate([
                emptyPlaceHolderView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                emptyPlaceHolderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                emptyPlaceHolderView.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        }
    }

    func restore() {
        DispatchQueue.main.async {

            self.backgroundView = nil
        }
    }
}
