//
//  File.swift
//  TurboListKit
//
//  Created by 김동현 on 3/7/26.
//
/*
 ComponentSection
  └ elements: [AnyComponent]
 
 AnyComponent
  └ base: any CellDataModel
 
 Section
  └ AnyComponent
      └ base = NumberComponent
 
 let model = sections[indexPath.section]
     .elements[indexPath.item]
     .base
 => AnyComponent -> NumberComponent
 
 AnyComponent
    ↓ .base
 NumberComponent
 */

import UIKit
import DifferenceKit

@MainActor
public final class DiffSectionCollectionViewAdapter: NSObject {

    private weak var collectionView: UICollectionView?
    private var sections: [ComponentSection] = []
    private var registeredIdentifiers: Set<String> = []
    private let animated: Bool

    public init(
        collectionView: UICollectionView,
        animated: Bool = true
    ) {
        self.collectionView = collectionView
        self.animated = animated

        super.init()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
    }

    public func setSections(_ newSections: [ComponentSection]) {

        guard let collectionView else { return }

        let models = newSections.flatMap { $0.elements.map { $0.base } }
        registerCells(models)

        if !animated {
            sections = newSections
            collectionView.reloadData()
            return
        }

        let changeset = StagedChangeset(
            source: sections,
            target: newSections
        )

        collectionView.reload(
            using: changeset,
            interrupt: { _ in false },
            setData: { [weak self] data in
                self?.sections = data
            }
        )
    }
}

private extension DiffSectionCollectionViewAdapter {

    func registerCells(_ models: [any CellDataModel]) {

        guard let collectionView else { return }

        models.forEach { model in

            let cellType = type(of: model).cellType
            let identifier = String(describing: cellType)

            guard !registeredIdentifiers.contains(identifier) else { return }

            registeredIdentifiers.insert(identifier)

            collectionView.register(
                cellType,
                forCellWithReuseIdentifier: identifier
            )
        }
    }
}

extension DiffSectionCollectionViewAdapter: UICollectionViewDataSource {

    // 필수: 각 섹션의 아이템 개수
    /// 특정 섹션에 표시할 아이템(셀)의 개수 반환
    /// 이 값만큼 cellForItemAt이 호출됨
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        sections[section].elements.count
    }

    // 필수: 셀생성
    // 실제 셀을 생성(재사용)하고 데이터 바인딩하는 메서드
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let model = sections[indexPath.section]
            .elements[indexPath.item]
            .base

        let cellType = type(of: model).cellType
        let identifier = String(describing: cellType)

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        )

        guard let bindableCell = cell as? CellDataModelBindable else {
            assertionFailure("Cell must conform to CellDataModelBindable")
            return cell
        }

        let context = Context(indexPath: indexPath)

        // bindableCell: CellDataModelBindable
        // model: CellDataModel
        bindableCell.bind(to: model, context: context)

        return cell
    }
    
    /// 섹션 개수
    public func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        sections.count
    }
    
    /// 섹션 헤더 생성
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {

            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! SectionHeaderView

            header.setTitle(sections[indexPath.section].id)

            return header
        }

        return UICollectionReusableView()
    }
}

extension DiffSectionCollectionViewAdapter: UICollectionViewDelegateFlowLayout {

    /// 셀 하나의 크기 설정
    /// 레이아웃 계산은 bounds 기준이 안전함
    /// 현재는 2열 그리드 구성
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // frame은 superview 좌표 기준
        // bounds는 자기 내부 좌표 기준
        // 좌우 간격 + 셀 사이 간격 고려
        let model = sections[indexPath.section]
            .elements[indexPath.item]
            .base

        if let sizable = model as? FlowSizable {
            return sizable.size(cellSize: collectionView.bounds.size)
        }

        return .zero
    }
    
    /// 헤더 크기 지정
    /// height가 0이면 헤더는 화면에 보이지 않는다.
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {

        CGSize(
            width: collectionView.bounds.width,
            height: 40
        )
    }
    
    /// 섹션 전체 여백
    /// 테두리 padding 개념
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
}

/*
extension DiffSectionCollectionViewAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        // print("섹션: \(indexPath.section) 아이템: \(indexPath.item)번 cell 클릭")
    }
}
*/

/*
 func setupAdapter() {

     adapter.sections {

         Section("title1") {
             TitleComponent(title: "Hello")
             TitleComponent(title: "World")
         }

         Section("title2") {
             TitleComponent(title: "A1")
         }

         Section("title3") {
             For(of: 1...5) { index in
                 TitleComponent(title: "기본")
             }
         }

     }
 }
 */
public extension DiffSectionCollectionViewAdapter {

    func sections(@SectionBuilder _ content: () -> [ComponentSection]) {
        setSections(content())
    }

}

/*
 [테스트용]
 func setupAdapter() {

     collectionView.sections(adapter: adapter) {

         Section("title1") {
             TitleComponent(title: "Hello")
         }

         Section("title2") {
             TitleComponent(title: "A1")
         }

     }

 }
 */
public extension UICollectionView {

    func sections(
        adapter: DiffSectionCollectionViewAdapter,
        @SectionBuilder _ content: () -> [ComponentSection]
    ) {
        adapter.setSections(content())
    }

}
