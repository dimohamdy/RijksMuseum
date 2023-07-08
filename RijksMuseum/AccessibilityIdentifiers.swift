//
//  AccessibilityIdentifiers.swift
//  RijksMuseum
//
//  Created by Dimo Abdelaziz on 25/05/2023.
//

import Foundation
import UIKit

struct AccessibilityIdentifiers {

    struct EmptyPlaceHolderView {
        static let titleLabelId = "\(EmptyPlaceHolderView.self).titleLabelId"
        static let detailsLabelId = "\(EmptyPlaceHolderView.self).detailsLabelId"
        static let actionButtonId = "\(EmptyPlaceHolderView.self).actionButtonId"
        static let logoImageViewId = "\(EmptyPlaceHolderView.self).logoImageViewId"
    }

    struct PhotosListViewController {
        static let collectionViewId = "\(PhotosListViewController.self).collectionViewId"
        static let cellId = "\(PhotosListViewController.self).cellId"
    }

    struct PhotoDetailsViewController {
        static let titleId = "\(PhotoDetailsViewController.self).titleId"
        static let principalOrFirstMakerId = "\(PhotoDetailsViewController.self).principalOrFirstMakerId"
        static let longTitleId = "\(PhotoDetailsViewController.self).longTitleId"
        static let descriptionId = "\(PhotoDetailsViewController.self).descriptionId"
        static let materialsId = "\(PhotoDetailsViewController.self).materialsId"
        static let techniquesId = "\(PhotoDetailsViewController.self).techniquesId"
        static let subTitleId = "\(PhotoDetailsViewController.self).subTitleId"
    }
}
