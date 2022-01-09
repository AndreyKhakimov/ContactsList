//
//  RoundedImageView.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 20.12.2021.
//

import UIKit

class RoundedImageView: UIImageView {
    
    var roundsCorners: Bool = true {
        didSet {
            layer.cornerRadius = roundsCorners ? bounds.size.width / 2 : 0
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = roundsCorners ? bounds.size.width / 2 : 0
    }
    
}
