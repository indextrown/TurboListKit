import TurboListKit
import UIKit

struct SectionHeaderComponent: Component {
    struct ViewModel: Equatable {
        let title: String
        let subtitle: String?
    }

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .flexibleHeight(estimatedHeight: 64)
    }

    func renderContent(coordinator: Void) -> SectionHeaderView {
        SectionHeaderView()
    }

    func render(in content: SectionHeaderView, coordinator: Void) {
        content.apply(viewModel: viewModel)
    }
}

final class SectionHeaderView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.textColor = .label
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func apply(viewModel: SectionHeaderComponent.ViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle == nil
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
