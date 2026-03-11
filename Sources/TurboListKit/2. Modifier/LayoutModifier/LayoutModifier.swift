//
//  LayoutModifier.swift
//  TurboListKit
//
//  Created by 김동현 on 3/11/26.
//

/*
 [LayoutModifier]
 > Component의 레이아웃 구조(UI 구조)를 변경하는 Modifier.

 BehaviorModifier와 다르게
 CellUIView 타입이 변경될 수 있다.

 즉 새로운 Container View를 만들어
 기존 Component를 감싸는 구조를 만든다.

 예
 - Padding
 - Background
 - Overlay
 - Container
 - Border

 구조

 LayoutModifier
        ↓
     Component

 새로운 CellUIView를 생성하여 wrapped Component를 감싼다.
 */
public protocol LayoutModifier: ComponentModifier {}



/*
 /*
  [PaddingModifier]

  Component 주위에 padding(inset)을 추가하는 LayoutModifier.

  특징
  - 기존 Component를 PaddingContainerView로 감싼다
  - CellUIView 타입이 변경된다

  구조

  PaddingModifier
         ↓
  PaddingContainerView
         ↓
  wrapped Component CellUIView


  예

  TitleComponent
       ↓
  PaddingModifier
       ↓
  PaddingContainerView
       ↓
  TitleCell
 */
 */
public struct PaddingModifier<Wrapped: Component>: LayoutModifier {
    
    // 새로운 cell 타입
    public typealias CellUIView = PaddingContainerView<Wrapped.CellUIView>
    
    // 감싸는 Component
    public var wrapped: Wrapped
    
    // padding 값
    public let inset: UIEdgeInsets
    
    // 전체 셀 사이즈 계산
    // 내부 Component 사이즈 + inset
    public func size(cellSize: CGSize) -> CGSize {
        
        // 내부 Component에게 전달할 사이즈
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
    
    // PaddingContrinerView 생성
    // 내부의 weapped Component의 Cell을 넣는다
    public func createCellUIView() -> CellUIView {
        let inner = wrapped.createCellUIView()
        return PaddingContainerView(
            content: inner,
            inset: inset
        )
    }

    // 실제 렌더링은 wrapped Component에게 위임
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



import UIKit

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

/*
 [DSL API]
 TitleComponent()
    .left()
    .right()
 */

public extension Component {
    func padding(left value: CGFloat) -> PaddingModifier<Self> {
        return PaddingModifier(wrapped: self,
                               inset: UIEdgeInsets(top: 0,
                                                   left: value,
                                                   bottom: 0,
                                                   right: 0))
    }
    
    func padding(right value: CGFloat) -> PaddingModifier<Self> {
        return PaddingModifier(wrapped: self,
                               inset: UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: value))
    }
    
    func padding(v value: CGFloat) -> PaddingModifier<Self> {
        return PaddingModifier(wrapped: self,
                               inset: UIEdgeInsets(
                                top: value,
                                left: 0,
                                bottom: value,
                                right: 0))
    }
    
    func padding(h value: CGFloat) -> PaddingModifier<Self> {
        return PaddingModifier(wrapped: self,
                               inset: UIEdgeInsets(
                                top: 0,
                                left: value,
                                bottom: 0,
                                right: value))
    }
    
    func padding(t value: CGFloat) -> PaddingModifier<Self> {
        return PaddingModifier(wrapped: self,
                               inset: UIEdgeInsets(
                                top: value,
                                left: 0,
                                bottom: 0,
                                right: 0))
    }
    
    func padding(b value: CGFloat) -> PaddingModifier<Self> {
        return PaddingModifier(wrapped: self,
                               inset: UIEdgeInsets(
                                top: 0,
                                left: 0,
                                bottom: value,
                                right: 0))
    }
}

