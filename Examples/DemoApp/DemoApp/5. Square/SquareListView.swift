import TurboListKit
import UIKit

final class SquareListView: UIView {
    private let layoutAdapter = CollectionViewLayoutAdapter()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layoutAdapter: layoutAdapter)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private lazy var collectionViewAdapter = CollectionViewAdapter(
        configuration: CollectionViewAdapterConfiguration(),
        collectionView: collectionView,
        layoutAdapter: layoutAdapter
    )

    private let viewModels = SquareItemComponent.ViewModel.samples()

    override init(frame: CGRect) {
        super.init(frame: frame)
        defineLayout()
        applyViewModels()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func defineLayout() {
        addSubview(collectionView)
    }

    private func applyViewModels() {
        collectionViewAdapter.apply(
            List {
                Section(id: "SquareSection") {
                    for viewModel in viewModels {
                        Cell(
                            id: viewModel.id,
                            component: SquareItemComponent(viewModel: viewModel)
                        )
                        .onHighlight { context in
                            let model = context.anyComponent.base.viewModel as! SquareItemComponent.ViewModel
                            print("눌림:  \(model.title)")
                        }
                        .onUnhighlight { context in
                            let model = context.anyComponent.base.viewModel as! SquareItemComponent.ViewModel
                            print("눌림취소:  \(model.title)")
                        }
                    }
                }
                .withHeader(
                    SectionHeaderComponent(
                        viewModel: .init(
                            title: "정사각형 셀",
                            subtitle: "2열 그리드에서 셀 너비를 기준으로 높이를 맞추는 예제"
                        )
                    )
                )
                .withSectionLayout(
                    DefaultCompositionalLayoutSectionFactory.verticalGrid(
                        numberOfItemsInRow: 2,
                        itemSpacing: 12,
                        lineSpacing: 12
                    )
                    .withHeaderPinToVisibleBounds(true)
                    .withSectionContentInsets(.init(top: 16, leading: 20, bottom: 16, trailing: 20))
                )
            }
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}
