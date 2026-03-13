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
            // .greatestFiniteMagnitude // cellSize.height 추후에
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

// [Padding DSL API]
public extension Component {
    // 4 방향을 직접 지정할 수 있는 padding
    /*
     TitleComponent(title: "Hello")
         .padding(
             UIEdgeInsets(
                 top: 10,
                 left: 20,
                 bottom: 30,
                 right: 40
             )
         )
     */
    func padding(
        _ inset: UIEdgeInsets
    ) -> PaddingModifier<Self> {
        return PaddingModifier(
            wrapped: self,
            inset: inset
        )
    }
    
    // 모든 방향 동일 padding
    /*
     TitleComponent(title: "Hello")
         .padding(16)
     */
    func padding(
        _ value: CGFloat
    ) -> PaddingModifier<Self> {
        return padding(
            UIEdgeInsets(
                top: value,
                left: value,
                bottom: value,
                right: value
            )
        )
    }
    
    // v, h
    /*
     TitleComponent(title: "Hello")
         .padding(v: 10, h: 20)
     */
    func padding(
        v: CGFloat = 0,
        h: CGFloat = 0
    ) -> PaddingModifier<Self> {
        return padding(
            UIEdgeInsets(
                top: v,
                left: h,
                bottom: v,
                right: h
            )
        )
    }
}
