//
//  TurboListAdapter+Delegate.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import UIKit
import DifferenceKit

extension TurboListAdapter: UICollectionViewDelegateFlowLayout {
    
    /// 셀 하나의 크기 설정
    /// 레이아웃 계산은 bounds 기준이 안전함
    /// 현재는 2열 그리드 구성
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // frame은 superview 좌표 기준
        // bounds는 자기 내부 좌표 기준
        // 좌우 간격 + 셀 사이 간격 고려
        let section = sections[indexPath.section]
        let containerSize = collectionView.bounds.size
        switch section.layout {
        case .list:
            let model = sections[indexPath.section]
                .items[indexPath.item]
                .base
            if let sizable = model as? FlowSizable {
                return sizable.size(cellSize: collectionView.bounds.size)
            }
            
            // 기본값(fallback)
            return .zero
            
        case .grid(let columns):
            // width = layout 책임
            // height = component 책임
            let spacing: CGFloat = 10
            let totalSpacing = spacing * CGFloat(columns - 1)
            let width = (containerSize.width - totalSpacing) / CGFloat(columns)
            let model = section.items[indexPath.item].base
            if let sizable = model as? FlowSizable {
                let size = sizable.size(cellSize: CGSize(width: width, height: .greatestFiniteMagnitude))
                return CGSize(width: width, height: size.height)
            }

            return CGSize(width: width, height: width)
        }
    }
    
    /// header size
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout:
                               UICollectionViewLayout, referenceSizeForHeaderInSection
                               section: Int) -> CGSize {
        
        guard let model = sections[section].header?.base else {
            return .zero
        }
        
        if let sizable = model as? FlowSizable {
            return sizable.size(cellSize: collectionView.bounds.size)
        }
        
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        
        guard let model = sections[section].footer?.base else {
            return .zero
        }
        
        if let sizable = model as? FlowSizable {
            return sizable.size(cellSize: collectionView.bounds.size)
        }
        
        return .zero
    }
    
    /// 섹션 전체 여백
    /// 테두리 padding 개념
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
//    }
}

//extension TurboListAdapter: UICollectionViewDelegate {
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath
//    ) -> UISwipeActionsConfiguration? {
//
//        let item = sections[indexPath.section].items[indexPath.item].base
//        
//        guard
//            let cell = collectionView.cellForItem(at: indexPath)
//        else {
//            return nil
//        }
//        
//        for subview in cell.contentView.subviews {
//            if let swipeable = subview as? Swipeable {
//                return UISwipeActionsConfiguration(actions: swipeable.trailingSwipeActions)
//            }
//        }
//        
//        return nil
//    }
//}
