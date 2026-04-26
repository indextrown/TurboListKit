import TurboListKit
import UIKit

final class HorizontalOnlyViewController: UIViewController {
    private struct Card: Equatable {
        let id: String
        let title: String
        let subtitle: String
        let accent: HorizontalFeatureCardComponent.ViewModel.Accent
    }

    private struct Tag: Equatable {
        let id: String
        let title: String
        let tint: HorizontalTagComponent.ViewModel.Tint
    }

    private let layoutAdapter = CollectionViewLayoutAdapter()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layoutAdapter: layoutAdapter)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private lazy var adapter = CollectionViewAdapter(
        configuration: .init(),
        collectionView: collectionView,
        layoutAdapter: layoutAdapter
    )

    private var cards: [Card] = [
        .init(id: "card-1", title: "Paged Cards", subtitle: "groupPagingCentered로 카드가 한 장씩 자연스럽게 넘겨집니다.", accent: .blue),
        .init(id: "card-2", title: "Fit Content", subtitle: "카드 폭은 컴포넌트 sizeThatFits 결과를 기준으로 계산됩니다.", accent: .green),
        .init(id: "card-3", title: "Reload Safe", subtitle: "shuffle이나 reset 이후에도 가로 레이아웃이 안정적으로 유지되는지 확인합니다.", accent: .orange),
        .init(id: "card-4", title: "UIKit First", subtitle: "UIViewController + UICollectionView 조합에서 가로 섹션만 빠르게 실험할 수 있습니다.", accent: .rose),
    ]

    private var tags: [Tag] = [
        .init(id: "tag-1", title: "continuous", tint: .blue),
        .init(id: "tag-2", title: "orthogonal scroll", tint: .green),
        .init(id: "tag-3", title: "fit content", tint: .orange),
        .init(id: "tag-4", title: "invalidation", tint: .rose),
        .init(id: "tag-5", title: "reload", tint: .gray),
        .init(id: "tag-6", title: "paging", tint: .blue),
        .init(id: "tag-7", title: "section inset", tint: .green),
        .init(id: "tag-8", title: "header", tint: .orange),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Horizontal Only"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Shuffle",
            style: .plain,
            target: self,
            action: #selector(shuffleContent)
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        applySnapshot(strategy: .reloadData)
    }

    @objc
    private func shuffleContent() {
        cards.shuffle()
        tags.shuffle()
        applySnapshot()
    }

    private func applySnapshot(
        strategy: CollectionViewAdapterUpdateStrategy = .animatedBatchUpdates
    ) {
        adapter.apply(makeList(), updateStrategy: strategy)
    }

    private func makeList() -> List {
        List {
            cardsSection()
            tagsSection()
        }
    }

    private func cardsSection() -> Section {
        Section(id: "horizontal.cards") {
            for card in cards {
                Cell(
                    id: card.id,
                    component: HorizontalFeatureCardComponent(
                        viewModel: .init(
                            title: card.title,
                            subtitle: card.subtitle,
                            accent: card.accent
                        )
                    )
                )
            }
        }
        .withHeader(
            HorizontalSectionHeaderComponent(
                viewModel: .init(
                    title: "Paging Cards",
                    subtitle: "카드형 fit-content 셀을 가로 페이징으로 보여주는 전용 예제입니다."
                )
            )
        )
        .withSectionLayout(
            DefaultCompositionalLayoutSectionFactory.horizontal(
                spacing: 12,
                scrollingBehavior: .groupPagingCentered
            )
            .withSectionContentInsets(.init(top: 16, leading: 20, bottom: 12, trailing: 20))
        )
    }

    private func tagsSection() -> Section {
        Section(id: "horizontal.tags") {
            for tag in tags {
                Cell(
                    id: tag.id,
                    component: HorizontalTagComponent(
                        viewModel: .init(title: tag.title, tint: tag.tint)
                    )
                )
            }
        }
        .withHeader(
            HorizontalSectionHeaderComponent(
                viewModel: .init(
                    title: "Continuous Tags",
                    subtitle: "작은 pill 컴포넌트를 연속 가로 스크롤로 확인합니다."
                )
            )
        )
        .withSectionLayout(
            DefaultCompositionalLayoutSectionFactory.horizontal(
                spacing: 10,
                scrollingBehavior: .continuous
            )
            .withSectionContentInsets(.init(top: 8, leading: 20, bottom: 20, trailing: 20))
        )
    }
}
