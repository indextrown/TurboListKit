//
//  AnyTurboItemBuilder.swift
//  
//
//  Created by 김동현 on 3/10/26.
//

import Foundation

/**
 ResultBuilder
 - 여러 표현식을 하나의 값으로 합쳐주는 컴파일러 기능

 Swift DSL (SwiftUI, TurboListKit 등)에서
 여러 DSL 표현식을 하나의 결과 타입으로 변환할 때 사용됩니다.

 --------------------------------------------------
 [예시 DSL]

 TurboSection {
     TextItem("A")
     TextItem("B")
     TextItem("C")
 }

 --------------------------------------------------
 [컴파일러 내부 변환]

 TurboSection {
     buildBlock(
         buildExpression(TextItem("A")),
         buildExpression(TextItem("B")),
         buildExpression(TextItem("C"))
     )
 }

 각 표현식은 buildExpression 을 통해 [AnyTurboItem] 형태로 변환되고,
 buildBlock 에서 하나의 배열로 합쳐집니다.

 --------------------------------------------------
 최종 결과

 [AnyTurboItem]
 */

@resultBuilder
public struct AnyTurboItemBuilder {
    
    // MARK: - b1: 여러 DSL 결과를 하나의 배열로 합친다
    /// DSL 내부에서 생성된 여러 `[AnyTurboItem]` 배열을
    /// 하나의 `[AnyTurboItem]`로 합칩니다.
    ///
    /// 초기 구현에서는
    ///
    /// buildBlock(_ components: AnyTurboItem...)
    ///
    /// 형태로 구현할 수 있습니다.
    ///
    /// 하지만 DSL 확장 (For, 조건문 등)이 추가되면
    /// 내부 표현식이 `[AnyTurboItem]` 형태로 전달됩니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     NumberComponent(number: 1)
    ///
    ///     NumberComponent(number: 2)
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildBlock(
    ///     [AnyTurboItem],
    ///     [AnyTurboItem]
    /// )
    ///
    /// --------------------------------------------------
    /// [결과]
    ///
    /// [AnyTurboItem, AnyTurboItem]
    public static func buildBlock(_ components: [AnyTurboItem]...) -> [AnyTurboItem] {
        return components.flatMap { $0 }
    }
    
    // MARK: - b2: Component → AnyTurboItem
    /// `CellDataModel` 타입을 `AnyTurboItem`으로 변환합니다.
    ///
    /// DSL 내부에서 작성된 Component는
    /// Builder에 전달되기 전에 `buildExpression`을 통해 변환됩니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     NumberComponent(number: 1)
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildExpression(
    ///     NumberComponent(number: 1)
    /// )
    ///
    /// --------------------------------------------------
    /// [변환 흐름]
    ///
    /// NumberComponent
    ///        ↓
    /// AnyTurboItem(type erasure)
    ///        ↓
    /// [AnyTurboItem]
    ///
    /// 배열로 반환하는 이유는
    /// `buildBlock`의 입력 타입을 `[AnyTurboItem]`으로
    /// 통일하기 위함입니다.
    public static func buildExpression<C: CellDataModel>(_ component: C) -> [AnyTurboItem] {
        return [AnyTurboItem(base: component)]
    }
    
    // MARK: - b3: 이미 AnyTurboItem인 경우
    /// 이미 `AnyTurboItem` 타입인 표현식을 DSL에서 사용할 수 있도록 합니다.
    ///
    /// 보통 Component는
    ///
    /// CellDataModel → AnyTurboItem → [AnyTurboItem]
    ///
    /// 변환됩니다.
    ///
    /// 하지만 DSL 내부에서 이미
    /// `AnyTurboItem`을 반환하는 로직이 있을 수 있습니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     itemFactory.makeItem() // -> AnyTurboItem
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildExpression(
    ///     AnyTurboItem
    /// )
    ///
    /// --------------------------------------------------
    /// [결과]
    ///
    /// [AnyTurboItem]
    public static func buildExpression(_ component: AnyTurboItem) -> [AnyTurboItem] {
        return [component]
    }
    
    // MARK: - b4: 배열 그대로 전달 (For DSL)
    /// `[AnyTurboItem]` 배열을 그대로 Builder에 전달합니다.
    ///
    /// 이 메서드는 보통 `For DSL`이나
    /// 외부에서 생성된 Item 배열을 사용할 때 필요합니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     For(of: 0..<3) { index in
    ///         NumberComponent(number: index)
    ///     }
    /// }
    ///
    /// --------------------------------------------------
    /// For DSL 내부에서는
    ///
    /// `[AnyTurboItem]`
    ///
    /// 배열이 생성되며
    /// 이 메서드를 통해 Builder로 전달됩니다.
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildExpression(
    ///     [AnyTurboItem]
    /// )
    public static func buildExpression(_ components: [AnyTurboItem]) -> [AnyTurboItem] {
        return components
    }

    // MARK: - b5: if 문 지원
    /// DSL 내부에서 `if` 문을 사용할 수 있도록 합니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     if isLoggedIn {
    ///         ProfileComponent()
    ///     }
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildOptional(
    ///     [AnyTurboItem]?
    /// )
    ///
    /// 값이 없으면 빈 배열을 반환합니다.
    public static func buildOptional(_ component: [AnyTurboItem]?) -> [AnyTurboItem] {
        return component ?? []
    }
        
    // MARK: - b6: if / else 지원
    /// DSL 내부에서 `if / else` 문을 사용할 수 있도록 합니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     if isPremium {
    ///         PremiumComponent()
    ///     } else {
    ///         NormalComponent()
    ///     }
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildEither(first:)
    /// buildEither(second:)
    ///
    /// 둘 중 하나의 결과를 반환합니다.
    public static func buildEither(first component: [AnyTurboItem]) -> [AnyTurboItem] {
        return component
    }
    
    public static func buildEither(second component: [AnyTurboItem]) -> [AnyTurboItem] {
        return component
    }
    
    // MARK: - b7: for loop 지원
    /// DSL 내부에서 `for` loop를 사용할 수 있도록 합니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     for index in 0..<3 {
    ///         NumberComponent(number: index)
    ///     }
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildArray(
    ///     [[AnyTurboItem]]
    /// )
    ///
    /// 각 반복에서 생성된 `[AnyTurboItem]` 배열들을
    /// 하나의 배열로 flatten 합니다.
    ///
    /// --------------------------------------------------
    /// [결과]
    ///
    /// [AnyTurboItem, AnyTurboItem, AnyTurboItem]
    public static func buildArray(_ components: [[AnyTurboItem]]) -> [AnyTurboItem] {
        components.flatMap { $0 }
    }
    
    // MARK: - b8: availability 조건 지원
    /// DSL 내부에서 `if #available` 조건을 사용할 수 있도록 합니다.
    ///
    /// Swift ResultBuilder는 `if #available` 구문을 처리할 때
    /// `buildLimitedAvailability` 메서드를 호출합니다.
    ///
    /// 이 메서드가 없으면 DSL 내부에서
    /// OS 버전 조건 분기를 사용할 수 없습니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     if #available(iOS 18, *) {
    ///         NewComponent()
    ///     }
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildLimitedAvailability(
    ///     buildExpression(NewComponent())
    /// )
    ///
    /// --------------------------------------------------
    /// [결과]
    ///
    /// [AnyTurboItem]
    ///
    /// 일반적으로 별도의 가공 없이
    /// 전달된 값을 그대로 반환합니다.
    public static func buildLimitedAvailability(_ component: [AnyTurboItem]) -> [AnyTurboItem] {
        component
    }


    // MARK: - b9: Builder 최종 결과 처리
    /// ResultBuilder의 모든 단계가 끝난 후
    /// 최종 결과를 반환하기 전에 호출되는 메서드입니다.
    ///
    /// Builder 내부에서 생성된 최종 `[AnyTurboItem]` 결과를
    /// 후처리하거나 검증할 때 사용할 수 있습니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     NumberComponent(number: 1)
    ///     NumberComponent(number: 2)
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 흐름]
    ///
    /// buildExpression
    ///      ↓
    /// buildBlock
    ///      ↓
    /// buildFinalResult
    ///
    /// --------------------------------------------------
    /// [활용 예시]
    ///
    /// - DSL validation
    /// - debug logging
    /// - item count 검사
    /// - 최종 데이터 정리
    ///
    /// 현재 구현에서는
    /// 별도 가공 없이 그대로 반환합니다.
    public static func buildFinalResult(_ component: [AnyTurboItem]) -> [AnyTurboItem] {
        component
    }


    // MARK: - b10: Builder 단계별 누적 처리 (성능 최적화)
    /// ResultBuilder가 DSL을 단계적으로 누적하며
    /// 처리할 수 있도록 하는 메서드입니다.
    ///
    /// `buildBlock` 대신 사용할 수 있는
    /// incremental 방식의 Builder API입니다.
    ///
    /// DSL이 매우 커질 경우
    /// 컴파일러가 Builder 결과를
    /// 단계적으로 합치면서 성능을 개선할 수 있습니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection {
    ///     AComponent()
    ///     BComponent()
    ///     CComponent()
    /// }
    ///
    /// --------------------------------------------------
    /// [기존 buildBlock 방식]
    ///
    /// buildBlock(
    ///     [A],
    ///     [B],
    ///     [C]
    /// )
    ///
    /// --------------------------------------------------
    /// [buildPartialBlock 방식]
    ///
    /// buildPartialBlock(first: [A])
    ///
    /// buildPartialBlock(
    ///     accumulated: [A],
    ///     next: [B]
    /// )
    ///
    /// buildPartialBlock(
    ///     accumulated: [A, B],
    ///     next: [C]
    /// )
    ///
    /// --------------------------------------------------
    /// [결과]
    ///
    /// [A, B, C]
    ///
    /// DSL 규모가 커질 때
    /// Builder 성능을 개선하는 데 도움이 될 수 있습니다.
    public static func buildPartialBlock(first: [AnyTurboItem]) -> [AnyTurboItem] {
        first
    }

    public static func buildPartialBlock(
        accumulated: [AnyTurboItem],
        next: [AnyTurboItem]
    ) -> [AnyTurboItem] {
        accumulated + next
    }
    
    public static func buildExpression<Data>(_ value: For<Data>) -> [AnyTurboItem] {
        value.items
    }
}
