import TurboListKit
import UIKit

struct AutoLayoutMessageComponent: Component {
    struct ViewModel: Equatable {
        enum Accent: Equatable, CaseIterable {
            case blue
            case green
            case orange

            var text: String {
                switch self {
                case .blue:
                    return "Auto Layout"
                case .green:
                    return "Dynamic Type"
                case .orange:
                    return "Flexible Height"
                }
            }
        }

        let id: UUID
        let title: String
        let body: String
        let footnote: String
        let accent: Accent

        init(
            id: UUID = UUID(),
            title: String,
            body: String,
            footnote: String,
            accent: Accent
        ) {
            self.id = id
            self.title = title
            self.body = body
            self.footnote = footnote
            self.accent = accent
        }

        static func sample(index: Int) -> Self {
            let accent = Accent.allCases[index % Accent.allCases.count]
            let titles = [
                "제약 기반 컴포넌트",
                "UIStackView 조합 예제",
                "내용 길이에 따라 자동 확장",
                "UICollectionView 셀 높이 자동 계산",
            ]
            let bodies = [
                "이번 예제는 내부 뷰를 frame 계산 없이 구성합니다. 스택뷰와 오토레이아웃 제약만으로 컴포넌트를 만들고, 실제 높이는 systemLayoutSizeFitting으로 계산합니다.",
                "텍스트 길이가 달라져도 상하 여백과 간격이 자연스럽게 유지되도록 구성했습니다. 셀 내부 레이아웃 코드를 직접 계산하지 않아도 읽기 쉬운 형태를 유지할 수 있습니다.",
                "TurboListKit의 Component는 UIView 하나만 반환하면 되기 때문에, 익숙한 UIKit 오토레이아웃 패턴을 그대로 재사용하기 좋습니다.",
                "Dynamic Type 환경에서도 줄 수가 변하면 높이가 함께 바뀌도록 UILabel과 제약만 사용했습니다.",
            ]
            let footnotes = [
                "핵심: renderContent -> Auto Layout UIView -> flexibleHeight",
                "핵심: 스택뷰 내부 arrangedSubview만 교체하면 재사용도 단순합니다.",
                "핵심: sizeThatFits에서 systemLayoutSizeFitting 호출",
                "핵심: 샘플을 그대로 복사해서 실제 화면에 붙이기 쉽습니다.",
            ]

            return .init(
                title: titles[index % titles.count],
                body: bodies[index % bodies.count],
                footnote: footnotes[index % footnotes.count],
                accent: accent
            )
        }
    }

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .flexibleHeight(estimatedHeight: 180)
    }

    func renderContent(coordinator: Void) -> AutoLayoutMessageView {
        AutoLayoutMessageView()
    }

    func render(in content: AutoLayoutMessageView, coordinator: Void) {
        content.apply(viewModel: viewModel)
    }
}

final class AutoLayoutMessageView: UIView {
    private let badgeLabel = PaddingLabel()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let footnoteLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous

        badgeLabel.font = .preferredFont(forTextStyle: .caption1)
        badgeLabel.adjustsFontForContentSizeCategory = true
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.layer.cornerCurve = .continuous
        badgeLabel.clipsToBounds = true

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0

        bodyLabel.font = .preferredFont(forTextStyle: .body)
        bodyLabel.adjustsFontForContentSizeCategory = true
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .secondaryLabel

        footnoteLabel.font = .preferredFont(forTextStyle: .footnote)
        footnoteLabel.adjustsFontForContentSizeCategory = true
        footnoteLabel.numberOfLines = 0
        footnoteLabel.textColor = .tertiaryLabel

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(badgeLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(footnoteLabel)
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

    func apply(viewModel: AutoLayoutMessageComponent.ViewModel) {
        badgeLabel.text = viewModel.accent.text
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.body
        footnoteLabel.text = viewModel.footnote

        switch viewModel.accent {
        case .blue:
            badgeLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.14)
            badgeLabel.textColor = .systemBlue
        case .green:
            badgeLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.14)
            badgeLabel.textColor = .systemGreen
        case .orange:
            badgeLabel.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.16)
            badgeLabel.textColor = .systemOrange
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoLayoutFittingSize(for: size)
    }
}

private final class PaddingLabel: UILabel {
    private let insets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }
}
