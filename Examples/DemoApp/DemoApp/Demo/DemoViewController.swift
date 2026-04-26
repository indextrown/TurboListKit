import TurboListKit
import UIKit

final class DemoViewController: UIViewController {
    private struct FeatureCard: Equatable {
        let id: String
        let title: String
        let subtitle: String
        let accent: FeatureCardComponent.ViewModel.Accent
    }

    private struct Chip: Equatable {
        let id: String
        let title: String
        let tint: TagComponent.ViewModel.Tint
    }

    private let layoutAdapter = CollectionViewLayoutAdapter()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layoutAdapter: layoutAdapter)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private lazy var adapter = CollectionViewAdapter(
        configuration: .init(
            refreshControl: .enabled(tintColor: .systemBlue),
            batchUpdateInterruptCount: 50
        ),
        collectionView: collectionView,
        layoutAdapter: layoutAdapter
    )

    private var selectedMessage = "아직 선택된 아이템이 없습니다."
    private var cards: [FeatureCard] = [
        .init(id: "feature-layout", title: "Compositional Layout", subtitle: "세로, 가로, 그리드를 선언형으로 조합합니다.", accent: .blue),
        .init(id: "feature-event", title: "Event Hooks", subtitle: "select, scroll, refresh, reach-end를 modifier처럼 붙입니다.", accent: .green),
        .init(id: "feature-component", title: "UIView Component", subtitle: "SwiftUI와 비슷한 감각으로 UIKit 뷰를 렌더링합니다.", accent: .orange),
        .init(id: "feature-diff", title: "DifferenceKit", subtitle: "데이터 변경 시 staged updates로 화면을 갱신합니다.", accent: .rose),
    ]
    private var chips: [Chip] = [
        .init(id: "chip-declarative", title: "Declarative", tint: .blue),
        .init(id: "chip-reuse", title: "Reusable", tint: .green),
        .init(id: "chip-header", title: "Header/Footer", tint: .orange),
        .init(id: "chip-prefetch", title: "Prefetch", tint: .rose),
        .init(id: "chip-sizing", title: "Auto Sizing", tint: .gray),
        .init(id: "chip-refresh", title: "Refresh", tint: .blue),
    ]
    private var feedItems = DemoViewController.makeInitialFeedItems()
    private var logs = [
        "데모가 준비되었습니다.",
        "카드를 탭하거나 아래로 당겨서 라이브러리 동작을 확인해보세요.",
    ]
    private var page = 1
    private var isLoadingMore = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "TurboListKit"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleContent)),
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetContent)),
        ]

        view.backgroundColor = .systemGroupedBackground
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
        chips.shuffle()
        feedItems.shuffle()
        appendLog("Shuffle 버튼으로 데모 데이터를 다시 섞었습니다.")
        applySnapshot()
    }

    @objc
    private func resetContent() {
        selectedMessage = "아직 선택된 아이템이 없습니다."
        cards = [
            .init(id: "feature-layout", title: "Compositional Layout", subtitle: "세로, 가로, 그리드를 선언형으로 조합합니다.", accent: .blue),
            .init(id: "feature-event", title: "Event Hooks", subtitle: "select, scroll, refresh, reach-end를 modifier처럼 붙입니다.", accent: .green),
            .init(id: "feature-component", title: "UIView Component", subtitle: "SwiftUI와 비슷한 감각으로 UIKit 뷰를 렌더링합니다.", accent: .orange),
            .init(id: "feature-diff", title: "DifferenceKit", subtitle: "데이터 변경 시 staged updates로 화면을 갱신합니다.", accent: .rose),
        ]
        chips = [
            .init(id: "chip-declarative", title: "Declarative", tint: .blue),
            .init(id: "chip-reuse", title: "Reusable", tint: .green),
            .init(id: "chip-header", title: "Header/Footer", tint: .orange),
            .init(id: "chip-prefetch", title: "Prefetch", tint: .rose),
            .init(id: "chip-sizing", title: "Auto Sizing", tint: .gray),
            .init(id: "chip-refresh", title: "Refresh", tint: .blue),
        ]
        feedItems = Self.makeInitialFeedItems()
        logs = [
            "데모가 초기 상태로 복원되었습니다.",
            "세로 리스트, 가로 카드, 그리드 섹션을 다시 확인해보세요.",
        ]
        page = 1
        isLoadingMore = false
        appendLog("Reset 버튼으로 전체 데모 상태를 복원했습니다.")
        applySnapshot(strategy: .reloadData)
    }

    private func applySnapshot(
        strategy: CollectionViewAdapterUpdateStrategy = .animatedBatchUpdates
    ) {
        adapter.apply(makeList(), updateStrategy: strategy)
    }

    private func makeList() -> List {
        List {
            overviewSection()
            featuredCardsSection()
            chipsSection()
            feedSection()
            eventLogSection()
        }
        .onRefresh { [weak self] _ in
            self?.handleRefresh()
        }
        .onReachEnd(offsetFromEnd: .relativeToContainerSize(multiplier: 0.5)) { [weak self] _ in
            self?.loadMoreIfNeeded()
        }
    }

    private func overviewSection() -> Section {
        Section(id: "overview") {
            Cell(
                id: "overview.summary",
                component: TextComponent(
                    viewModel: .init(
                        title: "이 라이브러리는 `Component -> Cell -> Section -> List -> CollectionViewAdapter` 흐름으로 UICollectionView를 선언형으로 다루게 해줍니다.",
                        detail: "데모에서는 레이아웃 팩토리, header/footer, 이벤트 훅, staged update 흐름을 한 화면에 모아 보여줍니다.",
                        tone: .accent
                    )
                )
            )
            Cell(
                id: "overview.status",
                component: TextComponent(
                    viewModel: .init(
                        title: "현재 상태",
                        detail: selectedMessage,
                        tone: .neutral
                    )
                )
            )
        }
        .withHeader(
            SectionHeaderComponent(
                viewModel: .init(
                    title: "Overview",
                    subtitle: "라이브러리 구조와 현재 선택 상태를 요약합니다."
                )
            )
        )
        .withSectionLayout(
            DefaultCompositionalLayoutSectionFactory.vertical(spacing: 12)
                .withSectionContentInsets(.init(top: 20, leading: 20, bottom: 8, trailing: 20))
        )
    }

    private func featuredCardsSection() -> Section {
        Section(id: "featured.cards") {
            for card in cards {
                Cell(
                    id: card.id,
                    component: FeatureCardComponent(
                        viewModel: .init(
                            title: card.title,
                            subtitle: card.subtitle,
                            accent: card.accent
                        )
                    )
                )
                .didSelect { [weak self] context in
                    self?.selectedMessage = "'\(card.title)' 카드가 선택되었습니다. indexPath=\(context.indexPath.section)-\(context.indexPath.item)"
                    self?.appendLog("카드 선택: \(card.title)")
                    self?.applySnapshot()
                }
            }
        }
        .withHeader(
            SectionHeaderComponent(
                viewModel: .init(
                    title: "Horizontal Cards",
                    subtitle: "가로 스크롤 섹션과 fit-content 셀을 보여줍니다."
                )
            )
        )
        .withSectionLayout(
            DefaultCompositionalLayoutSectionFactory.horizontal(
                spacing: 12,
                scrollingBehavior: .groupPagingCentered
            )
            .withSectionContentInsets(.init(top: 16, leading: 20, bottom: 8, trailing: 20))
        )
    }

    private func chipsSection() -> Section {
        Section(id: "chips.grid") {
            for chip in chips {
                Cell(
                    id: chip.id,
                    component: TagComponent(
                        viewModel: .init(title: chip.title, tint: chip.tint)
                    )
                )
                .didSelect { [weak self] _ in
                    self?.selectedMessage = "'\(chip.title)' 태그가 선택되었습니다."
                    self?.appendLog("그리드 태그 선택: \(chip.title)")
                    self?.applySnapshot()
                }
            }
        }
        .withHeader(
            SectionHeaderComponent(
                viewModel: .init(
                    title: "Grid Layout",
                    subtitle: "세로 그리드 섹션과 재사용 가능한 작은 컴포넌트를 보여줍니다."
                )
            )
        )
        .withSectionLayout(
            DefaultCompositionalLayoutSectionFactory.verticalGrid(
                numberOfItemsInRow: 2,
                itemSpacing: 12,
                lineSpacing: 12
            )
            .withSectionContentInsets(.init(top: 16, leading: 20, bottom: 8, trailing: 20))
        )
    }

    private func feedSection() -> Section {
        Section(id: "feed") {
            for item in feedItems {
                Cell(
                    id: item.id,
                    component: TextComponent(
                        viewModel: .init(
                            title: item.title,
                            detail: item.detail,
                            tone: .neutral
                        )
                    )
                )
                .didSelect { [weak self] _ in
                    self?.selectedMessage = "'\(item.title)' 피드 아이템이 선택되었습니다."
                    self?.appendLog("피드 선택: \(item.title)")
                    self?.applySnapshot()
                }
            }
        }
        .withHeader(
            SectionHeaderComponent(
                viewModel: .init(
                    title: "Vertical Feed",
                    subtitle: "pull-to-refresh와 reach-end 이벤트가 연결된 세로 리스트입니다."
                )
            )
        )
        .withFooter(
            TextComponent(
                viewModel: .init(
                    title: isLoadingMore ? "추가 데이터를 불러오는 중입니다..." : "리스트 끝으로 스크롤하면 새로운 예시 셀이 이어서 추가됩니다.",
                    detail: nil,
                    tone: .subtle
                )
            ),
            alignment: .bottom
        )
        .withSectionLayout(
            DefaultCompositionalLayoutSectionFactory.vertical(spacing: 12)
                .withSectionContentInsets(.init(top: 16, leading: 20, bottom: 8, trailing: 20))
                .withHeaderPinToVisibleBounds(true)
        )
    }

    private func eventLogSection() -> Section {
        Section(id: "logs") {
            for (index, entry) in logs.enumerated() {
                Cell(
                    id: "log-\(index)-\(entry)",
                    component: TextComponent(
                        viewModel: .init(
                            title: entry,
                            detail: nil,
                            tone: .subtle
                        )
                    )
                )
            }
        }
        .withHeader(
            SectionHeaderComponent(
                viewModel: .init(
                    title: "Event Log",
                    subtitle: "데모 화면에서 발생한 상호작용이 최신순으로 쌓입니다."
                )
            )
        )
        .withSectionLayout(
            DefaultCompositionalLayoutSectionFactory.vertical(spacing: 8)
                .withSectionContentInsets(.init(top: 16, leading: 20, bottom: 32, trailing: 20))
        )
    }

    private func handleRefresh() {
        selectedMessage = "pull-to-refresh가 호출되어 콘텐츠를 새로 섞었습니다."
        cards.rotateLeft()
        chips.rotateLeft()
        feedItems.reverse()
        appendLog("pull-to-refresh 실행")
        applySnapshot()
    }

    private func loadMoreIfNeeded() {
        guard isLoadingMore == false, page < 3 else {
            return
        }

        isLoadingMore = true
        appendLog("리스트 끝 도달: page \(page + 1) 로딩 시작")
        applySnapshot(strategy: .reloadData)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self else { return }

            page += 1
            feedItems.append(contentsOf: Self.makeMoreFeedItems(page: page))
            isLoadingMore = false
            appendLog("추가 데이터 \(Self.makeMoreFeedItems(page: page).count)개를 붙였습니다.")
            applySnapshot()
        }
    }

    private func appendLog(_ message: String) {
        logs.insert(message, at: 0)
        logs = Array(logs.prefix(8))
    }
}

