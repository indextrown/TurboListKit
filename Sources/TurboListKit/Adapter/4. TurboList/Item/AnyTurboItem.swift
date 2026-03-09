//
//  AnyTurboItem.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import DifferenceKit

public struct AnyTurboItem: Differentiable {

    let base: any CellDataModel
    
    public init(base: any CellDataModel) {
        self.base = base
    }
    
    public var differenceIdentifier: AnyHashable {
        return AnyHashable(base)
    }

    public func isContentEqual(to source: AnyTurboItem) -> Bool {
        return AnyHashable(base) == AnyHashable(source.base)
    }
}
