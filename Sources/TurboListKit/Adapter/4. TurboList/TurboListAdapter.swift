//
//  TurboListAdapter.swift
//  
//
//  Created by 김동현 on 3/9/26.
//

import UIKit
import DifferenceKit

@MainActor
public final class TurboListAdapter: NSObject {
    
    // collectionView
    private weak var collectionView: UICollectionView?
    
    // identifier
    private var registeredHeaderReuseIdentifiers: Set<String> = []
    private var registeredFooterReuseIdentifiers: Set<String> = []
    private var registeredCellReuseIdentifiers: Set<String> = []
    
    // sections
    private var sections: [TurboSection] = []
    
    // animation
    private let animated: Bool
    
    public init(collectionView: UICollectionView,
                animated: Bool = true
    ) {
        self.collectionView = collectionView
        self.animated = animated
        super.init()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

public extension TurboListAdapter {
    func setSections(_ newSections: [TurboSection]) {
        guard let collectionView else { return }
        registerCells(in: newSections)
        
        // 애니메이션 제거
        if !animated {
            sections = newSections
            collectionView.reloadData()
            return
        }
        
        let changeset = StagedChangeset(
            source: sections,
            target: newSections)
        
        collectionView.reload(
            using: changeset,
            interrupt: { _ in false },
            setData: { [weak self] data in
                self?.sections = data
        })
    }
}

// MARK: - Register
private extension TurboListAdapter {
    private func registerCell(_ model: any CellDataModel) {
        guard let collectionView else { return }
        
        /// any CellDataModel -> TitleComponent.cellType
        let cellType = type(of: model).cellType
        let identifier = String(describing: cellType)
        
        /// already
        guard !registeredCellReuseIdentifiers
            .contains(identifier) else { return }
        
        /// register
        registeredCellReuseIdentifiers.insert(identifier)
        collectionView.register(
            cellType,
            forCellWithReuseIdentifier: identifier)
    }
    
    private func registerHeader(_ model: any CellDataModel) {
        guard let collectionView else { return }
        
        /// any CellDataModel -> TitleComponent.cellType
        let viewType = type(of: model).cellType
        let identifier = String(describing: viewType)
        
        guard !registeredHeaderReuseIdentifiers
            .contains(identifier) else { return }
        
        registeredHeaderReuseIdentifiers.insert(identifier)
        collectionView.register(
            viewType,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier)
    }
    
    private func registerFooter(_ model: any CellDataModel) {
        guard let collectionView else { return }
        
        /// any CellDataModel -> TitleComponent.cellType
        let viewType = type(of: model).cellType
        let identifier = String(describing: viewType)
        
        guard !registeredFooterReuseIdentifiers
            .contains(identifier) else { return }
        
        registeredFooterReuseIdentifiers.insert(identifier)
        collectionView.register(
            viewType,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: identifier)
    }
    
    private func registerCells(in sections: [TurboSection]) {
        
        for section in sections {

            // 만약 header가 있다면 header register
            if let header = section.header {
                registerHeader(header.base)
            }

            // 만약 footer가 있다면 footer register
            if let footer = section.footer {
                registerFooter(footer.base)
            }

            // 만약 cell이 있다면 cell register
            for item in section.items {
                registerCell(item.base)
            }
        }
    }
}

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
        let model = sections[indexPath.section]
            .items[indexPath.item]
            .base
        if let sizable = model as? FlowSizable {
            return sizable.size(cellSize: collectionView.bounds.size)
        }
        
        return .zero
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
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
}
