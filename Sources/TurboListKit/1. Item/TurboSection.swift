//
//  TurboSection.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import DifferenceKit
import UIKit

public enum SectionLayout {
    case list
    case grid(columns: Int,
              itemSpacing: CGFloat = 0,
              lineSpacing: CGFloat = 0)
}

public struct TurboSection: Differentiable {
    public var id: String
    public var layout: SectionLayout
    public var header: AnyTurboItem?
    public var footer: AnyTurboItem?
    public var items: [AnyTurboItem]
    
    /// 섹션 전체 여백 (UICollectionViewFlowLayout.sectionInset)
    public var inset: UIEdgeInsets = .zero
    
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
    
    // MARK: - ResultBuilder
    public init(_ id: String,
                layout: SectionLayout = .list,
                header: AnyTurboItem? = nil,
                footer: AnyTurboItem? = nil,
                @AnyTurboItemBuilder content: () -> [AnyTurboItem]) {
        self.id = id
        self.layout = layout
        self.header = header
        self.footer = footer
        self.items = content()
    }
    
    public var differenceIdentifier: String {
        id
    }

    public func isContentEqual(to source: TurboSection) -> Bool {
        id == source.id
    }
}
