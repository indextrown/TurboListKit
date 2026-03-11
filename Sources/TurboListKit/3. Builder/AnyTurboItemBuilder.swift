//
//  AnyTurboItemBuilder.swift
//  
//
//  Created by 김동현 on 3/10/26.
//

import Foundation

/*
 ResultBuilder
 - 여러 표현식을 하나의 값으로 합쳐주는 컴파일러 기능
 
 [ex]
 TurboSection {
     TextItem("A")
     TextItem("B")
     TextItem("C")
 }
 
 [컴파일러 내부 변환]
 TurboSection {
     buildBlock(
         TextItem("A"),
         TextItem("B"),
         TextItem("C")
     )
 }
 
 각 표현식은 buildExpression을 통해
 [AnyTurboItem] 형태로 변환되고
 
 buildBlock에서 하나의 배열로 합쳐집니다.
 */

@resultBuilder
public struct AnyTurboItemBuilder {
    
    /// DSL 내부의 여러 TurboItem 표현식을 하나의 배열로 합칩니다.
    ///
    /// 초기 구현에서는
    ///
    /// buildBlock(_ components: AnyTurboItem...)
    ///
    /// 형태를 사용할 수 있습니다.
    ///
    /// 하지만 DSL 확장 (ForEach, 조건문 등)이 추가되면
    /// 내부 표현식이 `[AnyTurboItem]` 형태로 전달될 수 있습니다.
    ///
    /// 예)
    ///
    /// TurboSection {
    ///     TextItem(...)
    ///
    ///     ForEach(items) { item in
    ///         TextItem(item)
    ///     }
    /// }
    ///
    /// 컴파일러 내부 변환
    ///
    /// buildBlock(
    ///     [AnyTurboItem],   ← TextItem
    ///     [AnyTurboItem]    ← ForEach
    /// )
    ///
    /// 따라서 `[AnyTurboItem]` 배열들을 받아
    /// 하나의 배열로 flatten 해야 합니다.
    ///
    /// 최종 결과
    ///
    /// [AnyTurboItem]
    public static func buildBlock(_ components: [AnyTurboItem]...) -> [AnyTurboItem] {
        return components.flatMap { $0 }
    }
}
