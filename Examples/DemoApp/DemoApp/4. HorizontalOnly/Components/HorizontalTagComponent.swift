import TurboListKit
import UIKit

/// 가로 태그 pill 예제용 컴포넌트.
/// `fitContent`를 사용하고, 실제 크기는 `sizeThatFits`에서 라벨의 intrinsic width에 좌우 패딩 28pt를 더해 계산하며 높이는 48pt로 고정한다.
struct HorizontalTagComponent: Component {
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

    func renderContent(coordinator: Void) -> HorizontalTagPillView {
        HorizontalTagPillView()
    }

    func render(in content: HorizontalTagPillView, coordinator: Void) {
        content.apply(viewModel: viewModel)
    }
}

final class HorizontalTagPillView: UIView {
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

    func apply(viewModel: HorizontalTagComponent.ViewModel) {
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

    // 1. 폭이 이미 정해진 뷰는 autoLayoutFittingSize(for:)로 높이를 계산할 수 있지만,
    // 2. 이 태그는 높이는 48pt로 고정이고 텍스트 길이에 따라 폭이 달라져야 해서 직접 크기를 계산한다.
    // - 가로 길이가 미리 고정돼 있지 않고
    // - 콘텐츠 길이(텍스트 길이)에 따라 폭이 달라져야 하고
    // - 그 폭에 내부 여백까지 포함해야 할 때
    // sizeThatFits에서 직접 계산이 필요
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = label.sizeThatFits(
            CGSize(width: CGFloat.greatestFiniteMagnitude, height: 24)
        )
        return CGSize(width: labelSize.width + 28, height: 48)
    }
}
