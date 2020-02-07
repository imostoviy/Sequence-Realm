//
//  TableViewCell.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 07.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var articleDescriptionLabel: UILabel!
    @IBOutlet private weak var tagsLabel: UILabel!
    @IBOutlet private weak var isFavouriteLabel: UILabel!

    func setup(title: String,
               description: String,
               tags: String,
               isFavourite: Bool) {
        titleLabel.text = title
        articleDescriptionLabel.text = description
        tagsLabel.text = tags
        isFavouriteLabel.text = "\(isFavourite)"
    }
}
