//
//  BehaviorModifier.swift
//  TurboListKit
//
//  Created by 김동현 on 3/11/26.
//

import UIKit

/*
 [BehaviorModifier]

 기존 Component의 CellUIView 타입은 그대로 유지하면서
 "행동(Behavior)"만 추가하는 Modifier.

 즉 UI 구조는 변경하지 않는다.

 예
 - Tap Action
 - Highlight
 - Selection
 - Animation
 - Debug

 구조

 BehaviorModifier
        ↓
     Component

 CellUIView는 변경되지 않는다.
*/
public protocol BehaviorModifier: ComponentModifier where Wrapped.CellUIView == CellUIView {}

public struct OnTouchModifier<Wrapped: Component>: BehaviorModifier where Wrapped.CellUIView: Touchable {
    
    public typealias CellUIView = Wrapped.CellUIView
    public let wrapped: Wrapped
    public let onTouch: (CellUIView) -> Void
    
    @MainActor
    public func size(
        cellSize: CGSize
    ) -> CGSize {
        return wrapped.size(cellSize: cellSize)
    }
    
    @MainActor
    public func createCellUIView() -> CellUIView {
        return wrapped.createCellUIView()
    }
    
    @MainActor
    public func render(
        context: Context,
        content: CellUIView
    ) {
        wrapped.render(
            context: context,
            content: content
        )
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

/*
 [DSL API]
 TitleComponent()
     .onTouch {
         print("tap")
     }
 */
public extension Component where CellUIView: Touchable {
    func onTouch(_ action: @escaping (CellUIView) -> Void
    ) -> OnTouchModifier<Self> {
        return OnTouchModifier(wrapped: self,
                               onTouch: action)
    }
    
    func onTouch(_ action: @escaping () -> Void
    ) -> OnTouchModifier<Self> {
        return OnTouchModifier(wrapped: self,
                               onTouch: { _ in action() })
    }
}
