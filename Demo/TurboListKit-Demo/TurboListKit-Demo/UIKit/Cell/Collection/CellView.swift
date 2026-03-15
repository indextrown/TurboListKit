//
//  CellView.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import UIKit
import TurboListKit

final class CellView: UIView, Touchable, TouchAnimatable {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CellView {
    
    func setupUI() {
        backgroundColor = .green
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // corner
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black
    }
}

extension CellView {
    
    func setTitle(_ number: Int) {
        titleLabel.text = String(number)
    }
    
    func setBackground(_ color: UIColor) {
        self.backgroundColor = color
    }
}


////
////  CellView.swift
////  TurboListKit-Demo
////
//
//import UIKit
//import TurboListKit
//
//final class CellView: UIView, Touchable, TouchAnimatable {
//
//    // MARK: - Views
//
//    private let blurView = UIVisualEffectView(
//        effect: UIBlurEffect(style: .systemUltraThinMaterial)
//    )
//
//    private let tintView = UIView()
//    private let titleLabel = UILabel()
//
//    // MARK: - Layers
//
//    private let gradientLayer = CAGradientLayer()
//    private let highlightLayer = CAGradientLayer()
//    private let innerShadowLayer = CAGradientLayer()
//
//    // MARK: - Init
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setupUI()
//        setupGradient()
//        setupHighlight()
//        setupInnerShadow()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        gradientLayer.frame = bounds
//        highlightLayer.frame = bounds
//        innerShadowLayer.frame = bounds
//    }
//}
//
//// MARK: - UI
//
//private extension CellView {
//
//    func setupUI() {
//
//        layer.cornerRadius = 18
//        layer.cornerCurve = .continuous
//        layer.masksToBounds = true
//
//        addSubview(blurView)
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//
//        blurView.contentView.addSubview(tintView)
//        tintView.translatesAutoresizingMaskIntoConstraints = false
//
//        blurView.contentView.addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        tintView.backgroundColor = UIColor.white.withAlphaComponent(0.04)
//
//        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
//        titleLabel.textColor = .black
//        titleLabel.textAlignment = .center
//
//        NSLayoutConstraint.activate([
//
//            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            blurView.topAnchor.constraint(equalTo: topAnchor),
//            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            tintView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
//            tintView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
//            tintView.topAnchor.constraint(equalTo: blurView.topAnchor),
//            tintView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
//
//            titleLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: blurView.centerYAnchor)
//        ])
//    }
//}
//
//// MARK: - Gradient
//
//private extension CellView {
//
//    func setupGradient() {
//
//        gradientLayer.colors = [
//            UIColor(red: 0.35, green: 0.75, blue: 0.65, alpha: 1).cgColor,
//            UIColor(red: 0.55, green: 0.85, blue: 0.78, alpha: 1).cgColor
//        ]
//
//        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.7, y: 1)
//
//        blurView.contentView.layer.insertSublayer(gradientLayer, at: 0)
//    }
//}
//
//// MARK: - Highlight
//
//private extension CellView {
//
//    func setupHighlight() {
//
//        highlightLayer.colors = [
//            UIColor.white.withAlphaComponent(0.35).cgColor,
//            UIColor.clear.cgColor
//        ]
//
//        highlightLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        highlightLayer.endPoint = CGPoint(x: 0.5, y: 1)
//
//        layer.addSublayer(highlightLayer)
//    }
//}
//
//// MARK: - Inner Shadow
//
//private extension CellView {
//
//    func setupInnerShadow() {
//
//        innerShadowLayer.colors = [
//            UIColor.black.withAlphaComponent(0.18).cgColor,
//            UIColor.clear.cgColor
//        ]
//
//        innerShadowLayer.startPoint = CGPoint(x: 0.5, y: 1)
//        innerShadowLayer.endPoint = CGPoint(x: 0.5, y: 0)
//
//        layer.addSublayer(innerShadowLayer)
//    }
//}
//
//// MARK: - Public
//
//extension CellView {
//
//    func setTitle(_ number: Int) {
//        titleLabel.text = "\(number)"
//    }
//}
