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
    var contact: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = URL(string: contact.picture.large)!
        detailInfoLabel.text = contact.description
        photoImageView.kf.setImage(with: imageURL)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
