//
//  File.swift
//  TurboListKit
//
//  Created by 김동현 on 3/8/26.
//

import DifferenceKit

public struct ComponentSection: DifferentiableSection {

    public var id: String
    public var elements: [AnyComponent]

    public init(id: String, elements: [any CellDataModel]) {
        self.id = id
        self.elements = elements.map { AnyComponent(base: $0) }
    }

    // default
    public init<C>(
        source: ComponentSection,
        elements: C
    ) where C: Collection, C.Element == AnyComponent {

        self.id = source.id
        self.elements = Array(elements)
    }
    
    // dsl
    public init(
        id: String,
        @ComponentBuilder content: () -> [AnyComponent]
    ) {
        self.id = id
        self.elements = content()
    }

    public var differenceIdentifier: String {
        id
    }

    public func isContentEqual(to source: ComponentSection) -> Bool {
        id == source.id
    }
}
