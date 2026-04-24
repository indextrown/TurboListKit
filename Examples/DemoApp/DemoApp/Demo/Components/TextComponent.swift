//
//  TextComponent.swift
//  DemoApp
//
//  Created by 김동현 on 4/25/26.
//

import CollectionAdapter
import UIKit

struct TextComponent: Component {
    struct ViewModel: Equatable {
        let title: String
        let detail: String?
        let tone: Tone
    }

    enum Tone: Equatable {
        case accent
        case neutral
        case subtle
    }

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .flexibleHeight(estimatedHeight: viewModel.detail == nil ? 56 : 92)
    }

    func renderContent(coordinator: Void) -> TextBlockView {
        TextBlockView()
    }

    func render(in content: TextBlockView, coordinator: Void) {
        content.apply(viewModel: viewModel)
    }
}

final class TextBlockView: UIView {
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 18
        layer.cornerCurve = .continuous

        titleLabel.numberOfLines = 0
        detailLabel.numberOfLines = 0

        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func apply(viewModel: TextComponent.ViewModel) {
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
        detailLabel.isHidden = viewModel.detail == nil

        switch viewModel.tone {
        case .accent:
            backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            titleLabel.textColor = .label
            detailLabel.textColor = .secondaryLabel
        case .neutral:
            backgroundColor = .secondarySystemGroupedBackground
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            titleLabel.textColor = .label
            detailLabel.textColor = .secondaryLabel
        case .subtle:
            backgroundColor = .tertiarySystemGroupedBackground
            titleLabel.font = .preferredFont(forTextStyle: .subheadline)
            titleLabel.textColor = .secondaryLabel
            detailLabel.textColor = .tertiaryLabel
        }

        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let targetWidth = max(size.width, 1)
        let fittingSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
        let result = systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return CGSize(width: targetWidth, height: result.height)
    }
}
