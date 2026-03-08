//
//  LayoutModifier.swift
//  TurboListKit
//
//  Created by 김동현 on 3/8/26.
//

import UIKit

//public protocol LayoutModifier: Componentm {
//    associatedtype Wrapped: Component
//    var wrapped: Wrapped { get }
//}

public protocol LayoutModifier: ComponentModifier {}

public final class PaddingContainerView<Content: UIView>: UIView {

    let content: Content
    let inset: UIEdgeInsets

    public init(content: Content, inset: UIEdgeInsets) {
        self.content = content
        self.inset = inset
        super.init(frame: .zero)

        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left),
            content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right),
            content.topAnchor.constraint(equalTo: topAnchor, constant: inset.top),
            content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom)
        ])
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }
}

// .padding()을 아무위치에 가능
extension PaddingContainerView: Touchable where Content: Touchable {

    public func touchableAreaTap(_ action: @escaping () -> Void) {
        content.touchableAreaTap(action)
    }
}

public struct PaddingModifier<Wrapped: Component>: LayoutModifier {

    public typealias CellUIView = PaddingContainerView<Wrapped.CellUIView>

    public let wrapped: Wrapped
    public let inset: UIEdgeInsets

    public func size(cellSize: CGSize) -> CGSize {

        let innerSize = CGSize(
            width: cellSize.width - inset.left - inset.right,
            height: cellSize.height
        )

        let inner = wrapped.size(cellSize: innerSize)

        return CGSize(
            width: inner.width + inset.left + inset.right,
            height: inner.height + inset.top + inset.bottom
        )
    }

    public func createCellUIView() -> CellUIView {
        // print("PaddingModifier wrapping:", Wrapped.self)
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






//    public func size(cellSize: CGSize) -> CGSize {
//        let inner = wrapped.size(cellSize: cellSize)
//
//        return CGSize(
//            width: inner.width,
//            height: inner.height + inset.top + inset.bottom
//        )
//    }
