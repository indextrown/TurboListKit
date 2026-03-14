//
//  TurboSection.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import DifferenceKit
import UIKit

public enum SectionLayout {
    case list(lineSpacing: CGFloat = 0)
    case grid(columns: Int,
              itemSpacing: CGFloat = 0,
              lineSpacing: CGFloat = 0)
}

public struct TurboSection: DifferentiableSection {

    public var id: String
    public var layout: SectionLayout
    public var header: AnyTurboItem?
    public var footer: AnyTurboItem?
    public var spacingAfter: CGFloat
    public var items: [AnyTurboItem]
    
    /// section 내부 padding
    public var inset: UIEdgeInsets = .zero
    
    public init(id: String,
                layout: SectionLayout = .list(),
                header: (any CellDataModel)? = nil,
                footer: (any CellDataModel)? = nil,
                spacingAfter: CGFloat = 0,
                items: [any CellDataModel]
    ) {
        self.id = id
        self.layout = layout
        self.header = header.map { AnyTurboItem(base: $0) }
        self.footer = footer.map { AnyTurboItem(base: $0) }
        self.spacingAfter = spacingAfter
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
        self.spacingAfter = source.spacingAfter
        self.items = Array(items)
    }
    
    // DifferenceKit sectioned diff 지원
    public var elements: [AnyTurboItem] {
        items
    }
    
    // DifferentiableSection
    public init<C>(
        source: TurboSection,
        elements: C
    ) where C: Collection, C.Element == AnyTurboItem {
        self.init(source: source, items: elements)
    }
    
    public init(
        _ id: String,
        layout: SectionLayout = .list(),
        header: AnyTurboItem? = nil,
        footer: AnyTurboItem? = nil,
        spacingAfter: CGFloat = 0,
        @AnyTurboItemBuilder content: () -> [AnyTurboItem]
    ) {
        self.id = id
        self.layout = layout
        self.spacingAfter = spacingAfter

        let builtItems = content()

        var resolvedHeader = header
        var resolvedFooter = footer
        var cells: [AnyTurboItem] = []

        for item in builtItems {

            let base = item.base

            if base is any HeaderComponent {
                resolvedHeader = item
            }
            else if base is any FooterComponent {
                resolvedFooter = item
            }
            else {
                cells.append(item)
            }
        }

        self.header = resolvedHeader
        self.footer = resolvedFooter
        self.items = cells
    }
    
    public var differenceIdentifier: String {
        return id
    }
    
    public func isContentEqual(to source: TurboSection) -> Bool {
         return id == source.id
    }
}




// MARK: - ResultBuilder
//    public init(_ id: String,
//                layout: SectionLayout = .list,
//                header: AnyTurboItem? = nil,
//                footer: AnyTurboItem? = nil,
//                spacingAfter: CGFloat = 0,
//                @AnyTurboItemBuilder content: () -> [AnyTurboItem]) {
//        self.id = id
//        self.layout = layout
//        self.header = header
//        self.footer = footer
//        self.spacingAfter = spacingAfter
//        self.items = content()
//    }
