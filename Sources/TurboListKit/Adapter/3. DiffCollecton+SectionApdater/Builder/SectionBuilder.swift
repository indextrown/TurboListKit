//
//  SectionBuilder.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import Foundation

/*
 SectionBuilder
 
 여러 Section 표현식을 하나의 배열([ComponentSection])로 합쳐주는
 ResultBuilder입니다.

 SwiftUI의 ViewBuilder와 동일한 역할을 합니다.

 --------------------------------------------------

 사용 예

 sections {

     Section("A") {
         TitleComponent(...)
     }

     Section("B") {
         TitleComponent(...)
     }

 }

 --------------------------------------------------

 컴파일러 내부 변환

 sections {

     Section("A") { ... }
     Section("B") { ... }

 }

 ↓

 sections {
     buildBlock(
         Section("A"),
         Section("B")
     )
 }

 --------------------------------------------------

 TurboListKit DSL 흐름

 Section DSL
     ↓
 SectionBuilder
     ↓
 [ComponentSection]
     ↓
 DiffSectionCollectionViewAdapter
     ↓
 UICollectionView
 */

@resultBuilder
public struct SectionBuilder {

    /// 여러 Section 표현식을 하나의 배열로 합칩니다.
    ///
    /// 예)
    /// sections {
    ///     Section("A")
    ///     Section("B")
    /// }
    ///
    /// 컴파일러 변환
    /// buildBlock(sectionA, sectionB)
    ///
    /// 결과
    /// [ComponentSection]
    public static func buildBlock(_ sections: ComponentSection...) -> [ComponentSection] {
        sections
    }

    /// Section 표현식을 그대로 반환합니다.
    ///
    /// DSL 내부에서 생성된 Section을 Builder가 처리할 수 있도록 전달합니다.
    public static func buildExpression(_ section: ComponentSection) -> ComponentSection {
        section
    }

    /// if 문 지원
    ///
    /// 예)
    /// if condition {
    ///     Section("Admin") { ... }
    /// }
    ///
    /// nil일 경우 빈 배열 반환
    public static func buildOptional(_ section: [ComponentSection]?) -> [ComponentSection] {
        section ?? []
    }

    /// if / else 지원
    ///
    /// 예)
    /// if condition {
    ///     Section("A")
    /// } else {
    ///     Section("B")
    /// }
    public static func buildEither(first section: [ComponentSection]) -> [ComponentSection] {
        section
    }

    public static func buildEither(second section: [ComponentSection]) -> [ComponentSection] {
        section
    }

    /// for loop 지원
    ///
    /// 예)
    /// for item in items {
    ///     Section(item) { ... }
    /// }
    ///
    /// 컴파일러는 내부적으로 [[ComponentSection]] 형태를 만들기 때문에
    /// flatMap으로 1차원 배열로 변환합니다.
    public static func buildArray(_ sections: [[ComponentSection]]) -> [ComponentSection] {
        sections.flatMap { $0 }
    }
}

/*
 Section alias

 ComponentSection을 SwiftUI 스타일로 사용할 수 있도록
 Section 이름을 제공하는 typealias입니다.

 사용 예

 Section("A") {
     TitleComponent(...)
 }
*/
public typealias Section = ComponentSection


/*
 sections DSL entry point

 SectionBuilder를 사용하여
 여러 Section을 선언형 DSL로 작성할 수 있게 합니다.

 사용 예

 let data = sections {

     Section("A") {
         TitleComponent(...)
     }

     Section("B") {
         TitleComponent(...)
     }

 }

 결과

 [ComponentSection]
*/
public func sections(
    @SectionBuilder content: () -> [ComponentSection]
) -> [ComponentSection] {
    content()
}


/*
 ComponentSection DSL initializer

 Section 내부에서 Component들을 선언형으로 작성할 수 있도록 합니다.

 사용 예

 Section("A") {

     TitleComponent(...)
     TitleComponent(...)

 }

 컴파일러 변환

 Section("A") {
     buildBlock(
         AnyComponent(...),
         AnyComponent(...)
     )
 }
*/
public extension ComponentSection {

    init(
        _ id: String,
        @ComponentBuilder content: () -> [AnyComponent]
    ) {
        self.id = id
        self.elements = content()
    }
}
