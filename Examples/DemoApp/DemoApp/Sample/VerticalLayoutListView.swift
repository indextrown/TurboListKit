import CollectionAdapter
import UIKit

final class VerticalLayoutListView: UIView {
    private enum Const {
        static let pageSize = 100
        static let maximumViewModelCount = 1_000
    }

    private let layoutAdapter = CollectionViewLayoutAdapter()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, environment in
            self?.layoutAdapter.sectionLayout(index: index, enviroment: environment)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var collectionViewAdapter = CollectionViewAdapter(
        configuration: .init(refreshControl: .enabled(tintColor: .systemBlue)),
        collectionView: collectionView,
        layoutAdapter: layoutAdapter
    )

    private var viewModels: [VerticalLayoutItemComponent.ViewModel] = [] {
        didSet {
            guard viewModels != oldValue else { return }
            applyViewModels()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        defineLayout()
        resetViewModels()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func defineLayout() {
        backgroundColor = .systemBackground
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func resetViewModels() {
        viewModels = []
        appendViewModels()
    }

    private func appendViewModels() {
        guard viewModels.count < Const.maximumViewModelCount else { return }

        let remainingCount = Const.maximumViewModelCount - viewModels.count
        let nextCount = min(Const.pageSize, remainingCount)
        viewModels.append(contentsOf: (0..<nextCount).map { _ in .random() })
    }

    private func applyViewModels() {
        collectionViewAdapter.apply(
            List {
                Section(id: "vertical-layout-sample") {
                    for viewModel in viewModels {
                        Cell(
                            id: viewModel.id,
                            component: VerticalLayoutItemComponent(viewModel: viewModel)
                        )
                    }
                }
                .withSectionLayout(
                    DefaultCompositionalLayoutSectionFactory.vertical(spacing: 10)
                )
            }
            .onRefresh { [weak self] _ in
                self?.resetViewModels()
            }
            .onReachEnd(offsetFromEnd: .relativeToContainerSize(multiplier: 1.0)) { [weak self] _ in
                self?.appendViewModels()
            }
        )
    }
}

#Preview {
    VerticalLayoutItemView(viewModel: .random())
}
