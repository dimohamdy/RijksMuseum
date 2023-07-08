//
//  UICollectionView+EmptyState.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

extension UICollectionView {

    @MainActor
    func setEmptyView(emptyPlaceHolderType: EmptyPlaceHolderType, completionBlock: (() -> Void)? = nil) {
        let frame = CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height)
        let emptyPlaceHolderView = EmptyPlaceHolderView(frame: frame)
        emptyPlaceHolderView.translatesAutoresizingMaskIntoConstraints = false
        emptyPlaceHolderView.emptyPlaceHolderType = emptyPlaceHolderType
        emptyPlaceHolderView.completionBlock = completionBlock
        backgroundView = emptyPlaceHolderView
        NSLayoutConstraint.activate([
            emptyPlaceHolderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyPlaceHolderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyPlaceHolderView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    @MainActor
    func restore() {
        backgroundView = nil
    }
}
