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

public enum SectionEdge {
    case top
    case bottom
    case leading
    case trailing
    case horizontal
    case vertical
}

//// padding
extension TurboSection {

    public func padding(_ value: CGFloat) -> TurboSection {
        var copy = self
        copy.inset = UIEdgeInsets(
            top: value,
            left: value,
            bottom: value,
            right: value
        )
        return copy
    }

    public func padding(_ edge: SectionEdge, _ value: CGFloat) -> TurboSection {
        var copy = self

        switch edge {
        case .top:
            copy.inset.top = value
        case .bottom:
            copy.inset.bottom = value
        case .leading:
            copy.inset.left = value
        case .trailing:
            copy.inset.right = value
        case .horizontal:
            copy.inset.left = value
            copy.inset.right = value
        case .vertical:
            copy.inset.top = value
            copy.inset.bottom = value
        }

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
