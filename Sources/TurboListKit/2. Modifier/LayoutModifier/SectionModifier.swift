//
//  SectionModifier.swift
//  
//
//  Created by 김동현 on 3/11/26.
//

import UIKit

// layout legacy
//extension TurboSection {
//    public func sectionLayout(_ layout: SectionLayout) -> TurboSection {
//        var copy = self
//        copy.layout = layout
//        return copy
//    }
//}

// layout
extension TurboSection {
    // .list(spacing: 10)
    public func list(spacing: CGFloat = 0) -> TurboSection {
        var copy = self
        copy.layout = .list(lineSpacing: spacing)
        return copy
    }
    
    // .grid(columns: 2, spacing: 10)
    public func grid(columns: Int, spacing: CGFloat = 0) -> TurboSection {
        var copy = self
        copy.layout = .grid(columns: columns,
                            itemSpacing: spacing,
                            lineSpacing: spacing)
        return copy
    }
    
    // .grid(columns: 2, vSpacing: 10, hSpacing: 10)
    public func grid(columns: Int, vSpacing: CGFloat, hSpacing: CGFloat) -> TurboSection {

        var copy = self
        copy.layout = .grid(
            columns: columns,
            itemSpacing: hSpacing,
            lineSpacing: vSpacing
        )
        return copy
    }
}

// header
extension TurboSection {
    // .header { HeaderComponent(title: "Header") }
    public func header(@AnyTurboItemBuilder _ content: () -> [AnyTurboItem]) -> TurboSection {
        var copy = self
        copy.header = content().first
        return copy
    }
}

// footer
extension TurboSection {
    // .footer { FooterComponent(title: "Footer") }
    public func footer(@AnyTurboItemBuilder _ content: () -> [AnyTurboItem]) -> TurboSection {
        var copy = self
        copy.footer = content().first
        return copy
    }
}

//// padding
extension TurboSection {

    // 전체 padding
    public func padding(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.inset = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        return copy
    }

    // 특정 Edge padding
    public func padding(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) -> TurboSection {
        var copy = self
        copy.inset.top = top
        copy.inset.left = left
        copy.inset.bottom = bottom
        copy.inset.right = right
        return copy
    }

    // top
    public func paddingTop(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.top = value
        return copy
    }

    // bottom
    public func paddingBottom(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.bottom = value
        return copy
    }

    // left
    public func paddingLeft(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.left = value
        return copy
    }

    // right
    public func paddingRight(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.right = value
        return copy
    }

    // horizontal
    public func paddingHorizontal(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.left = value
        copy.inset.right = value
        return copy
    }

    // vertical
    public func paddingVertical(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.top = value
        copy.inset.bottom = value
        return copy
    }
}

extension TurboSection {

    /// section 위/아래 spacing
    public func spacing(_ value: CGFloat) -> TurboSection {
        var copy = self
        // copy.spacingBefore += value
        copy.spacingAfter += value
        return copy
    }

    /// section 위 spacing
//    public func spacingBefore(_ value: CGFloat) -> TurboSection {
//        var copy = self
//        copy.spacingBefore += value
//        return copy
//    }

    /// section 아래 spacing
    public func spacingAfter(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.spacingAfter += value
        return copy
    }
}
