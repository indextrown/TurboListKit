//
//  SectionModifier.swift
//  
//
//  Created by 김동현 on 3/11/26.
//

import UIKit

// layout
extension TurboSection {
    public func sectionLayout(_ layout: SectionLayout) -> TurboSection {
        var copy = self
        copy.layout = layout
        return copy
    }
}

// header
extension TurboSection {
    public func header(@AnyTurboItemBuilder _ content: () -> [AnyTurboItem]) -> TurboSection {
        var copy = self
        copy.header = content().first
        return copy
    }
}

// footer
extension TurboSection {
    public func footer(@AnyTurboItemBuilder _ content: () -> [AnyTurboItem]) -> TurboSection {
        var copy = self
        copy.footer = content().first
        return copy
    }
}

// Padding
extension TurboSection {

    /// 섹션 전체 여백을 설정합니다.
    ///
    /// UICollectionViewFlowLayout의
    /// `sectionInset`에 대응됩니다.
    ///
    /// --------------------------------------------------
    /// [예시]
    ///
    /// TurboSection("id") {
    ///     NumberComponent(number: 1)
    /// }
    /// .padding(h: 10)
    ///
    /// --------------------------------------------------
    /// 결과
    ///
    /// |10| cell |10| cell |10|
    ///
    public func padding(_ inset: UIEdgeInsets) -> TurboSection {
        var copy = self
        copy.inset = inset
        return copy
    }

    /// 좌우 padding
    public func padding(h: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.left = h
        copy.inset.right = h
        return copy
    }

    /// 상하 padding
    public func padding(v: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.top = v
        copy.inset.bottom = v
        return copy
    }
    
    public func padding(t: CGFloat) -> TurboSection {
        var copy = self
        copy.inset.top = t
        return copy
    }
}
