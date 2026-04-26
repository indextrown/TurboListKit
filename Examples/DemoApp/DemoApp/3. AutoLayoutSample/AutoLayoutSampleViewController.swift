import TurboListKit
import UIKit

final class AutoLayoutSampleViewController: UIViewController {
    private enum Const {
        static let pageSize = 8
        static let maximumItemCount = 200
    }

    private let layoutAdapter = CollectionViewLayoutAdapter()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layoutAdapter: layoutAdapter)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private lazy var adapter = CollectionViewAdapter(
        configuration: .init(refreshControl: .enabled(tintColor: .systemBlue)),
        collectionView: collectionView,
        layoutAdapter: layoutAdapter
    )

    private var items: [AutoLayoutMessageComponent.ViewModel] = []
    private var nextSeed = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Auto Layout Sample"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reload",
            style: .plain,
            target: self,
            action: #selector(reloadItems)
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        resetItems()
        applySnapshot(strategy: .reloadData)
    }

    @objc
    private func reloadItems() {
        resetItems()
        applySnapshot()
    }

    private func resetItems() {
        nextSeed = Int.random(in: 0...40)
        items = makeNextItems(count: Const.pageSize)
    }

    private func appendItems() {
        guard items.count < Const.maximumItemCount else { return }

        let remainingCount = Const.maximumItemCount - items.count
        let nextCount = min(Const.pageSize, remainingCount)
        guard nextCount > 0 else { return }

        items.append(contentsOf: makeNextItems(count: nextCount))
        applySnapshot()
    }

    private func makeNextItems(count: Int) -> [AutoLayoutMessageComponent.ViewModel] {
        let start = nextSeed
        nextSeed += count
        return (0..<count).map { offset in
            AutoLayoutMessageComponent.ViewModel.sample(index: start + offset)
        }
    }

    private func applySnapshot(
        strategy: CollectionViewAdapterUpdateStrategy = .animatedBatchUpdates
    ) {
        adapter.apply(makeList(), updateStrategy: strategy)
    }

    private func makeList() -> List {
        List {
            Section(id: "auto-layout.messages") {
                for item in items {
                    Cell(
                        id: item.id,
                        component: AutoLayoutMessageComponent(viewModel: item)
                    )
                }
            }
            .withHeader(
                SectionHeaderComponent(
                    viewModel: .init(
                        title: "Auto Layout Component",
                        subtitle: "컴포넌트 내부를 UIStackView와 NSLayoutConstraint로만 구성한 예제입니다."
                    )
                )
            )
            .withSectionLayout(
                DefaultCompositionalLayoutSectionFactory.vertical(spacing: 12)
                    .withSectionContentInsets(.init(top: 16, leading: 20, bottom: 20, trailing: 20))
            )
        }
        .onRefresh { [weak self] _ in
            self?.reloadItems()
        }
        .onReachEnd(offsetFromEnd: .relativeToContainerSize(multiplier: 1.0)) { [weak self] _ in
            self?.appendItems()
        }
    }
}
