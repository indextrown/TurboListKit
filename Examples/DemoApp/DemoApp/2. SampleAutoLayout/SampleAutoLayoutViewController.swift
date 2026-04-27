import TurboListKit
import UIKit

final class SampleAutoLayoutViewController: UIViewController {
    private enum Const {
        static let pageSize = 100
        static let maximumViewModelCount = 10000
    }

    private let layoutAdapter = CollectionViewLayoutAdapter()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layoutAdapter: layoutAdapter)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private lazy var collectionViewAdapter = CollectionViewAdapter(
        configuration: CollectionViewAdapterConfiguration(
            refreshControl: .enabled(
                tintColor: .clear,
                text: "새로고침 중...",
                textColor: .white
            ),
            refreshControlAppearance: .init(
                indicator: .image(UIImage(systemName: "arrow.clockwise")!)
                    .size(22)
                    .tintColor(.systemGray)
                    .spin(duration: 0.8)
            )
        ),
        collectionView: collectionView,
        layoutAdapter: layoutAdapter
    )

    private var viewModels: [SampleAutoLayoutItemComponent.ViewModel] = [] {
        didSet {
            guard viewModels != oldValue else { return }
            applyViewModels()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sample Auto Layout"
        view.backgroundColor = .systemBackground

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        resetViewModels()
    }

    private func resetViewModels() {
        viewModels = (0..<Const.pageSize).map { _ in .random() }
    }

    private func appendViewModels() {
        guard viewModels.count < Const.maximumViewModelCount else { return }
        let remainingCount = Const.maximumViewModelCount - viewModels.count
        let nextCount = min(Const.pageSize, remainingCount)
        guard nextCount > 0 else { return }
        viewModels.append(contentsOf: (0..<nextCount).map { _ in .random() })
    }

    private func applyViewModels() {
        collectionViewAdapter.apply(
            List {
                Section(id: "Section") {
                    for viewModel in viewModels {
                        Cell(
                            id: viewModel.id,
                            component: SampleAutoLayoutItemComponent(viewModel: viewModel)
                        )
                        .willDisplay { context in
                            let model = context.anyComponent.base.viewModel as! SampleAutoLayoutItemView.ViewModel
                            print("표시직전: \(model.title ?? "")")
                        }
                        .didEndDisplay { context in
                            let model = context.anyComponent.base.viewModel as! SampleAutoLayoutItemView.ViewModel
                            print("사라짐:  \(model.title ?? "")")
                        }
                        .onHighlight { context in
                            let model = context.anyComponent.base.viewModel as! SampleAutoLayoutItemView.ViewModel
                            print("눌림:  \(model.title ?? "")")
                        }
                        .onUnhighlight { context in
                            let model = context.anyComponent.base.viewModel as! SampleAutoLayoutItemView.ViewModel
                            print("눌림취소:  \(model.title ?? "")")
                        }
                    }
                }
                .withHeader(
                    SectionHeaderComponent(
                        viewModel: .init(title: "헤더 타이틀", subtitle: "헤더 서브 타이틀")
                    )
                )
                .withSectionLayout(
                    DefaultCompositionalLayoutSectionFactory.vertical(spacing: 0)
                        .withSectionContentInsets(.init(top: 16, leading: 20, bottom: 8, trailing: 20))
                        .withHeaderPinToVisibleBounds(true)
                )
            }
            .onRefresh { [weak self] _ in
                self?.resetViewModels()
                print("새로고침!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            }
            .onReachEnd(offsetFromEnd: .relativeToContainerSize(multiplier: 1.0)) { [weak self] _ in
                self?.appendViewModels()
            }
            .didEndDecelerating { _ in
                print("스크롤 감속 종료")
            }
        )
    }
}
