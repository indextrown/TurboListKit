//
//  TitleComponent.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/6/26.
//

import TurboListKit
import UIKit
import SwiftUI

struct TitleComponent: Component {

    typealias CellUIView = TitleView
    let title: String
    
    /// FlowSizable Protocol
    func size(cellSize: CGSize) -> CGSize {
        return CGSize(
            width: cellSize.width,
            height: 80
        )
    }
    
    /// Component Protocol
    /// 최초 1번 실행
    func createCellUIView() -> CellUIView {
        return TitleView()
    }
    
    /// Component Protocol
    /// 매번 실행
    func render(context: Context, content: CellUIView) {
        content.setTitle(title)
        content.setBackground(.gray)
        // print(context.indexPath)
    }
}

extension TitleComponent: View {}
