//
//  TurboSection.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import DifferenceKit

public enum SectionLayout {
    case list
    case grid(columns: Int)
}

public struct TurboSection: Differentiable {
    public var id: String
    public var layout: SectionLayout
    public var header: AnyTurboItem?
    public var footer: AnyTurboItem?
    public var items: [AnyTurboItem]
    
    public init(id: String,
                layout: SectionLayout = .list,
                header: (any CellDataModel)? = nil,
                footer: (any CellDataModel)? = nil,
                items: [any CellDataModel]
    ) {
        self.id = id
        self.layout = layout
        self.header = header.map { AnyTurboItem(base: $0) }
        self.footer = footer.map { AnyTurboItem(base: $0) }
        self.items = items.map { AnyTurboItem(base: $0) }
    }
    
    public init<C>(
        source: TurboSection,
        items: C
    ) where C: Collection, C.Element == AnyTurboItem {

        self.id = source.id
        self.layout = source.layout
        self.header = source.header
        self.footer = source.footer
        self.items = Array(items)
    }
    
    public var differenceIdentifier: String {
        id
    }

    public func isContentEqual(to source: TurboSection) -> Bool {
        id == source.id
    }
}
