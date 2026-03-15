//
//  NumberCOmponent.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import TurboListKit
import UIKit
import SwiftUI

struct NumberComponent: Component {

    typealias CellUIView = NumberView
    let number: Int
    
    /// FlowSizable Protocol
    func size(cellSize: CGSize) -> CGSize {
        return CGSize(
            width: cellSize.width,
            height: 44
        )
    }
    
    /// Component Protocol
    /// 최초 1번 실행
    func createCellUIView() -> CellUIView {
        return NumberView()
    }
    
    /// Component Protocol
    /// 매번 실행
    func render(context: Context, content: CellUIView) {
        content.setTitle(number)
        content.setBackground(.green)
    }
}
//extension NumberComponent: Hashable {
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(number)
//    }
//
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.number == rhs.number
//    }
//
//}

extension NumberComponent: View {}
