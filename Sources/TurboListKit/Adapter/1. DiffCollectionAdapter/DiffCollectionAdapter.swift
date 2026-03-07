// The Swift Programming Language
// https://docs.swift.org/swift-book

import DifferenceKit
import UIKit

@MainActor
public final class DiffCollectionViewAdapter: NSObject {
    private weak var collectionView: UICollectionView?
    private var items: [AnyComponent] = []
    private var registeredIdentifiers: Set<String> = []
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
    
    public func setItems(_ models: [any CellDataModel]) {
        guard let collectionView else { return }
        let newItems = models.map { AnyComponent(base: $0) }
        registerCells(models)
        
        if !animated {
            items = newItems
            collectionView.reloadData()
        }
        
        let changeset = StagedChangeset(source: items,
                                        target: newItems)
        
        collectionView.reload(
            using: changeset,
            interrupt: { _ in false },
            setData: { [weak self] data in
                self?.items = data
            }
        )
    }
}

private extension DiffCollectionViewAdapter {
    func registerCells(_ models: [any CellDataModel]) {
        guard let collectionView else { return }
        models.forEach { model in
            let cellType = type(of: model).cellType
            let identifier = String(describing: cellType)
            guard !registeredIdentifiers.contains(identifier) else { return }
            registeredIdentifiers.insert(identifier)
            collectionView.register(cellType, forCellWithReuseIdentifier: identifier)
        }
    }
}

extension DiffCollectionViewAdapter: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let model = items[indexPath.item].base
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
}

extension DiffCollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let model = items[indexPath.item].base
        if let sizable = model as? FlowSizable {
            return sizable.size(cellSize: collectionView.bounds.size)
        }
        return .zero
    }
}
