//
//  HeaderView.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/9/26.
//

import UIKit
import TurboListKit

final class HeaderView: UIView, Touchable {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
    }
}

extension HeaderView {
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setBackground(_ color: UIColor) {
        self.backgroundColor = color
    }
}
