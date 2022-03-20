//
//  CollectionTypeTabBar.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/19/22.
//

import UIKit

protocol CollectionTypeTabBarDelegate: AnyObject {
    func collectionTypeTabBar(_ tabBar: CollectionTypeTabBar, didSelectItem collectionType: CollectionType, at index: Int)
}

class CollectionTypeTabBar: UIView {

    private struct CellHeightConstant {
        static let widthOfCell: CGFloat = 100
        static let heightOfCell: CGFloat = 50
    }

    weak var delegate: CollectionTypeTabBarDelegate?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionTypeItemBar.self, forCellWithReuseIdentifier: CollectionTypeItemBar.identifier)
        return collectionView
    }()

    private let collectionTypes: [CollectionType]
    private var currentCollectionType: CollectionType = .print

    init(collectionTypes: [CollectionType] = CollectionType.allCases) {
        self.collectionTypes = collectionTypes
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(collectionView)
        setupConstraints()

        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
        currentCollectionType = collectionTypes[0]
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension CollectionTypeTabBar: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionTypes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell: CollectionTypeItemBar = collectionView.dequeueReusableCell(for: indexPath) {
            let collectionType = collectionTypes[indexPath.row]
            cell.configCell(collectionType: collectionType)
            return cell
        }
        print("❤️")
        return UICollectionViewCell()
    }
}

extension CollectionTypeTabBar: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionType = collectionTypes[indexPath.row]
        delegate?.collectionTypeTabBar(self, didSelectItem: collectionType, at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CellHeightConstant.widthOfCell, height: CellHeightConstant.heightOfCell)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
