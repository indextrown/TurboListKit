//
//  NumberView.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import UIKit
import TurboListKit

final class SwipableNumberView: UIView, Touchable, Swipeable {
    
    private let titleLabel = UILabel()
    
    var trailingSwipeActions: [UIContextualAction] {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            print("delete")
            completion(true)
        }

        return [delete]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SwipableNumberView {
    
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

extension SwipableNumberView {
    
    func setTitle(_ number: Int) {
        titleLabel.text = String(number)
    }
    
    func setBackground(_ color: UIColor) {
        self.backgroundColor = color
    }
}
