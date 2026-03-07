//
//  File.swift
//  TurboListKit
//
//  Created by 김동현 on 3/7/26.
//

import UIKit
import DifferenceKit

public struct ComponentSection: DifferentiableSection {

    public var id: String
    public var elements: [AnyComponent]

    public init(id: String, elements: [CellDataModel]) {
        self.id = id
        self.elements = elements.map { AnyComponent(base: $0) }
    }

    public init<C>(
        source: ComponentSection,
        elements: C
    ) where C: Collection, C.Element == AnyComponent {

        self.id = source.id
        self.elements = Array(elements)
    }

    public var differenceIdentifier: String {
        id
    }

    public func isContentEqual(to source: ComponentSection) -> Bool {
        id == source.id
    }
}

final class SectionHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "SectionHeaderView"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = .boldSystemFont(ofSize: 18)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setTitle(_ title: String) {
        label.text = title
    }
}


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

    func registerCells(_ models: [CellDataModel]) {

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

    public func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        sections.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        sections[section].elements.count
    }

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

        bindableCell.bind(to: model, context: context)

        return cell
    }
    
    // section header
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

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let model = sections[indexPath.section]
            .elements[indexPath.item]
            .base

        if let sizable = model as? FlowSizable {
            return sizable.size(cellSize: collectionView.bounds.size)
        }

        return .zero
    }
    
    // section header size
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
}
