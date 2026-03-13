//
//  SectionBuilder.swift
//  
//
//  Created by 김동현 on 3/12/26.
//

import Foundation

/*
 아래 코드를 turbolistadapter api에 추가해야 사용 가능합니다
 func setSections(
     @TurboSectionBuilder _ content: () -> [TurboSection]
 ) {
     setSections(content())
 }
 */
@resultBuilder
public struct TurboSectionBuilder {

    // MARK: - b1: 여러 Section을 배열로 합친다
    /// DSL 내부에서 생성된 여러 `TurboSection`을
    /// 하나의 `[TurboSection]` 배열로 합칩니다.
    ///
    /// 이 Builder는 보통 List / Adapter 레벨에서
    /// 여러 Section을 선언하는 DSL을 만들 때 사용됩니다.
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboList {
    ///     TurboSection("section1") {
    ///         NumberComponent(number: 1)
    ///     }
    ///
    ///     TurboSection("section2") {
    ///         NumberComponent(number: 2)
    ///     }
    /// }
    ///
    /// --------------------------------------------------
    /// [컴파일러 내부 변환]
    ///
    /// buildBlock(
    ///     TurboSection("section1"),
    ///     TurboSection("section2")
    /// )
    ///
    /// --------------------------------------------------
    /// [결과]
    ///
    /// [TurboSection, TurboSection]
    ///
    /// 각 Section을 배열로 묶어
    /// Adapter 또는 List에 전달합니다.
    public static func buildBlock(_ components: TurboSection...) -> [TurboSection] {
        return components
    }
}
