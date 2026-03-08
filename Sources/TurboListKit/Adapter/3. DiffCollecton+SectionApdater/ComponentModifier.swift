//
//  File.swift
//  TurboListKit
//
//  Created by 김동현 on 3/8/26.
//

import DifferenceKit
import UIKit

/*
 Component: 셀을 어떻게 만들고 어떻게 그릴지 정의하는 타입
 - 어떤 Cell을 사용할지
 - 셀 사이즈
 - UI 생성
 - UI 렌더링

@MainActor
public protocol Component: CellDataModel, FlowSizable {
    /// 이 Component는 어떤 UIView를 사용할 것인가
    /// struct TitleComponent: Component {
    ///    typealias CellUIView = UILabel
    /// }
    /// typealias CellUIView = UILabel
    associatedtype CellUIView: UIView
    
    /// 최초 1번: Cell 안에 들어갈 UIView 생성
    func createCellUIView() -> CellUIView
    
    /// 매번: 데이터 바인딩
    func render(context: Context, content: CellUIView)
}
 */
public protocol ComponentModifier: Component {
    // 다른 Component를 감싸는 Modifier
    // 그리고 Wrapped Component와 동일한 UIView 타입을 사용해야 한다
    associatedtype Wrapped: Component where Wrapped.CellUIView == CellUIView
    var wrapped: Wrapped { get }
}

/*
 [OnTouchModifier]
 let component = OnTouchModifier(
     wrapped: TitleComponent(),
     onTouch: { view in print("tap") }
 )
 
 [DSL API]
 TitleComponent()
     .onTouch { view in
         print("tap")
     }
 */
public struct OnTouchModifier<Wrapped: Component>: ComponentModifier
where Wrapped.CellUIView: Touchable {

    
    public typealias CellUIView = Wrapped.CellUIView
    public let wrapped: Wrapped
    public let onTouch: (CellUIView) -> Void
    
    @MainActor
    public func size(cellSize: CGSize) -> CGSize {
        wrapped.size(cellSize: cellSize)
    }
    
    @MainActor
    public func createCellUIView() -> CellUIView {
        wrapped.createCellUIView()
    }
    
    @MainActor
    public func render(context: Context, content: CellUIView) {
        wrapped.render(context: context, content: content)
        content.touchableAreaTap {
            onTouch(content)
        }
    }
}

extension OnTouchModifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrapped == rhs.wrapped
    }
}

public extension Component where CellUIView: Touchable {

    func onTouch(
        _ action: @escaping (CellUIView) -> Void
    ) -> OnTouchModifier<Self> {

        OnTouchModifier(
            wrapped: self,
            onTouch: action
        )
    }
    
    func onTouch(
        _ action: @escaping () -> Void
    ) -> OnTouchModifier<Self> {

        OnTouchModifier(
            wrapped: self,
            onTouch: { _ in action() }
        )
    }
}








public protocol LayoutModifier: Component {
    associatedtype Wrapped: Component
    var wrapped: Wrapped { get }
}



public final class PaddingContainerView<Content: UIView>: UIView {

    let content: Content
    let inset: UIEdgeInsets

    public init(content: Content, inset: UIEdgeInsets) {
        self.content = content
        self.inset = inset
        super.init(frame: .zero)

        addSubview(content)
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        content.frame = bounds.inset(by: inset)
    }
}
public struct PaddingModifier<Wrapped: Component>: LayoutModifier {

    public typealias CellUIView = PaddingContainerView<Wrapped.CellUIView>

    public let wrapped: Wrapped
    public let inset: UIEdgeInsets

//    public func size(cellSize: CGSize) -> CGSize {
//        return wrapped.size(cellSize: cellSize)
//    }
    
    public func size(cellSize: CGSize) -> CGSize {
            let inner = wrapped.size(cellSize: cellSize)

            return CGSize(
                width: inner.width,
                height: inner.height + inset.top + inset.bottom
            )
        }

    public func createCellUIView() -> CellUIView {

        let inner = wrapped.createCellUIView()

        return PaddingContainerView(
            content: inner,
            inset: inset
        )
    }

    public func render(context: Context, content: CellUIView) {

        wrapped.render(
            context: context,
            content: content.content
        )
    }
}
extension PaddingModifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrapped == rhs.wrapped
    }
}

public extension Component {

    func padding(left value: CGFloat) -> PaddingModifier<Self> {
        PaddingModifier(
            wrapped: self,
            inset: UIEdgeInsets(
                top: 0,
                left: value,
                bottom: 0,
                right: 0
            )
        )
    }

    func padding(right value: CGFloat) -> PaddingModifier<Self> {
        PaddingModifier(
            wrapped: self,
            inset: UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: value
            )
        )
    }
}

public extension Component {

    func padding(vertical value: CGFloat) -> PaddingModifier<Self> {
        PaddingModifier(
            wrapped: self,
            inset: UIEdgeInsets(
                top: value,
                left: 0,
                bottom: value,
                right: 0
            )
        )
    }

    func padding(horizontal value: CGFloat) -> PaddingModifier<Self> {
        PaddingModifier(
            wrapped: self,
            inset: UIEdgeInsets(
                top: 0,
                left: value,
                bottom: 0,
                right: value
            )
        )
    }
}

extension PaddingContainerView: Touchable where Content: Touchable {

    public func touchableAreaTap(_ action: @escaping () -> Void) {
        content.touchableAreaTap(action)
    }
}
