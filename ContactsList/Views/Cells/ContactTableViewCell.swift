//
//  ContactTableViewCell.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import UIKit
import Kingfisher

//class ContactTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var contactLabel: UILabel!
//    @IBOutlet weak var contactImage: UIImageView!
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        contactImage.image = UIImage(systemName: "photo.artframe")
//    }
//
//    func configure(image: String?, name: String) {
//        if let image = image {
//            do {
//
//                contentImage.kf.setImage(with: image)
////                let imageURL = ImageManager.shared.imageURL(forPath: image)
////                let data = try Data(contentsOf: imageURL)
////                contactImage.image = UIImage(data: data)
//            } catch {
//                print("Unable to upload image from disk data with error: \(error.localizedDescription)")
//            }
//
//        } else {
//            contactImage.image = UIImage(systemName: "photo.artframe")
//        }
//        contactLabel.text = name
//    }
//
//}

//class ContactTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var contactLabel: UILabel!
//    @IBOutlet weak var contactImage: UIImageView!
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        contactImage.kf.cancelDownloadTask()
//        contactImage.image = UIImage(systemName: "photo.artframe")
//    }
//
//    func configure(image: String?, name: String) {
//        if let image = image, let imageURL = URL(string: image) {
//            contactImage.kf.setImage(with: imageURL)
//        } else {
//            contactImage.image = UIImage(systemName: "photo.artframe")
//        }
//        contactLabel.text = name
//    }
//
//}


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

