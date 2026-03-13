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
//// MARK: - Header / Footer Save
//extension TurboListAdapter {
//    // MARK: - Header Size
//    /// Section Header의 크기를 계산합니다.
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout:
//                               UICollectionViewLayout, referenceSizeForHeaderInSection
//                               section: Int) -> CGSize {
//        
//        guard let model = sections[section].header?.base else {
//            return .zero
//        }
//        
//        if let sizable = model as? FlowSizable {
//            return sizable.size(cellSize: collectionView.bounds.size)
//        }
//        
//        return .zero
//    }
//    
//    // MARK: - Footer Size
//    /// Section Footer의 크기를 계산합니다.
//    public func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               referenceSizeForFooterInSection section: Int
//    ) -> CGSize {
//        
//        guard let model = sections[section].footer?.base else {
//            return .zero
//        }
//        
//        if let sizable = model as? FlowSizable {
//            return sizable.size(cellSize: collectionView.bounds.size)
//        }
//        
//        
//        
//        return .zero
//    }
//}
//
