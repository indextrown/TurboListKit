////
////  TurboDesignSystem.swift
////
////
////  Created by 김동현 on 2/23/26.
////
//
//
///// 셀 모델이면서 & 셀의 사이즈를 계산할 수 있다
////class ListRow: CellDataModel, FlowSizable {
////
////}
//
//
//// 어댑터 구현
//
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
//public protocol CellDataModel {
//
//}
//
///// 셀 사이즈 계산 책임
//public protocol FlowSizable {
//    func size(cellSize: CGSize) -> CGSize
//}
//
///// CellModel을 바인딩할 수 있는 프로토콜 셀을 실제 셀 UI에 연결해서 화면에 그려주는 작업
//public protocol CellDataModelBindable {
//    @MainActor
//    func bind(to cellDataModel: CellDataModel)
//}
//
///// 공통 베이스 셀
//open class BaseCell: UICollectionViewCell, ReuseIdentifiable {
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//}
////
////// MARK: - 실제 프로젝트 가정(라이브러리 외부)
////struct TitleModel: CellDataModel, FlowSizable {
////    let title: String
////
////    func size(cellSize: CGSize) -> CGSize {
////        return CGSize(
////            width: cellSize.width,
////            height: 44
////        )
////    }
////}
////
////final class TitleCell: BaseCell, CellDataModelBindable {
////
////    private let titleLabel = UILabel()
////
////    func bind(to cellDataModel: CellDataModel) {
////        guard let cellDataModel = cellDataModel as? TitleModel else { return }
////        titleLabel.text = cellDataModel.title
////    }
////}
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
//            if let cellClass = cellType as? BaseCell.Type {
//                collectionView.register(
//                    cellClass,
//                    forCellWithReuseIdentifier: cellClass.reuseIdentifier
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
//        case let model as TitleModel:
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
//// MARK: - Ex
//struct TitleModel: CellDataModel, FlowSizable {
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
//    func bind(to cellDataModel: CellDataModel) {
//        guard let cellDataModel = cellDataModel as? TitleModel else { return }
//        titleLabel.text = cellDataModel.title
//    }
//}
//



// -----------------------------

//
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
//public protocol CellDataModel {
//
//}
//
///// 셀 사이즈 계산 책임
//public protocol FlowSizable {
//    func size(cellSize: CGSize) -> CGSize
//}
//
///// CellModel을 바인딩할 수 있는 프로토콜 셀을 실제 셀 UI에 연결해서 화면에 그려주는 작업
//public protocol CellDataModelBindable {
//    @MainActor
//    func bind(to cellDataModel: CellDataModel)
//}
//
///// 공통 베이스 셀
//open class BaseCell: UICollectionViewCell, ReuseIdentifiable {
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//}
//
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
//
