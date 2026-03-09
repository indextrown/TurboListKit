//
//  TurboListAdapter+DataSource.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import UIKit
import DifferenceKit

extension TurboListAdapter: UICollectionViewDataSource {
    
    // 필수: 각 섹션의 아이템 개수
    /// 특정 섹션에 표시할 아이템(셀)의 개수 반환
    /// 이 값만큼 cellForItemAt이 호출됨
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int
    ) -> Int {
        return sections[section].items.count
    }
    
    // 필수: 셀생성
    // 실제 셀을 생성(재사용)하고 데이터 바인딩하는 메서드
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let model = sections[indexPath.section]
            .items[indexPath.item]
            .base // real Component Data
        
        let cellType = type(of: model).cellType
        let identifier = String(describing: cellType)
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath)
        
        // CellDataModelBindable
        guard let bindable = cell as? CellDataModelBindable else {
            assertionFailure("Cell must conform to CellDataModelBindable")
            return cell
        }
        
        let context = Context(indexPath: indexPath)
        bindable.bind(to: model, context: context)
        
        return cell
    }
    
    // 선택
    /// 섹션 개수
    public func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
        return sections.count
    }
    
    // 선택
    /// 섹션 헤더/푸터 생성
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let section = sections[indexPath.section]
        let turboItem: AnyTurboItem?
        
        switch kind  {
        case UICollectionView.elementKindSectionHeader:
            turboItem = section.header
            
        case UICollectionView.elementKindSectionFooter:
            turboItem = section.footer
            
        default:
            return UICollectionReusableView()
        }
        
        guard let model = turboItem?.base else {
            return UICollectionReusableView()
        }
        
        let viewType = type(of: model).cellType
        let identifier = String(describing: viewType)
        
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: identifier,
            for: indexPath)
        
        if let bindable = view as? CellDataModelBindable {
            let context = Context(indexPath: indexPath)
            bindable.bind(to: model, context: context)
        }
        
        return view
    }
}
