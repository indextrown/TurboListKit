//
//  HeaderView.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/9/26.
//

import UIKit
import TurboListKit

/*
 containerView
  ├ top = 0
  ├ left = 0
  ├ right = 0
  └ height = contentHeight

 titleLabel
  ├ left = 16
  ├ right = -16
  ├ top = 0
  └ bottom = 0
 */
final class FooterView: UIView, Touchable {

    private let titleLabel = UILabel()                // footer text
    private let containerView = UIView()              // footer content 영역
    private var heightConstraint: NSLayoutConstraint! // containerView 높이를 제어하는 constraint

    var contentHeight: CGFloat = 0 {
        didSet {
            heightConstraint.constant = contentHeight
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setupUI() {
        backgroundColor = .clear
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
    }
    
    func setupConstraints() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            // footer content area
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightConstraint,

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

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

// frame방식 제약 경고뜸
//final class FooterView: UIView, Touchable {
//
//    private let titleLabel = UILabel()
//
//    // spacer
//    private let containerView = UIView()
//    var contentHeight: CGFloat = 0
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupUI() {
//        backgroundColor = .clear
//        addSubview(containerView)
//        containerView.addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: topAnchor),
//            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
//
//            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
//            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ])
//
//        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
//        titleLabel.textColor = .label
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        containerView.frame = CGRect(
//            x: 0,
//            y: 0,
//            width: bounds.width,
//            height: contentHeight
//        )
//    }
//}









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
