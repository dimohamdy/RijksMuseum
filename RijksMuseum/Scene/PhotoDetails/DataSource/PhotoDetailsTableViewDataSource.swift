//
//  PhotoTableViewDataSource.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

final class PhotoDetailsTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {

    var photoTableViewCellTypes: [PhotoTableViewCellType]

    init(photoTableViewCellTypes: [PhotoTableViewCellType]) {
        self.photoTableViewCellTypes = photoTableViewCellTypes
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoTableViewCellTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = photoTableViewCellTypes[indexPath.row]
        switch type {
        case .photoCell(let model):
            if let cell: PhotoTableViewCell = tableView.dequeueReusableCell(for: indexPath) {
                cell.configCell(photoModel: model)
                return cell
            }
        case .detailsCell(let model):
            if let cell: DetailsTableViewCell = tableView.dequeueReusableCell(for: indexPath) {
                cell.configCell(photoModel: model)
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = photoTableViewCellTypes[indexPath.row]
        switch type {
        case .photoCell:
            return 350
        case .detailsCell:
            return UITableView.automaticDimension
        }
    }
}
