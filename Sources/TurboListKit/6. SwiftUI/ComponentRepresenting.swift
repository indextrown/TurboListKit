//
//  ComponentRepresenting.swift
//  TurboListKit
//
//  Created by 김동현 on 3/14/26.
//

import SwiftUI

/**
 [public extension Component where Self: View]
 - Component + SwiftUI View
 - 문제: B처럼 UIView가 아닌 타입이어도 extension이 적용된다
 struct AComponent: Component, View {
     typealias CellUIView = UILabel
 }
 
 struct BComponent: Component, View {
     typealias CellUIView = SomeCustomType
 }
 
 [public extension Component where Self: View, Self.CellUIView: UIView]
 - Component + SwiftUI View + CellUIView == UIView subclass
 
 struct AComponent: Component, View {
     typealias CellUIView = UILabel
 }
 
 // 정상적으로 적용 안됨
 struct BComponent: Component, View {
     typealias CellUIView = String
 }
 
 [public extension Component where Self.CellUIView: UIView]
 - CellUIView가 UIView suclass인 Component에만 extension을 적용합니다
 - UIKit 기반 Component에만 SwiftUI Bridge 적용 가능합니다.
 */
struct ComponentRepresenting<C: Component>: UIViewRepresentable {

    let component: C
    let componentContext: Context // turboListKit Context
    
    func makeUIView(
        context: UIViewRepresentableContext<Self>
    ) -> C.CellUIView {
        component.createCellUIView()
    }
    
    func updateUIView(
        _ uiView: C.CellUIView,
        context: UIViewRepresentableContext<Self>
    ) {
        component.render(
            context: componentContext,
            content: uiView
        )
    }
}

/// SwiftUI View Wrapper
struct ComponentView<C: Component>: View {
    let component: C
    let comonentContext: Context
    var body: some View {
        ComponentRepresenting(
            component: component,
            componentContext: comonentContext
        )
        .frame(height: component.size(cellSize: .zero).height)
    }
}

/// Component를 SwiftUI View로 자동 반환
@MainActor
public extension Component where Self.CellUIView: UIView {

    var body: some View {

        ComponentView(
            component: self,
            comonentContext: Context(indexPath: .init(item: 0, section: 0))
        )
    }
}

/// SwiftUI에서 Modifier를 사용하기 위함
extension OnTouchModifier: View {}

