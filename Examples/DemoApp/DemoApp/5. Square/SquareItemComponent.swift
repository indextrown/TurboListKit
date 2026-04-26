import TurboListKit
import UIKit

struct SquareItemComponent: Component {
    struct ViewModel: Equatable {
        enum Accent: CaseIterable, Equatable {
            case blue
            case green
            case orange
            case rose

            var titleColor: UIColor {
                switch self {
                case .blue: .systemBlue
                case .green: .systemGreen
                case .orange: .systemOrange
                case .rose: .systemPink
                }
            }

            var backgroundColor: UIColor {
                switch self {
                case .blue: UIColor.systemBlue.withAlphaComponent(0.12)
                case .green: UIColor.systemGreen.withAlphaComponent(0.12)
                case .orange: UIColor.systemOrange.withAlphaComponent(0.14)
                case .rose: UIColor.systemPink.withAlphaComponent(0.14)
                }
            }
        }

        let id: UUID
        let title: String
        let accent: Accent

        init(
            id: UUID = .init(),
            title: String,
            accent: Accent
        ) {
            self.id = id
            self.title = title
            self.accent = accent
        }

        static func samples() -> [Self] {
            let titles = ["Plan", "Build", "Test", "Ship", "Track", "Scale"]
            return titles.enumerated().map { index, title in
                .init(
                    title: title,
                    accent: Accent.allCases[index % Accent.allCases.count]
                )
            }
        }
    }

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .flexibleHeight(estimatedHeight: 160)
    }

    func renderContent(coordinator: Void) -> SquareItemView {
        SquareItemView()
    }

    func render(in content: SquareItemView, coordinator: Void) {
        content.apply(viewModel: viewModel)
    }
}

final class SquareItemView: UIView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        clipsToBounds = true

        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func apply(viewModel: SquareItemComponent.ViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.accent.titleColor
        backgroundColor = viewModel.accent.backgroundColor
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let length = max(size.width, 0)
        return CGSize(width: size.width, height: length)
    }
}
