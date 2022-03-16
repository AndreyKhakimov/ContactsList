//
//  AnimatedView.swift
//  CATest
//
//  Created by Andrey Khakimov on 30.01.2022.
//

import UIKit

class CheckMark: UIControl {

    enum Shape {
        case plus, checkmark
        
        func path(size: CGSize) -> CGPath {
            switch self {
            case .plus:
                let point1 = CGPoint(x: size.width * 0.2, y: 0.5 * size.height)
                let point2 = CGPoint(x: size.width * 0.8, y: 0.5 * size.height)
                let point3 = CGPoint(x: size.width * 0.5, y: 0.8 * size.height)
                let point4 = CGPoint(x: size.width * 0.5, y: 0.2 * size.height)

                let plus = UIBezierPath()
                plus.move(to: point1)
                plus.addLine(to: point2)
                plus.move(to: point3)
                plus.addLine(to: point4)
                return plus.cgPath
               
            case .checkmark:
                let point1 = CGPoint(x: size.width * 0.1 , y: 0.3 * size.height)
                let point2 = CGPoint(x: size.width * 0.4, y: 0.8 * size.height)
                let point3 = CGPoint(x: size.width * 0.4, y: 0.8 * size.height)
                let point4 = CGPoint(x: size.width * 1, y: 0 * size.height)

                let curvedCheckMark = UIBezierPath()
                curvedCheckMark.move(to: point1)
                curvedCheckMark.addLine(to: point2)
                curvedCheckMark.move(to: point3)

                curvedCheckMark.addLine(to: point4)
                return curvedCheckMark.cgPath
            }
        }
    }
    
    private let animatedLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private var shape: Shape = .plus
    
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
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.yellow.cgColor]
        gradientLayer.mask = animatedLayer
    }

    private func updatePath() {
        animatedLayer.path = shape.path(size: bounds.size)
    }

    func removeAllAnimations() {
        animatedLayer.removeAllAnimations()
    }
    
    func showCheckMark(animated: Bool) {
        shape = .checkmark
        updatePath()
        animatedLayer.strokeEnd = 1
        guard animated else { return }
        print("Show checkmark tapped -----")
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.8
        animation.fromValue = 0
        animation.toValue = 1
        animatedLayer.add(animation, forKey: "Andrey")
    }
    
    func changeToPlusAnimation(animated: Bool) {
        animatedLayer.strokeEnd = 1
        shape = .plus
        let oldPath = animatedLayer.path
        let newPath = shape.path(size: bounds.size)
        animatedLayer.path = newPath
        
        guard animated else { return }
        print("Show plus tapped -----")
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 3
        animation.fromValue = oldPath
        animation.toValue = newPath
        animatedLayer.add(animation, forKey: "path")
    }
    
}
