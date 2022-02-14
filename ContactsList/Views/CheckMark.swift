//
//  AnimatedView.swift
//  CATest
//
//  Created by Andrey Khakimov on 30.01.2022.
//

import UIKit

class CheckMark: UIView {

    private let animatedLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = layer.bounds
        animatedLayer.frame = layer.bounds
        updatePath()
    }

    private func commonInit() {
        layer.addSublayer(gradientLayer)

        animatedLayer.fillColor = UIColor.clear.cgColor
        animatedLayer.strokeColor = UIColor.red.cgColor
        animatedLayer.lineWidth = 6
        animatedLayer.strokeEnd = 0
        animatedLayer.lineCap = .round
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradientLayer.mask = animatedLayer
    }

    private func updatePath() {
        let point1 = CGPoint(x: bounds.width * 0.1 , y: 0.3 * bounds.height)
        let point2 = CGPoint(x: bounds.width * 0.4, y: 0.8 * bounds.height)
        let point3 = CGPoint(x: bounds.width * 0.4, y: 0.8 * bounds.height)
        let point4 = CGPoint(x: bounds.width * 1, y: 0 * bounds.height)

        let curvedCheckMark = UIBezierPath()
        curvedCheckMark.move(to: point1)
        curvedCheckMark.addLine(to: point2)
        curvedCheckMark.move(to: point3)

        curvedCheckMark.addLine(to: point4)

        animatedLayer.path = curvedCheckMark.cgPath
    }

    func startAnimation() {
        animatedLayer.strokeEnd = 1

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 3
        animation.fromValue = 0
        animation.toValue = 1
        animatedLayer.add(animation, forKey: "path")
    }
    
    func changeToPlusAnimation() {
        let point1 = CGPoint(x: bounds.width * 0.2 , y: 0.5 * bounds.height)
        let point2 = CGPoint(x: bounds.width * 0.8, y: 0.5 * bounds.height)
        let point3 = CGPoint(x: bounds.width * 0.5, y: 0.8 * bounds.height)
        let point4 = CGPoint(x: bounds.width * 0.5, y: 0.2 * bounds.height)

        let curvedCheckMark = UIBezierPath()
        curvedCheckMark.move(to: point1)
        curvedCheckMark.addLine(to: point2)
        curvedCheckMark.move(to: point3)
        curvedCheckMark.addLine(to: point4)
        let oldPath = animatedLayer.path
        let newPath = curvedCheckMark.cgPath
        
        animatedLayer.path = newPath
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 3
        animation.fromValue = oldPath
        animation.toValue = newPath
        animatedLayer.add(animation, forKey: "path")
    }
    
}
