////
////  TurboDesignSystem.swift
////  
////
////  Created by 김동현 on 2/23/26.
////
//
///**
// `CellDataModel`
// - Cell에 바인딩되는 데이터
// - 참고: 토스에서는 명칭을 CellItemModelType
// 
// `CellDataModelBindable`
// - CellDataModel를 셀 구현체에 바인딩할 수 있는 프로토콜
// - 참고: 토스에서는 명칭을 CellItemModelBindable
// 
// `SampleCellModel`: CellDataModel, FlowSizable
// - 셀 데이터 모델
// - 참고: 토스에서는 ListRowModel: CellItemModelType, FlowSizable
// 
// `SampleCell`: BaseCell, CellDataModelBindable
// - 셀 구현체
// - 참고: 토스에서는 ListRow: BaseView, CellDataModelBindable
// 
// */
//import UIKit
//
//protocol ReuseIdentifiable {
//    static var reuseIdentifier: String { get }
//}
//
//extension ReuseIdentifiable {
//    static var reuseIdentifier: String {
//        String(describing: Self.self)
//    }
//}
//
//extension UICollectionViewCell: ReuseIdentifiable{}
//
///// 터치 가능 여부
//public protocol Touchable {
//    
//}
//
///// 버튼 존재 여부
//public protocol ContainsButton {
//    
//}
//
///// 셀 데이터 타입
///// CollectionViewCell의 프로토콜
///// Model → 어떤 Cell을 사용할지 알고 있음
//public protocol CellDataModel {
//    nonisolated static var cellType: UICollectionViewCell.Type { get }
//}
//
//public extension Component {
//    // TitleComponent.cellType
//    // → ContainerCell<TitleComponent>
//    nonisolated static var cellType: UICollectionViewCell.Type {
//        ContainerCell<Self>.self
//    }
//}
//
///// 셀 사이즈 계산 책임
//@MainActor
//public protocol FlowSizable {
//    func size(cellSize: CGSize) -> CGSize
//}
//
///// CellModel을 바인딩할 수 있는 프로토콜 셀을 실제 셀 UI에 연결해서 화면에 그려주는 작업
//public protocol CellDataModelBindable {
//    @MainActor
//    func bind(to cellDataModel: CellDataModel, context: Context)
//}
//
///// 공통 베이스 셀
//open class BaseCell: UICollectionViewCell, ReuseIdentifiable {
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//}
//
//// MARK: - Component
//public struct Context {
//    public let indexPath: IndexPath
//}
//
//@MainActor
//public protocol Component: CellDataModel, FlowSizable {
//    associatedtype CellUIView: UIView
//    
//    func createCellUIView() -> CellUIView
//    func render(context: Context, content: CellUIView)
//}
//
//class ContainerCell<C>: UICollectionViewCell, CellDataModelBindable where C: Component {
//    
//    private var content: C.CellUIView?
//    
//    func bind(to cellDataModel: CellDataModel, context: Context) {
//        guard let component = cellDataModel as? C else {
//            assertionFailure("Component 타입이 아닙니다.")
//            return
//        }
//        
//        // view 최초 생성
//        content = content ?? component.createCellUIView()
//        guard let content else { return }
//        
//        if content.superview == nil {
//            content.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(content)
//            
//            NSLayoutConstraint.activate([
//                content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//                content.topAnchor.constraint(equalTo: contentView.topAnchor),
//                content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            ])
//        }
//        
//        // Component render
//        component.render(context: context, content: content)
//    }
//}
//
//
//
//
//@MainActor
//public final class CollectionViewAdapter: NSObject {
//    private weak var collectionView: UICollectionView?
//    private var items: [CellDataModel] = []
//    
//    public init(collectionView: UICollectionView) {
//        self.collectionView = collectionView
//        super.init()
//        collectionView.dataSource = self
//        collectionView.delegate = self
//    }
//    
//    public func setItems(_ items: [CellDataModel]) {
//        self.items = items
//        registerCells()
//        collectionView?.reloadData()
//    }
//}
//
//private extension CollectionViewAdapter {
//
//    func registerCells() {
//
//        guard let collectionView else { return }
//
//        items.forEach { model in
//            let cellType = type(of: model).cellType
//
//            collectionView.register(
//                cellType,
//                forCellWithReuseIdentifier: String(describing: cellType)
//            )
//        }
//        // 추후 hashable채택 후 사용예정
////        let cellTypes = Set(items.map { type(of: $0).cellType })
////
////        cellTypes.forEach { cellType in
////            collectionView.register(
////                cellType,
////                forCellWithReuseIdentifier: String(describing: cellType)
////            )
////        }
//    }
//}
//
//extension CollectionViewAdapter: UICollectionViewDataSource {
//
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//        items.count
//    }
//
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//
//        let model = items[indexPath.item]
//        let cellType = type(of: model).cellType
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier,
//                                                      for: indexPath)
//        
//        let context = Context(indexPath: indexPath)
//        
//        (cell as? CellDataModelBindable)?.bind(to: model, context: context)
//        return cell
//    }
//}
//
//extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout {
//
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//
//        let model = items[indexPath.item]
//
//        if let sizable = model as? FlowSizable {
//            return sizable.size(cellSize: collectionView.bounds.size)
//        }
//
//        return .zero
//    }
//}
//
//
//struct TitleComponent: Component {
//    typealias CellUIView = TitleView
//    let title: String
//    
//    /// FlowSizable Protocol
//    func size(cellSize: CGSize) -> CGSize {
//        return CGSize(
//            width: cellSize.width,
//            height: 44
//        )
//    }
//    
//    /// Component Protocol
//    /// 최초 1번 실행
//    func createCellUIView() -> CellUIView {
//        return TitleView()
//    }
//    
//    /// Component Protocol
//    /// 매번 실행
//    func render(context: Context, content: CellUIView) {
//        content.setTitle(title)
//        print(context.indexPath)
//    }
//}
//
//final class TitleView: UIView {
//    
//    private let titleLabel = UILabel()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//private extension TitleView {
//    
//    func setupUI() {
//        
//        backgroundColor = .systemBackground
//        
//        addSubview(titleLabel)
//        
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//        
//        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
//        titleLabel.textColor = .label
//    }
//}
//
//extension TitleView {
//    
//    func setTitle(_ title: String) {
//        titleLabel.text = title
//    }
//}
//
//
//
///*
//
//// MARK: - Ex
//struct TitleCellModel: CellDataModel, FlowSizable {
//    let title: String
//    
//    func size(cellSize: CGSize) -> CGSize {
//        return CGSize(
//            width: cellSize.width,
//            height: 44
//        )
//    }
//}
//
//final class TitleCell: BaseCell, CellDataModelBindable {
//    
//    private let titleLabel = UILabel()
//    
//    // cellDataModel을 원하는 모델로 캐스팅하면 사용할 수 있다
//    func bind(to cellDataModel: CellDataModel) {
//        guard let cellDataModel = cellDataModel as? TitleCellModel else { return }
//        titleLabel.text = cellDataModel.title
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//@MainActor
//public final class CollectionViewAdapter: NSObject {
//    
//    private weak var collectionView: UICollectionView?
//    private var items: [CellDataModel] = []
//    
//    public init(collectionView: UICollectionView) {
//        self.collectionView = collectionView
//        super.init()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//    
//    public func setItems(_ items: [CellDataModel]) {
//        self.items = items
//        registerCells()
//        collectionView?.reloadData()
//    }
//}
//
//private extension CollectionViewAdapter {
//    
//    func registerCells() {
//        guard let collectionView else { return }
//        
//        items.forEach { model in
//            
//            let cellType = type(of: model)
//            
//            if let cell = cellType as? BaseCell.Type {
//                collectionView.register(
//                    cell,
//                    forCellWithReuseIdentifier: cell.reuseIdentifier
//                )
//            }
//        }
//    }
//}
//
//extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout{
//    public func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        let model = items[indexPath.item]
//        if let sizable = model as? FlowSizable {
//            return sizable.size(cellSize: collectionView.bounds.size)
//        }
//        
//        return .zero
//    }
//}
//
//extension CollectionViewAdapter: UICollectionViewDataSource{
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        items.count
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let model = items[indexPath.item]
//        
//        switch model {
//            
//        case let model as TitleCellModel:
//            
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: TitleCell.reuseIdentifier,
//                for: indexPath
//            ) as! TitleCell
//            
//            cell.bind(to: model)
//            
//            return cell
//            
//        default:
//            fatalError("Unsupported model")
//        }
//    }
//}
//
//*/
