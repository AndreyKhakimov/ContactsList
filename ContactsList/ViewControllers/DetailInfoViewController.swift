//
//  DetailInfoViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import UIKit
import Kingfisher

class DetailInfoViewController: UIViewController {

    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var contact: SuggestedContact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = URL(string: contact.picture?.large ?? "")!
        detailInfoLabel.text = contact.info
        photoImageView.kf.setImage(with: imageURL)
    }

}
