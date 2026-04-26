import TurboListKit
import UIKit

/// 가로 카드 예제용 컴포넌트.
/// `fitContent`를 사용하고, 실제 크기는 `sizeThatFits`에서 최대 폭 240pt와 최소 높이 140pt를 기준으로 오토레이아웃 결과를 반환한다.
struct HorizontalFeatureCardComponent: Component {
    struct ViewModel: Equatable {
        enum Accent: Equatable {
            case blue
            case green
            case orange
            case rose
        }

        let title: String
        let subtitle: String
        let accent: Accent
    }

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .fitContent(estimatedSize: CGSize(width: 240, height: 150))
    }

    func renderContent(coordinator: Void) -> HorizontalFeatureCardView {
        HorizontalFeatureCardView()
    }

    func render(in content: HorizontalFeatureCardView, coordinator: Void) {
        content.apply(viewModel: viewModel)
    }
}

final class HorizontalFeatureCardView: UIView {
    private let eyebrowLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 24
        layer.cornerCurve = .continuous
        clipsToBounds = true

        eyebrowLabel.font = .preferredFont(forTextStyle: .caption1)
        eyebrowLabel.text = "Horizontal"
        eyebrowLabel.textColor = .secondaryLabel

        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.numberOfLines = 3

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(eyebrowLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func apply(viewModel: HorizontalFeatureCardComponent.ViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle

        switch viewModel.accent {
        case .blue:
            backgroundColor = UIColor.systemBlue.withAlphaComponent(0.14)
            titleLabel.textColor = .systemBlue
            subtitleLabel.textColor = .label
        case .green:
            backgroundColor = UIColor.systemGreen.withAlphaComponent(0.14)
            titleLabel.textColor = .systemGreen
            subtitleLabel.textColor = .label
        case .orange:
            backgroundColor = UIColor.systemOrange.withAlphaComponent(0.16)
            titleLabel.textColor = .systemOrange
            subtitleLabel.textColor = .label
        case .rose:
            backgroundColor = UIColor.systemPink.withAlphaComponent(0.15)
            titleLabel.textColor = .systemPink
            subtitleLabel.textColor = .label
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoLayoutFittingSize(
            for: size,
            targetWidth: min(size.width, 240),
            minimumHeight: 140
        )
    }
}
