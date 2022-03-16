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
    @IBOutlet weak var checkMarkView: CheckMark!
    
    private var onPlusTapped: (() -> Void)?
    private var isAdded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkMarkView.addTarget(self, action:  #selector(onButtonTapped), for: .touchUpInside)
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
        self.isAdded = isAdded
        setIsAdded(isAdded, animated: false)
    }
    
    func setIsAdded(_ value: Bool, animated: Bool) {
        value ? checkMarkView.showCheckMark(animated: animated) : checkMarkView.changeToPlusAnimation(animated: animated)
    }
    
    @IBAction
    func onButtonTapped() {
        print("ON button tapped \(suggestedContactLabel.text!) -----")
        guard !isAdded else { return }
        
        setIsAdded(true, animated: true)
        onPlusTapped?()
    }
    
}
