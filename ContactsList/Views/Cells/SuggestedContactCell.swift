//
//  SuggestedContactCell.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 04.01.2022.
//

import UIKit
import Kingfisher

class SuggestedContactCell: UITableViewCell {
    
    @IBOutlet private weak var suggestedContactLabel: UILabel!
    @IBOutlet private weak var suggestedContactImage: UIImageView!
    @IBOutlet private weak var suggestedContactButton: UIButton!
    
    private var onPlusTapped: (() -> Void)?
    
    @IBAction func suggestedContactButtonPressed(_ sender: Any) {
        guard !suggestedContactButton.isSelected else { return }
        onPlusTapped?()
        setIsAdded(true)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        suggestedContactImage.kf.cancelDownloadTask()
        suggestedContactImage.image = UIImage(systemName: "photo.artframe")
        onPlusTapped = nil
    }
    
    func configure(
        image: URL?,
        name: String,
        onPlusTapped: (() -> Void)?,
        isAdded: Bool)
    {
        if let image = image {
            suggestedContactImage.kf.setImage(with: image)
        } else {
            suggestedContactImage.image = UIImage(systemName: "photo.artframe")
        }
        suggestedContactLabel.text = name
        self.onPlusTapped = onPlusTapped
        setIsAdded(isAdded)
    }
    
    func setIsAdded(_ value: Bool) {
        suggestedContactButton.isSelected = value
    }
}
