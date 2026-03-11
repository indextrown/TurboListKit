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

    public static func buildBlock(_ components: TurboSection...) -> [TurboSection] {
        components
    }
}
