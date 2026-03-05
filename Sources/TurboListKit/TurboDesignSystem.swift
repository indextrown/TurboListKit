//
//  TurboDesignSystem.swift
//  
//
//  Created by 김동현 on 2/23/26.
//

import UIKit

/// 터치 가능 여부
protocol Touchable {
    
}

/// 버튼 존재 여부
protocol ContainsButton {
    
}

/// 셀 데이터 타입
protocol CellModel {
    
}

/// 셀 사이즈 계산 책임
protocol FlowSizable {
    
}

/// CellModel을 바인딩할 수 있는 프로토콜 셀을 실제 셀 UI에 연결해서 화면에 그려주는 작업
protocol CellModelBindable {
    @MainActor
    func bind(cellType: CellModel)
}

/// 셀 모델이면서 & 셀의 사이즈를 계산할 수 있다
class ListRowModel: CellModel, FlowSizable {
    
}

struct TitleRowModel: CellModel, FlowSizable {
    let title: String
}

final class TitleCell: UICollectionViewCell, CellModelBindable {
    
    private let titleLabel = UILabel()
    
    func bind(cellType: CellModel) {
        guard let cellModel = cellType as? TitleRowModel else { return }
        titleLabel.text = cellModel.title
    }
}
