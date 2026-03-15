//
//  NumberCOmponent.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import TurboListKit
import UIKit

struct CellComponent: Component {

    typealias CellUIView = CellView
    let number: Int
    
    /// FlowSizable Protocol
    func size(cellSize: CGSize) -> CGSize {
        return CGSize(
            width: cellSize.width,
            height: cellSize.width
        )
    }
    
    /// Component Protocol
    /// 최초 1번 실행
    func createCellUIView() -> CellUIView {
        return CellView()
    }
    
    /// Component Protocol
    /// 매번 실행
    func render(context: Context, content: CellUIView) {
        content.setTitle(number)
        // print(context.indexPath)
    }
}

