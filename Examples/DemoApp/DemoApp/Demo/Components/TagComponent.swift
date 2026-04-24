import CollectionAdapter
import UIKit

struct TagComponent: Component {
    struct ViewModel: Equatable {
        enum Tint: Equatable {
            case blue
            case green
            case orange
            case rose
            case gray
        }

        let title: String
        let tint: Tint
    }

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .fitContent(estimatedSize: CGSize(width: 120, height: 48))
    }

    func renderContent(coordinator: Void) -> TagPillView {
        TagPillView()
    }

    func render(in content: TagPillView, coordinator: Void) {
        content.apply(viewModel: viewModel)
    }
}

final class TagPillView: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 16
        layer.cornerCurve = .continuous

        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func apply(viewModel: TagComponent.ViewModel) {
        label.text = viewModel.title

        switch viewModel.tint {
        case .blue:
            backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
            label.textColor = .systemBlue
        case .green:
            backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
            label.textColor = .systemGreen
        case .orange:
            backgroundColor = UIColor.systemOrange.withAlphaComponent(0.14)
            label.textColor = .systemOrange
        case .rose:
            backgroundColor = UIColor.systemPink.withAlphaComponent(0.14)
            label.textColor = .systemPink
        case .gray:
            backgroundColor = UIColor.secondarySystemGroupedBackground
            label.textColor = .secondaryLabel
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = label.sizeThatFits(
            CGSize(width: CGFloat.greatestFiniteMagnitude, height: 24)
        )
        return CGSize(width: labelSize.width + 28, height: 48)
    }
}
