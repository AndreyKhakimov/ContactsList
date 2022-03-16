//
//  ContactTableViewCell.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import UIKit
import Kingfisher

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        contactImage.image = UIImage(systemName: "photo.artframe")
    }

    func configure(image: UIImage?, name: String) {
        if let image = image {
            contactImage.image = image
        } else {
            contactImage.image = UIImage(systemName: "photo.artframe")
        }
        contactLabel.text = name
    }

}

