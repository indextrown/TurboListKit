//
//  File.swift
//  TurboListKit
//
//  Created by 김동현 on 3/8/26.
//

import DifferenceKit

public struct ComponentSection: DifferentiableSection {

    public var id: String
    public var header: AnyComponent?
    public var footer: AnyComponent?
    public var elements: [AnyComponent]

    public init(id: String,
                header: (any CellDataModel)? = nil,
                footer: (any CellDataModel)? = nil,
                elements: [any CellDataModel]
    ) {
        self.id = id
        self.header = header.map { AnyComponent(base: $0) }
        self.footer = footer.map { AnyComponent(base: $0) }
        self.elements = elements.map { AnyComponent(base: $0) }
    }

    // default
    public init<C>(
        source: ComponentSection,
        elements: C
    ) where C: Collection, C.Element == AnyComponent {

        self.id = source.id
        self.header = source.header
        self.footer = source.footer
        self.elements = Array(elements)
    }
    
    // dsl
    public init(
        id: String,
        header: (any CellDataModel)? = nil,
        footer: (any CellDataModel)? = nil,
        @ComponentBuilder content: () -> [AnyComponent]
    ) {
        self.id = id
        self.header = header.map { AnyComponent(base: $0) }
        self.footer = footer.map { AnyComponent(base: $0) }
        self.elements = content()
    }

    public var differenceIdentifier: String {
        id
    }

    public func isContentEqual(to source: ComponentSection) -> Bool {
        id == source.id
    }
}
