////
////  TurboListAdapter+Delegate.swift
////  TurboListKit
////
////  Created by 김동현 on 3/9/26.
////
//
//import UIKit
//import DifferenceKit
//
//// MARK: - Cell
//extension TurboListAdapter: UICollectionViewDelegateFlowLayout {
//
//    // MARK: - Cell Size
//    /// 각 셀의 크기를 계산합니다.
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//
//        let section = sections[indexPath.section]
//        
//        // UICollectionView의 현재 layout 기준 container size
//        let containerSize = collectionView.bounds.size
//        
//        switch section.layout {
//        case .list:
//
//            // Section padding 제외한 실제 content width 계산
//            let inset = section.inset
//            let width =
//                containerSize.width
//                - inset.left
//                - inset.right
//
//            let model = section.items[indexPath.item].base
//
//            // Component가 FlowSizable이면 height를 Component가 계산
//            if let sizable = model as? FlowSizable {
//                return sizable.size(
//                    cellSize: CGSize(
//                        width: width,
//                        height: .greatestFiniteMagnitude
//                    )
//                )
//            }
//            
//            // FlowSizable 미구현 시 fallback
//            return .zero
//            
//        case .grid(let columns, let itemSpacing, _):
//  
//            let inset = section.inset
//
//            /// 총 column 사이의 간격 계산
//            ///
//            /// 공식
//            /// totalSpacing = itemSpacing * (columns - 1)
//            ///
//            /// 예
//            /// columns = 3
//            /// itemSpacing = 10
//            /// totalSpacing = 10 * (3-1) = 20
//            let totalSpacing = itemSpacing * CGFloat(columns - 1)
//
//            /// Section padding을 제외한 실제 콘텐츠 영역 너비
//            ///
//            /// 공식
//            /// contentWidth = containerWidth - inset.left - inset.right
//            ///
//            /// 예
//            /// containerWidthh = 390
//            /// inset.left = 16
//            /// inset.right = 16
//            ///
//            /// contentWidth = 390 - 16 - 16 - 358
//            let contentWidth =
//                containerSize.width
//                - inset.left
//                - inset.right
//
//            /// Grid 셀 하나의 width 계산
//            /// cellWidth = (contentWidth - totapSpacing) / columns
//            let width =
//                (contentWidth - totalSpacing)
//                / CGFloat(columns)
//
//            let model = section.items[indexPath.item].base
//            
//            // Component가 FlowSizable이면 height를 Component가 계산
//            if let sizable = model as? FlowSizable {
//                let size = sizable.size(
//                    cellSize: CGSize(
//                        width: width,
//                        height: .greatestFiniteMagnitude
//                    )
//                )
//
//                return CGSize(width: width, height: size.height)
//            }
//
//            // FlowSizable 미구현 시 fallback
//            return CGSize(width: width, height: width)
//        }
//    }
//    
//    // MARK: - Inter Item Spacing(horizontal)
//    /// 같은 row 내부 셀 간격을 설정합니다.
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumInteritemSpacingForSectionAt section: Int
//    ) -> CGFloat {
//
//        switch sections[section].layout {
//
//        case .grid(_, let itemSpacing, _):
//            return itemSpacing
//
//        default:
//            return .zero
//        }
//    }
//    
//    // MARK: - Line Spacing(vertical)
//    /// row와 row 사이의 간격을 설정합니다.
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumLineSpacingForSectionAt section: Int
//    ) -> CGFloat {
//
//        switch sections[section].layout {
//
//        case .grid(_, _, let lineSpacing):
//            return lineSpacing
//
//        default:
//            return .zero
//        }
//    }
//    
//    // MARK: - Section Inset
//    /// Section의 내부 padding(inset)을 설정합니다.
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sections[section].inset
//    }
//}
