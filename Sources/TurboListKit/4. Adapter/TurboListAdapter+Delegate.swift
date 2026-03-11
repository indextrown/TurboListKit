//
//  TurboListAdapter+Delegate.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import UIKit
import DifferenceKit

extension TurboListAdapter: UICollectionViewDelegateFlowLayout {
    

    // MARK: - Cell Size
    /// 각 셀의 크기를 계산합니다.
    ///
    /// UICollectionViewFlowLayout은
    /// 각 indexPath에 대해 셀의 크기를 delegate에게 요청합니다.
    ///
    /// TurboListKit에서는
    ///
    /// - width  → Layout 책임
    /// - height → Component 책임
    ///
    /// 으로 역할을 분리합니다.
    ///
    /// --------------------------------------------------
    /// [레이아웃 구조]
    ///
    /// Section
    ///   └ Layout (list / grid)
    ///        └ Item(Component)
    ///
    /// --------------------------------------------------
    /// [계산 흐름]
    ///
    /// 1. SectionLayout 확인
    /// 2. Layout이 셀 width 계산
    /// 3. Component가 height 계산
    ///
    /// --------------------------------------------------
    /// [예시 DSL]
    ///
    /// TurboSection("id") {
    ///     NumberComponent(number: 1)
    /// }
    /// .sectionLayout(.grid(columns: 2, itemSpacing: 10, lineSpacing: 10))
    ///
    /// --------------------------------------------------
    /// [grid 계산]
    ///
    /// width =
    /// (containerWidth - totalSpacing) / columns
    ///
    /// --------------------------------------------------
    /// bounds를 사용하는 이유
    ///
    /// frame  → superview 좌표 기준
    /// bounds → 자기 내부 좌표 기준
    ///
    /// UICollectionView layout 계산은
    /// bounds 기반이 안전합니다.
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        /// 셀 하나의 크기 설정
        /// 레이아웃 계산은 bounds 기준이 안전함
        /// 현재는 2열 그리드 구성
        ///
        // frame은 superview 좌표 기준
        // bounds는 자기 내부 좌표 기준
        // 좌우 간격 + 셀 사이 간격 고려
        let section = sections[indexPath.section]
        let containerSize = collectionView.bounds.size
        switch section.layout {
        case .list:

            let inset = section.inset

            let width =
                containerSize.width
                - inset.left
                - inset.right

            let model = section.items[indexPath.item].base

            if let sizable = model as? FlowSizable {
                return sizable.size(
                    cellSize: CGSize(
                        width: width,
                        height: .greatestFiniteMagnitude
                    )
                )
            }
            
            // 기본값(fallback)
            return .zero
            
        case .grid(let columns, let itemSpacing, _):
  
            // section padding 없을떄
            // let totalSpacing = itemSpacing * CGFloat(columns - 1)
            // let width = (containerSize.width - totalSpacing) / CGFloat(columns)
            let inset = section.inset

            let totalSpacing = itemSpacing * CGFloat(columns - 1)

            let contentWidth =
                containerSize.width
                - inset.left
                - inset.right

            let width =
                (contentWidth - totalSpacing)
                / CGFloat(columns)

            let model = section.items[indexPath.item].base
            if let sizable = model as? FlowSizable {
                let size = sizable.size(
                    cellSize: CGSize(
                        width: width,
                        height: .greatestFiniteMagnitude
                    )
                )

                return CGSize(width: width, height: size.height)
            }

            return CGSize(width: width, height: width)
        }
    }
    
    // MARK: - Inter Item Spacing
    /// 같은 row 내부 셀 간격을 설정합니다.
    ///
    /// UICollectionViewFlowLayout에서
    /// row 내부 아이템 간격을 제어하는 delegate 메서드입니다.
    ///
    /// --------------------------------------------------
    /// [grid 예시]
    ///
    /// | cell | cell |
    ///
    /// cell 사이 간격 → itemSpacing
    ///
    /// --------------------------------------------------
    /// DSL
    ///
    /// .sectionLayout(
    ///     .grid(columns: 2,
    ///           itemSpacing: 10,
    ///           lineSpacing: 10)
    /// )
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {

        switch sections[section].layout {

        case .grid(_, let itemSpacing, _):
            return itemSpacing

        default:
            return 0
        }
    }
    
    // MARK: - Line Spacing
    /// row와 row 사이의 간격을 설정합니다.
    ///
    /// UICollectionViewFlowLayout에서
    /// 세로 방향(row 간격)을 제어하는 delegate 메서드입니다.
    ///
    /// --------------------------------------------------
    /// [grid 예시]
    ///
    /// | cell | cell |
    ///      ↓
    ///    lineSpacing
    ///      ↓
    /// | cell | cell |
    ///
    /// row 사이 간격 → lineSpacing
    ///
    /// --------------------------------------------------
    /// DSL
    ///
    /// .sectionLayout(
    ///     .grid(columns: 2,
    ///           itemSpacing: 10,
    ///           lineSpacing: 10)
    /// )
    ///
    /// --------------------------------------------------
    /// spacing 차이
    ///
    /// itemSpacing  → 같은 row 안 셀 사이 간격 (가로)
    /// lineSpacing  → row와 row 사이 간격 (세로)
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {

        switch sections[section].layout {

        case .grid(_, _, let lineSpacing):
            return lineSpacing

        default:
            return 0
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
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].inset
    }
}



/// 섹션 전체 여백
/// 테두리 padding 개념
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
//    }

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
