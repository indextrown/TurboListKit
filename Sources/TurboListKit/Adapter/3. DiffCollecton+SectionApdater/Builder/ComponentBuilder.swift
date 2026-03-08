//
//  ComponentBuilder.swift
//  
//
//  Created by 김동현 on 3/8/26.
//

import Foundation

/*
 ResultBuilder
 - 여러 표현식을 하나의 값으로 합쳐주는 컴파일러 기능
 
 [ex]
 VStack {
     Text("A")
     Text("B")
     Text("C")
 }
 
 [실제]
 VStack {
     buildBlock(
         Text("A"),
         Text("B"),
         Text("C")
     )
 }
 */

@resultBuilder
public struct ComponentBuilder {
    
    /// DSL 내부의 여러 Component 표현식을 하나의 배열로 합칩니다.
    ///
    /// 기존 구현
    /// buildBlock(_ components: AnyComponent...)
    ///
    /// 하지만 ForEach DSL이 추가되면서
    /// 내부 표현식이 [AnyComponent] 형태로 전달될 수 있습니다.
    ///
    /// 예)
    /// Section {
    ///     TitleComponent(...)
    ///     ForEach(...)
    /// }
    ///
    /// 컴파일러 변환
    ///
    /// buildBlock(
    ///    [AnyComponent],   ← TitleComponent
    ///    [AnyComponent]    ← ForEach
    /// )
    ///
    /// 따라서 variadic AnyComponent 대신
    /// [AnyComponent] 배열들을 받아 하나의 배열로 합쳐야 합니다.
    ///
    /// 최종 결과
    /// [AnyComponent]
    public static func buildBlock(_ components: [AnyComponent]...) -> [AnyComponent] {
        components.flatMap { $0 }
    }
    
    /// Component 타입을 AnyComponent 배열로 변환합니다.
    ///
    /// 기존 구현
    /// buildExpression(Component) -> AnyComponent
    ///
    /// 하지만 buildBlock이 [AnyComponent] 기반으로 변경되었기 때문에
    /// 모든 표현식 결과를 동일한 타입([AnyComponent])으로 맞춰야 합니다.
    ///
    /// 예)
    /// TitleComponent(...)
    ///
    /// 컴파일러 변환
    /// buildExpression(TitleComponent)
    ///
    /// 결과
    /// [AnyComponent]
    public static func buildExpression<C: Component>(_ component: C) -> [AnyComponent] {
        [AnyComponent(base: component)]
    }

    /// 이미 AnyComponent인 경우에도
    /// Builder의 반환 타입을 통일하기 위해
    /// [AnyComponent] 형태로 변환합니다.
    ///
    /// 예)
    /// AnyComponent(...)
    ///
    /// 컴파일러 변환
    /// buildExpression(AnyComponent)
    ///
    /// 결과
    /// [AnyComponent]
    public static func buildExpression(_ component: AnyComponent) -> [AnyComponent] {
        [component]
    }

    /// if 문 지원
    ///
    /// 예)
    /// if condition {
    ///     TitleComponent(...)
    /// }
    ///
    /// nil일 경우 빈 배열 반환
    public static func buildOptional(_ component: [AnyComponent]?) -> [AnyComponent] {
        component ?? []
    }

    /// if / else 지원
    ///
    /// 예)
    /// if condition {
    ///     TitleComponent("A")
    /// } else {
    ///     TitleComponent("B")
    /// }
    public static func buildEither(first component: [AnyComponent]) -> [AnyComponent] {
        component
    }

    public static func buildEither(second component: [AnyComponent]) -> [AnyComponent] {
        component
    }

    /// for loop 지원
    ///
    /// 예)
    /// for item in items {
    ///     TitleComponent(...)
    /// }
    ///
    /// 컴파일러는 내부적으로 [[AnyComponent]] 형태를 만들기 때문에
    /// flatMap으로 1차원 배열로 변환합니다.
    public static func buildArray(_ components: [[AnyComponent]]) -> [AnyComponent] {
        components.flatMap { $0 }
    }
    
    /// ForEach DSL 지원
    ///
    /// 예)
    /// Section("List") {
    ///
    ///     ForEach(items) { item in
    ///         TitleComponent(title: item)
    ///     }
    ///
    /// }
    ///
    /// 컴파일러 변환
    /// buildExpression(ForEach(...))
    ///
    /// ForEach는 Component가 아니라
    /// 여러 Component를 생성하는 DSL Helper이기 때문에
    /// [AnyComponent]로 변환하여 Builder에 전달합니다.
    ///
    /// 변환 흐름
    ///
    /// ForEach
    /// ↓
    /// makeComponents()
    /// ↓
    /// [AnyComponent]
    ///
    /// 이후 buildBlock에서 다른 Component들과 함께 합쳐집니다.
    public static func buildExpression<Data>(
        _ forEach: For<Data>
    ) -> [AnyComponent] {
        forEach.makeComponents()
    }
    
    public static func buildExpression(_ components: [AnyComponent]) -> [AnyComponent] {
        components
    }
}
