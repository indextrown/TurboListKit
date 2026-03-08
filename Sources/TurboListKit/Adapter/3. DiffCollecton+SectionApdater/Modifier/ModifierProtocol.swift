//
//  ModifierProtocol.swift
//  
//
//  Created by 김동현 on 3/8/26.
//

import Foundation

public protocol ComponentModifier: Component {
    associatedtype Wrapped: Component
    var wrapped: Wrapped { get }
}

// MARK: - Depth
extension ComponentModifier {

    func debugDepth(_ depth: Int = 0) {

        let indent = String(repeating: " ", count: depth * 2)
        
        let name = String(describing: Self.self)
                    .components(separatedBy: "<")
                    .first ?? ""

        print("\(indent)\(name)")
        // print("\(indent)\(Self.self)")
        

        // 모든 modifier를 따라감
        if let modifier = wrapped as? any ComponentModifier {
            modifier.debugDepth(depth + 1)
        } else {
            let indent = String(repeating: " ", count: (depth + 1) * 2)
            print("\(indent)\(type(of: wrapped))")
        }
    }
}
