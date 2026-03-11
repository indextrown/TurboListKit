//
//  For.swift
//  
//
//  Created by 김동현 on 3/11/26.
//

import Foundation

/**
 이 DSL을 사용하려면 Builder에 추가 필요
 public static func buildExpression<Data>(_ value: For<Data>) -> [AnyTurboItem] {
     value.items
 }
 */
public struct For<Data: Sequence> {

    public let items: [AnyTurboItem]

    public init(
        of data: Data,
        @AnyTurboItemBuilder content: (Data.Element) -> [AnyTurboItem]
    ) {
        self.items = data.flatMap { content($0) }
    }
}
