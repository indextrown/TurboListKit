//
//  PhotoComponent.swift
//  TurboListKit-Demo
//
//  Created by 김동현 on 3/9/26.
//

import Foundation
import TurboListKit
import UIKit
import SwiftUI

extension Header: View {}
struct Header: HeaderComponent {
    
    typealias CellUIView = HeaderView
    let title: String
    
    func size(cellSize: CGSize) -> CGSize {
        return CGSize(
            width: cellSize.width,
            height: 40
        )
    }
    
    func createCellUIView() -> HeaderView {
        return HeaderView()
    }

    func render(context: Context, content: CellUIView) {
        content.setTitle(title)
        content.setBackground(.gray)
    }
}