private extension DemoViewController {
    struct FeedItem: Equatable {
        let id: String
        let title: String
        let detail: String
    }

    static func makeInitialFeedItems() -> [FeedItem] {
        [
            .init(id: "feed-1", title: "Component", detail: "가장 작은 렌더링 단위입니다. UIView와 ViewModel을 선언형으로 묶습니다."),
            .init(id: "feed-2", title: "Cell", detail: "식별자와 이벤트를 가진 UICollectionViewCell 표현입니다."),
            .init(id: "feed-3", title: "Section", detail: "cells, header/footer, compositional layout을 함께 선언합니다."),
            .init(id: "feed-4", title: "List", detail: "섹션 배열과 scroll/refresh/reach-end 같은 리스트 이벤트를 담습니다."),
            .init(id: "feed-5", title: "CollectionViewAdapter", detail: "UICollectionView delegate/dataSource를 내부에서 연결하고 apply로 화면을 갱신합니다."),
        ]
    }

    static func makeMoreFeedItems(page: Int) -> [FeedItem] {
        [
            .init(id: "feed-\(page)-1", title: "Page \(page) / Diff Update", detail: "DifferenceKit staged changeset으로 insert/delete/move를 계산합니다."),
            .init(id: "feed-\(page)-2", title: "Page \(page) / Auto Sizing", detail: "Component의 layoutMode와 size cache가 compositional layout size에 반영됩니다."),
            .init(id: "feed-\(page)-3", title: "Page \(page) / Header Footer", detail: "supplementary view도 동일한 component 파이프라인으로 렌더링됩니다."),
        ]
    }
}

private extension Array {
    mutating func rotateLeft() {
        guard let first else { return }
        removeFirst()
        append(first)
    }
}
