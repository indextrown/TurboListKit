//
//  SwiftUIWrapper.swift
//  
//
//  Created by 김동현 on 3/14/26.
//

import SwiftUI

// MARK: - Section Builder
/// Swift DSL 문법을 가능하게 만드는 Result Builder 입니다
///
/// [기존]
/// TurboList([
///     TurboSection("id1") { ... },
///     TurboSection("id2") { ... }
/// ])
///
/// [DSL]
/// TurboList {
///     TurboSection("id1") { ... }
///     TurboSection("id2") { ... }
/// }
@resultBuilder
public struct SwiftUITurboSectionBuilder {

    public static func buildBlock(
        _ components: TurboSection...
    ) -> [TurboSection] {
        return components
    }
}

// MARK: - TurboList
/// SwiftUI에서 사용하는 List View Wrapper입니다
/// TurboSection DSL -> UIKit UICollectionView로 전달하는 역할을 합니다
///
/// 이 코드 덕분에 아래 문법이 가능해집니다
/// TurboList {
///     TurboSection("id1") { ... }
///     TurboSection("id2") { ... }
/// }
public struct TurboList: View {

    // resultBuilder가 만든 [TurboSection] 데이터를 저장합니다
    private let sections: [TurboSection]

    public init(
        @SwiftUITurboSectionBuilder _ content: () -> [TurboSection]
    ) {
        self.sections = content()
    }

    public var body: some View {
        TurboListRepresentable(sections: sections)
    }
}

// MARK: - UIViewRepresentable
/// SwiftUI에서 UIKit View를 사용할 때 반드시 필요합니다
public struct TurboListRepresentable: UIViewRepresentable {
    /// 이 View가 사용할 UIKit View 입니다
    public typealias UIViewType = UICollectionView

    let sections: [TurboSection]

    /**
     SwiftUI LifeCycle 관리 객체입니다
     - SwiftUI View는 계속 재생성됩니다
     - 그래서 UIKit 객체를 유지하려면 Coordinator에 저장해야 합니다
     */
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    /// SwiftUI lifecycle에서 최초 1번 실행
    public func makeUIView(
        context: Self.Context
    ) -> UICollectionView {
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        let adapter = TurboListAdapter(
            collectionView: collectionView,
            animated: true
        )
        
        /**
         makeUIView에서 생성한 adapter는
         지역 변수라 함수 종료 시 해제될 수 있습니다.
         
         SwiftUI lifecycle 동안 유지하기 위해
         Coordinator에 저장합니다.
         */
        context.coordinator.adapter = adapter

        return collectionView
    }

    /**
     SwiftUI 상태가 변경되면 호출됩니다
     */
    public func updateUIView(
        _ uiView: UICollectionView,
        context: Self.Context
    ) {
        context.coordinator.adapter?.apply(sections)
    }

    public final class Coordinator {
        var adapter: TurboListAdapter?
    }
}





/*
// swiftui -> compont test용입니다
// MARK: - SwiftUIViewComponent
extension SwiftUITurboSectionBuilder {
    /// TurboSection 그대로 통과
    public static func buildExpression(
        _ section: TurboSection
    ) -> TurboSection {
        section
    }

    /// SwiftUI View → Component 변환
    public static func buildExpression<V: View>(
        _ view: V
    ) -> Component {
        SwiftUIViewComponent { view }
    }
}

public struct SwiftUIViewComponent<Content: View>: Component {
    public func size(cellSize: CGSize) -> CGSize {

        let host = UIHostingController(rootView: AnyView(content))

        let targetSize = CGSize(
            width: cellSize.width,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = host.view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return CGSize(
            width: cellSize.width,
            height: ceil(size.height)
        )
    }

    /// SwiftUI View는 비교가 불가능하므로
    /// UUID 기반 identity 사용
    private let id = UUID()

    let content: Content

    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    public func createCellUIView() -> HostingCell {
        HostingCell()
    }

    public func render(
        context: Context,
        content view: HostingCell
    ) {
        view.setRootView(self.content)
    }
}

extension SwiftUIViewComponent: Hashable {

    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//
// MARK: - HostingCell
//

public final class HostingCell: UICollectionViewCell {

    private var hostingController: UIHostingController<AnyView>?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setRootView<V: View>(_ view: V) {

        let root = AnyView(view)

        if hostingController == nil {

            let host = UIHostingController(rootView: root)
            host.view.backgroundColor = .clear

            hostingController = host

            contentView.addSubview(host.view)
        } else {
            hostingController?.rootView = root
        }

        hostingController?.view.frame = contentView.bounds
        hostingController?.view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
    }
}
*/
