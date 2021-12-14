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
        contactImage.kf.cancelDownloadTask()
        contactImage.image = UIImage(named: "photo.artframe")
    }
    
    func configure(image: URL, name: String) {
        contactImage.kf.setImage(with: image)
        contactLabel.text = name
    }

}
