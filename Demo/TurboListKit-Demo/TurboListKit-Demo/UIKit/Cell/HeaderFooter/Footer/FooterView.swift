//
//  HeaderView.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/9/26.
//

import UIKit
import TurboListKit

// 일단 이렇게 유지하고 추후에 래퍼 만들예정
final class FooterView: UIView, Touchable {
    
    private let titleLabel = UILabel()
    
    // spacer
    private let containerView = UIView()
    var contentHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .systemBackground
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: contentHeight
        )
    }
}

extension FooterView {
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setBackground(_ color: UIColor) {
        self.containerView.backgroundColor = color
    }
}










//
//final class FooterView: UIView {
//
//    private let titleLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//}
//
//extension FooterView {
//
//    func setTitle(_ title: String) {
//        titleLabel.text = title
//    }
//
//    func setBackground(_ color: UIColor) {
//        backgroundColor = color
//    }
//}
//
//
