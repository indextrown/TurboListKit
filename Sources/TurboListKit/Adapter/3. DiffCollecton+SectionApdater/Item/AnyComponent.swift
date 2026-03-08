//
//  File.swift
//  TurboListKit
//
//  Created by 김동현 on 3/8/26.
//

import DifferenceKit

public struct AnyComponent: Differentiable {
    let base: any CellDataModel

    // MARK: - Component
    public init(base: any CellDataModel) {
        self.base = base
    }
    
    public var differenceIdentifier: AnyHashable {
        return AnyHashable(base)
    }

    public func isContentEqual(to source: AnyComponent) -> Bool {
        return AnyHashable(base) == AnyHashable(source.base)
    }
}
