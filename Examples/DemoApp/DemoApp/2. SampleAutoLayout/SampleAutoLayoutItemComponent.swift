import TurboListKit
import UIKit

struct SampleAutoLayoutItemComponent: Component {
    typealias ViewModel = SampleAutoLayoutItemView.ViewModel

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .flexibleHeight(estimatedHeight: 54.0)
    }

    func renderContent(coordinator: Void) -> SampleAutoLayoutItemView {
        SampleAutoLayoutItemView()
    }

    func render(in content: SampleAutoLayoutItemView, coordinator: Void) {
        content.viewModel = viewModel
    }
}

final class SampleAutoLayoutItemView: UIView {
    private enum Layout {
        static let verticalInset: CGFloat = 8
        static let spacing: CGFloat = 4
    }

    struct ViewModel: Equatable {
        let id: UUID
        var title: String?
        var subtitle: String?

        init(
            id: UUID = .init(),
            title: String? = nil,
            subtitle: String? = nil
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
        }

        static func random() -> Self {
            .init(
                title: String.randomWords(count: .random(in: 4...10), wordLength: 4...10),
                subtitle: Bool.random()
                    ? String.randomWords(count: .random(in: 4...10), wordLength: 4...10)
                    : nil
            )
        }
    }

    var viewModel: ViewModel = .init() {
        didSet {
            guard viewModel != oldValue else { return }
            applyViewModel()
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layout.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var separatorHeightConstraint = separator.heightAnchor.constraint(
        equalToConstant: 1.0 / traitCollection.displayScale
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        defineLayout()
//        registerForTraitChanges(
//            [UITraitDisplayScale.self]
//        ) { (self: Self, _: UITraitCollection) in
//            let separatorHeight = 1.0 / self.traitCollection.displayScale
//            if self.separatorHeightConstraint.constant != separatorHeight {
//                self.separatorHeightConstraint.constant = separatorHeight
//            }
//        }
        applyViewModel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func defineLayout() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        separator.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addSubview(separator)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Layout.verticalInset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.verticalInset),

            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorHeightConstraint,
        ])
    }

    private func applyViewModel() {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        titleLabel.isHidden = viewModel.title == nil
        subtitleLabel.isHidden = viewModel.subtitle == nil
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoLayoutFittingSize(for: size)
    }
}

private extension String {
    static func randomWords(count: Int, wordLength: ClosedRange<Int>) -> String {
        (0..<count)
            .map { _ in String.randomWord(length: .random(in: wordLength)) }
            .joined(separator: " ")
    }

    static func randomWord(length: Int) -> String {
        let letters = Array("abcdefghijklmnopqrstuvwxyz")
        return String((0..<length).map { _ in letters.randomElement() ?? "a" })
    }
}
