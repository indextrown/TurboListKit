//
//  TurboListAdapter+Layout.swift
//  TurboListKit
//
//  Created by 김동현 on 3/13/26.
//

/*
 Section
   └ Group (행)
         └ Item (셀)
 
 [grid]
 Section
   ├ Group (row1)
   │    ├ Item
   │    ├ Item
   │    ├ Item
   │
   ├ Group (row2)
   │    ├ Item
   │    ├ Item
   │    ├ Item
 */
import UIKit

// MARK: - Section
extension TurboListAdapter {
    
    // MARK: - List
    func makeListSection(
        turboSection: TurboSection,
        lineSpacing: CGFloat,
        env: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        
        // containerWidth
        let containerWidth = env.container.effectiveContentSize.width
        
        // section inset
        let inset = turboSection.inset
        
        // 실제 content width
        let width = containerWidth - inset.left - inset.right
        
        // sizable height
        let height = sizableHeight(
            model: turboSection.items.first?.base,
            width: width,
            defaultHeight: 44
        )
        
        // ---
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = lineSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: inset.top,
            leading: inset.left,
            bottom: inset.bottom,
            trailing: inset.right
        )
        
        // TODO: - HeaderFooter
        attachHeaderFooter(
            section: section,
            turboSection: turboSection,
            width: width
        )
        return section
    }
    
    // MARK: - Grid
    func makeGridSection(
        turboSection: TurboSection,
        columns: Int,
        itemSpacing: CGFloat,
        lineSpacing: CGFloat,
        env: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        
        let containerWidth = env.container.effectiveContentSize.width
        let inset = turboSection.inset
        let totalSpacing = itemSpacing * CGFloat(columns - 1)
        let contentWidth = containerWidth - inset.left - inset.right
        let cellWidth = (contentWidth - totalSpacing) / CGFloat(columns)
        
        // sizable height
        let height = sizableHeight(
            model: turboSection.items.first?.base,
            width: cellWidth,
            defaultHeight: cellWidth
        )
        
        // ---
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: .absolute(height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: columns
        )
        group.interItemSpacing = .fixed(itemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = lineSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: inset.top,
            leading: inset.left,
            bottom: inset.bottom,
            trailing: inset.right
        )
        
        // TODO: - HeaderFooter
        attachHeaderFooter(
            section: section,
            turboSection: turboSection,
            width: contentWidth
        )
        return section
    }
}

// MARK: - Header / Footer / Spacer
extension TurboListAdapter {
    
    // MARK: - Header
    private func makeHeader(
        turboSection: TurboSection,
        width: CGFloat
    ) -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let height = sizableHeight(
            model: turboSection.header?.base,
            width: width
        )
        
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    // MARK: - Footer
    private func makeFooter(
        turboSection: TurboSection,
        width: CGFloat
    ) -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let footerHeight: CGFloat
        if turboSection.footer != nil {
            footerHeight = sizableHeight(
                model: turboSection.footer?.base,
                width: width
            )
        } else {
            footerHeight = 0
        }
        
        let totalHeight = footerHeight + turboSection.spacingAfter
        
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(totalHeight)
        )
        
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
    }

    // MARK: - Attach
    private func attachHeaderFooter(
        section: NSCollectionLayoutSection,
        turboSection: TurboSection,
        width: CGFloat
    ) {
        var boundaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        if turboSection.header != nil {
            boundaryItems.append(
                makeHeader(
                    turboSection: turboSection,
                    width: width
                )
            )
        }
        
        // footer가 있거나 spacing이 있으면 footer boundary를 만들어야 한다
        if turboSection.footer != nil || turboSection.spacingAfter > 0 { 
            boundaryItems.append(
                makeFooter(
                    turboSection: turboSection,
                    width: width
                )
            )
        }
        
        section.boundarySupplementaryItems = boundaryItems
    }
}

// MARK: - Layout
extension TurboListAdapter {
    func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self else { return nil }
            
            // MARK: - Crash 방지
            // let turboSection = self.sections[sectionIndex]
            guard let turboSection = self.sections[safe: sectionIndex] else {
                return nil
            }
            
            
            switch turboSection.layout {
            case .list(let lineSpacing):
                return self.makeListSection(
                    turboSection: turboSection,
                    lineSpacing: lineSpacing,
                    env: env
                )
            case .grid(let columns, let itemSpacing, let lineSpacing):
                return self.makeGridSection(
                    turboSection: turboSection,
                    columns: columns,
                    itemSpacing: itemSpacing,
                    lineSpacing: lineSpacing,
                    env: env
                )
            }
        }
    }
}

// MARK: - Util
extension TurboListAdapter {
    // MARK: - Height 계산 함수
    internal func sizableHeight(
        model: (any CellDataModel)?,
        width: CGFloat,
        defaultHeight: CGFloat = 44
    ) -> CGFloat {
        guard let model,
              let sizable = model as? FlowSizable else {
            return defaultHeight
        }
        
        let size = sizable.size(
            cellSize: CGSize(
                width: width,
                height: .greatestFiniteMagnitude
            )
        )
        return size.height
    }
}
