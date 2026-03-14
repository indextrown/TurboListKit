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
    
    // MARK: - collectionView
    internal weak var collectionView: UICollectionView?
    
    // MARK: - Registered Identifiers
    private var registeredHeaderReuseIdentifiers: Set<String> = []
    private var registeredFooterReuseIdentifiers: Set<String> = []
    private var registeredCellReuseIdentifiers: Set<String> = []
    
    // MARK: - Section Data
    internal var sections: [TurboSection] = []
    
    // MARK: - Animation
    private let animated: Bool
    
    internal let emptyFooterIdentifier = "TurboEmptyFooter"
    
    public init(
        collectionView: UICollectionView,
        animated: Bool = true
    ) {
        self.collectionView = collectionView
        self.animated = animated
        super.init()

        collectionView.collectionViewLayout = makeLayout()
        collectionView.dataSource = self
        
        // empty
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: emptyFooterIdentifier
        )
    }
}

// MARK: - Public API
public extension TurboListAdapter {
    func apply(_ newSections: [TurboSection]) {
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
        // collectionView.collectionViewLayout.invalidateLayout()
    }
    
    /// ResultBuilder DSL 지원
    func apply(
        @TurboSectionBuilder _ content: () -> [TurboSection]
    ) {
        apply(content())
    }
    
    /*
    func apply(
        @AnyTurboItemBuilder _ content: () -> [AnyTurboItem]
    ) {
        let items = content()
        let  section = TurboSection(
            id: "implicit-section",
            items: items.map { $0.base }// [AnyTurboItem] -> [CellDataModel]
        )
        apply([section])
    }
     */
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

