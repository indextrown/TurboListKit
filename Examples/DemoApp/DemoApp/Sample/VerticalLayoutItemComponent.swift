import CollectionAdapter
import UIKit

struct VerticalLayoutItemComponent: Component {
    typealias ViewModel = VerticalLayoutItemView.ViewModel

    let viewModel: ViewModel

    var layoutMode: ContentLayoutMode {
        .flexibleHeight(estimatedHeight: 72)
    }

    func renderContent(coordinator: Void) -> VerticalLayoutItemView {
        VerticalLayoutItemView(viewModel: viewModel)
    }

    func render(in content: VerticalLayoutItemView, coordinator: Void) {
        content.viewModel = viewModel
    }
}

final class VerticalLayoutItemView: UIView {
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

    var viewModel: ViewModel {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        defineLayout()
        applyViewModel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func defineLayout() {
        backgroundColor = .systemBackground

        addSubview(stackView)
        addSubview(separator)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        let separatorHeight = 1.0 / traitCollection.displayScale

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: separatorHeight),
        ])
    }

    private func applyViewModel() {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        titleLabel.isHidden = viewModel.title == nil
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
