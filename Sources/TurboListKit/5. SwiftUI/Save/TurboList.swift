////
////  TurboList.swift
////  
////
////  Created by 김동현 on 3/14/26.
////
//
//import SwiftUI
//import UIKit
//
//// MARK: - TurboList
//public struct TurboList<Content: View>: View {
//
//    private let views: [AnyView]
//    private let spacing: CGFloat
//
//    public init(
//        spacing: CGFloat = 0,
//        @ViewBuilder content: () -> Content
//    ) {
//        self.spacing = spacing
//        self.views = TurboList.flatten(content())
//    }
//
//    public var body: some View {
//        TurboListRepresentable(
//            views: views,
//            spacing: spacing
//        )
//    }
//}
//
//// MARK: - flatten
//extension TurboList {
//
//    static func flatten<V: View>(_ view: V) -> [AnyView] {
//
//        let mirror = Mirror(reflecting: view)
//
//        if mirror.displayStyle == .tuple {
//            return mirror.children.compactMap {
//                AnyView(_fromValue: $0.value)
//            }
//        }
//
//        return [AnyView(view)]
//    }
//}
//
//
//struct TurboListRepresentable: UIViewRepresentable {
//
//    let views: [AnyView]
//    let spacing: CGFloat
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(views: views)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<Self>) -> UICollectionView {
//
//        HostingCell.spacing = spacing
//
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = spacing
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.itemSize = UICollectionViewFlowLayout.automaticSize
//        layout.sectionInset = .zero
//
//        let collectionView = UICollectionView(
//            frame: .zero,
//            collectionViewLayout: layout
//        )
//
//        collectionView.dataSource = context.coordinator
//        collectionView.backgroundColor = .clear
//        collectionView.alwaysBounceVertical = true
//
//        collectionView.register(
//            HostingCell.self,
//            forCellWithReuseIdentifier: "cell"
//        )
//
//        return collectionView
//    }
//
//    func updateUIView(
//        _ uiView: UICollectionView,
//        context: UIViewRepresentableContext<Self>
//    ) {
//        context.coordinator.views = views
//        uiView.reloadData()
//    }
//}
//
//
//
//extension TurboListRepresentable {
//
//    final class Coordinator: NSObject, UICollectionViewDataSource {
//
//        var views: [AnyView]
//
//        init(views: [AnyView]) {
//            self.views = views
//        }
//
//        func collectionView(
//            _ collectionView: UICollectionView,
//            numberOfItemsInSection section: Int
//        ) -> Int {
//            views.count
//        }
//
//        func collectionView(
//            _ collectionView: UICollectionView,
//            cellForItemAt indexPath: IndexPath
//        ) -> UICollectionViewCell {
//
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "cell",
//                for: indexPath
//            ) as! HostingCell
//
//            cell.setView(views[indexPath.item])
//
//            return cell
//        }
//    }
//}
//
//
//final class HostingCell: UICollectionViewCell {
//
//    static var spacing: CGFloat = 0
//
//    private var hostingController: UIHostingController<AnyView>?
//
//    func setView(_ view: AnyView) {
//
//        if hostingController == nil {
//
//            let host = UIHostingController(rootView: view)
//            host.view.backgroundColor = .clear
//            host.view.translatesAutoresizingMaskIntoConstraints = false
//
//            hostingController = host
//
//            contentView.addSubview(host.view)
//
//            NSLayoutConstraint.activate([
//                host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
//                host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//                host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            ])
//
//        } else {
//            hostingController?.rootView = view
//        }
//    }
//
//    override func preferredLayoutAttributesFitting(
//        _ layoutAttributes: UICollectionViewLayoutAttributes
//    ) -> UICollectionViewLayoutAttributes {
//
//        guard let collectionView = superview as? UICollectionView else {
//            return layoutAttributes
//        }
//
//        setNeedsLayout()
//        layoutIfNeeded()
//
//        let targetSize = CGSize(
//            width: collectionView.bounds.width,
//            height: UIView.layoutFittingCompressedSize.height
//        )
//
//        let size = contentView.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .fittingSizeLevel
//        )
//        layoutAttributes.size.width = collectionView.bounds.width
//        layoutAttributes.size.height = ceil(size.height)
//
//        return layoutAttributes
//    }
//}
//
////struct ContentView: View {
////
////    var body: some View {
////        VStack {
////            TurboList {
////                
////                Text("Hello")
////
////                VStack {
////                    Text("SwiftUI Cell")
////                }
////            }
////        }
////    }
////}
////
////#Preview {
////    ContentView()
////}

// UIViewRepresentableContext<Self>
//
//import SwiftUI
//import UIKit
//
//// MARK: - TurboList
//
//public struct TurboList<Content: View>: View {
//
//    private let views: [AnyView]
//    private let spacing: CGFloat
//
//    public init(
//        spacing: CGFloat = 0,
//        @ViewBuilder content: () -> Content
//    ) {
//        self.spacing = spacing
//        self.views = TurboList.flatten(content())
//    }
//
//    public var body: some View {
//        TurboListRepresentable(
//            views: views,
//            spacing: spacing
//        )
//    }
//}
//
//// MARK: - flatten
//
//extension TurboList {
//
//    static func flatten<V: View>(_ view: V) -> [AnyView] {
//
//        let mirror = Mirror(reflecting: view)
//
//        if String(describing: type(of: view)).starts(with: "TupleView") {
//
//            if let tuple = mirror.children.first?.value {
//
//                let tupleMirror = Mirror(reflecting: tuple)
//
//                return tupleMirror.children.compactMap {
//                    AnyView(_fromValue: $0.value)
//                }
//            }
//        }
//
//        return [AnyView(view)]
//    }
//}
//
//// MARK: - Representable
//
//struct TurboListRepresentable: UIViewRepresentable {
//
//    let views: [AnyView]
//    let spacing: CGFloat
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(
//            views: views,
//            spacing: spacing
//        )
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<Self>) -> UICollectionView {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = spacing
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//
//        let collectionView = UICollectionView(
//            frame: .zero,
//            collectionViewLayout: layout
//        )
//
//        collectionView.dataSource = context.coordinator
//        collectionView.delegate = context.coordinator
//        collectionView.backgroundColor = .clear
//        collectionView.alwaysBounceVertical = true
//
//        collectionView.register(
//            HostingCell.self,
//            forCellWithReuseIdentifier: "cell"
//        )
//
//        return collectionView
//    }
//
//    func updateUIView(
//        _ collectionView: UICollectionView,
//        context: UIViewRepresentableContext<Self>
//    ) {
//        context.coordinator.views = views
//        collectionView.reloadData()
//    }
//}
//
//// MARK: - Coordinator
//
//extension TurboListRepresentable {
//
//    final class Coordinator: NSObject,
//        UICollectionViewDataSource,
//        UICollectionViewDelegateFlowLayout {
//
//        var views: [AnyView]
//        let spacing: CGFloat
//
//        init(
//            views: [AnyView],
//            spacing: CGFloat
//        ) {
//            self.views = views
//            self.spacing = spacing
//        }
//
//        func collectionView(
//            _ collectionView: UICollectionView,
//            numberOfItemsInSection section: Int
//        ) -> Int {
//            views.count
//        }
//
//        func collectionView(
//            _ collectionView: UICollectionView,
//            cellForItemAt indexPath: IndexPath
//        ) -> UICollectionViewCell {
//
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "cell",
//                for: indexPath
//            ) as! HostingCell
//
//            cell.setView(views[indexPath.item])
//
//            return cell
//        }
//    }
//}
//
//// MARK: - HostingCell
//
//final class HostingCell: UICollectionViewCell {
//
//    private var host: UIHostingController<AnyView>?
//
//    func setView(_ view: AnyView) {
//
//        if host == nil {
//
//            let controller = UIHostingController(rootView: view)
//            controller.view.backgroundColor = .clear
//            controller.view.translatesAutoresizingMaskIntoConstraints = false
//
//            host = controller
//
//            contentView.addSubview(controller.view)
//
//            NSLayoutConstraint.activate([
//                controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
//                controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//                controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            ])
//
//        } else {
//            host?.rootView = view
//        }
//    }
//
//    // 핵심: self sizing 안정화
//    override func preferredLayoutAttributesFitting(
//        _ layoutAttributes: UICollectionViewLayoutAttributes
//    ) -> UICollectionViewLayoutAttributes {
//
//        guard let collectionView = superview as? UICollectionView else {
//            return layoutAttributes
//        }
//
//        setNeedsLayout()
//        layoutIfNeeded()
//
//        let targetSize = CGSize(
//            width: collectionView.bounds.width,
//            height: UIView.layoutFittingCompressedSize.height
//        )
//
//        let size = contentView.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .fittingSizeLevel
//        )
//
//        layoutAttributes.frame.size = CGSize(
//            width: collectionView.bounds.width,
//            height: ceil(size.height)
//        )
//
//        return layoutAttributes
//    }
//}

//
//import SwiftUI
//import UIKit
//import DifferenceKit
//
//// MARK: - TurboItem
//
//public struct TurboItem: Differentiable {
//
//    public let id: AnyHashable
//    let view: AnyView
//
//    public init<V: View>(id: AnyHashable, _ view: V) {
//        self.id = id
//        self.view = AnyView(view)
//    }
//
//    public var differenceIdentifier: AnyHashable {
//        id
//    }
//
//    public func isContentEqual(to source: TurboItem) -> Bool {
//        id == source.id
//    }
//}
//
////
//// MARK: - ResultBuilder
////
//
//@resultBuilder
//public struct TurboListBuilder {
//
//    public static func buildBlock(_ components: [TurboItem]...) -> [TurboItem] {
//        components.flatMap { $0 }
//    }
//
//    public static func buildExpression(_ expression: TurboItem) -> [TurboItem] {
//        [expression]
//    }
//
//    public static func buildExpression<V: View>(_ expression: V) -> [TurboItem] {
//        [
//            TurboItem(
//                id: UUID(),
//                expression
//            )
//        ]
//    }
//
//    public static func buildOptional(_ component: [TurboItem]?) -> [TurboItem] {
//        component ?? []
//    }
//
//    public static func buildArray(_ components: [[TurboItem]]) -> [TurboItem] {
//        components.flatMap { $0 }
//    }
//}
//
////
//// MARK: - TurboList
////
//
//public struct TurboList: View {
//
//    private let items: [TurboItem]
//    private let spacing: CGFloat
//
//    public init(
//        spacing: CGFloat = 0,
//        @TurboListBuilder content: () -> [TurboItem]
//    ) {
//
//        self.spacing = spacing
//        self.items = content()
//    }
//    
////    public init<Data, Content>(
////        _ data: Data,
////        spacing: CGFloat = 0,
////        @ViewBuilder content: @escaping (Data.Element) -> Content
////    ) where Data: RandomAccessCollection,
////            Data.Element: Identifiable,
////            Content: View {
////
////        self.spacing = spacing
////        self.items = data.map {
////            TurboItem(
////                id: $0.id,
////                content($0)
////            )
////        }
////    }
//    
//    public init<Data, ID, Content>(
//        _ data: Data,
//        id: KeyPath<Data.Element, ID>,
//        spacing: CGFloat = 0,
//        @ViewBuilder content: @escaping (Data.Element) -> Content
//    ) where Data: RandomAccessCollection,
//            ID: Hashable,
//            Content: View {
//
//        self.spacing = spacing
//        self.items = data.map {
//            TurboItem(
//                id: $0[keyPath: id],
//                content($0)
//            )
//        }
//    }
//
//    public var body: some View {
//
//        TurboListRepresentable(
//            spacing: spacing,
//            items: items
//        )
//    }
//}
//
////
//// MARK: - UIViewRepresentable
////
//
//public struct TurboListRepresentable: UIViewRepresentable {
//
//    let spacing: CGFloat
//    let items: [TurboItem]
//
//    public func makeCoordinator() -> Coordinator {
//        Coordinator(spacing: spacing, items: items)
//    }
//
//    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UICollectionView {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = spacing
//        layout.itemSize = UICollectionViewFlowLayout.automaticSize
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//
//        let collectionView = UICollectionView(
//            frame: .zero,
//            collectionViewLayout: layout
//        )
//
//        collectionView.dataSource = context.coordinator
//        collectionView.delegate = context.coordinator
//
//        collectionView.backgroundColor = .clear
//        collectionView.alwaysBounceVertical = true
//        collectionView.showsVerticalScrollIndicator = false
//
//        collectionView.register(
//            TurboListCell.self,
//            forCellWithReuseIdentifier: "cell"
//        )
//
//        context.coordinator.collectionView = collectionView
//
//        return collectionView
//    }
//
//    public func updateUIView(
//        _ uiView: UICollectionView,
//        context: UIViewRepresentableContext<Self>
//    ) {
//
//        context.coordinator.apply(items: items)
//    }
//}
//
////
//// MARK: - Coordinator
////
//
//public final class Coordinator: NSObject {
//
//    let spacing: CGFloat
//    var items: [TurboItem]
//
//    weak var collectionView: UICollectionView?
//
//    init(spacing: CGFloat, items: [TurboItem]) {
//        self.spacing = spacing
//        self.items = items
//    }
//
//    @MainActor
//    func apply(items newItems: [TurboItem]) {
//
//        guard let collectionView else { return }
//
//        let changeset = StagedChangeset(
//            source: items,
//            target: newItems
//        )
//
//        print("changeset:", changeset)
//
//        
//        collectionView.reload(
//            using: changeset,
//            setData: { data in
//                self.items = data
//            }
//        )
//    }
//}
//
////
//// MARK: - DataSource
////
//
//extension Coordinator: UICollectionViewDataSource {
//
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//
//        items.count
//    }
//
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "cell",
//            for: indexPath
//        )
//
//        let item = items[indexPath.item]
//
//        if #available(iOS 16.0, *) {
//            cell.contentConfiguration = UIHostingConfiguration {
//                
//                item.view
//                    .frame(maxWidth: .infinity)
//                
//            }.margins(.all, 0)
//        } else {
//            // Fallback on earlier versions
//        }
//
//        return cell
//    }
//}
//
////
//// MARK: - Layout
////
//
//extension Coordinator: UICollectionViewDelegateFlowLayout {
//
//    // 셀 간격
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumLineSpacingForSectionAt section: Int
//    ) -> CGFloat {
//
//        spacing
//    }
//}
//
////
//// MARK: - Cell
////
//
//final class TurboListCell: UICollectionViewCell {
//
//    override func preferredLayoutAttributesFitting(
//        _ layoutAttributes: UICollectionViewLayoutAttributes
//    ) -> UICollectionViewLayoutAttributes {
//
//        let attrs = super.preferredLayoutAttributesFitting(layoutAttributes)
//
//        if let collectionView = superview as? UICollectionView {
//            attrs.frame.size.width = collectionView.bounds.width
//        }
//
//        return attrs
//    }
//}



//
//  TurboList.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/14/26.
//
//
//import SwiftUI
//import TurboListKit
//
//struct TurboCell: View {
//    var number: Int
//    
//    var body: some View {
//        VStack {
//            Text("\(number)")
//                .font(.system(size: 20, weight: .bold))
//            Text("Hello, World!")
//        }
//        .frame(maxWidth: .infinity)
//        .border(.red)
//    }
//}
//
//struct TurboListView: View {
//    
//    var body: some View {
//        VStack(spacing: 0) {
//
//            Header(title: "123")
//
//            TurboList(0..<5, id: \.self) { idx in
//                TurboCell(number: idx)
//            }
//
//            Header(title: "123")
//
//            TurboList(0..<5, id: \.self) { idx in
//                TurboCell(number: idx)
//            }
//        }
//    }
//}
//
//#Preview {
//    TurboListView()
//}
//
