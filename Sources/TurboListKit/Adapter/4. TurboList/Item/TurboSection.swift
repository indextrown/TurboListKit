//
//  TurboSection.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import DifferenceKit

public struct TurboSection: Differentiable {
    public var id: String
    public var header: AnyTurboItem?
    public var footer: AnyTurboItem?
    public var items: [AnyTurboItem]
    
    public init(id: String,
                header: AnyTurboItem? = nil,
                footer: AnyTurboItem? = nil,
                items: [AnyTurboItem]
    ) {
        self.id = id
        self.header = header
        self.footer = footer
        self.items = items
    }
    
    public init<C>(
        source: TurboSection,
        elements: C
    ) where C: Collection, C.Element == AnyTurboItem {

        self.id = source.id
        self.header = source.header
        self.footer = source.footer
        self.items = Array(elements)
    }
    
    public var differenceIdentifier: String {
        id
    }

    public func isContentEqual(to source: TurboSection) -> Bool {
        id == source.id
    }
}
