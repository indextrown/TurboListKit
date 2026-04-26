import TurboListKit
import UIKit

/// 가로 섹션 헤더용 컴포넌트.
/// `flexibleHeight`를 사용하고, 높이는 `sizeThatFits`에서 오토레이아웃이 계산한 내용 높이에 맞춰 유연하게 결정된다.
struct HorizontalSectionHeaderComponent: Component {
    struct ViewModel: Equatable {
        let title: String
        let subtitle: String?
    }

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .flexibleHeight(estimatedHeight: 64)
    }

    func renderContent(coordinator: Void) -> HorizontalSectionHeaderView {
        HorizontalSectionHeaderView()
    }

    func render(in content: HorizontalSectionHeaderView, coordinator: Void) {
        content.apply(viewModel: viewModel)
    }
}

final class HorizontalSectionHeaderView: UIView {
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

    func apply(viewModel: HorizontalSectionHeaderComponent.ViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle == nil
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoLayoutFittingSize(for: size)
    }
}
