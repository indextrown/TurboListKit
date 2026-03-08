//
//  TurboDesignSystem.swift
//  
//
//  Created by 김동현 on 2/23/26.
//

import UIKit


@MainActor
public final class CollectionViewAdapter: NSObject {
    private weak var collectionView: UICollectionView?
    private var items: [any CellDataModel] = []
    private var registeredIdentifiers = Set<String>()
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    public func setItems(_ items: [any CellDataModel]) {
        self.items = items
        registerCells()
        collectionView?.reloadData()
    }
}

private extension CollectionViewAdapter {

    func registerCells() {

        guard let collectionView else { return }

        items.forEach { model in

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

extension CollectionViewAdapter: UICollectionViewDataSource {

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let model = items[indexPath.item]
        let cellType = type(of: model).cellType
        let identifier = String(describing: cellType)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath)
        
        let context = Context(indexPath: indexPath)
        
        /*
        (cell as? CellDataModelBindable)?
            .bind(to: model, context: context)
         */
        guard let bindableCell = cell as? CellDataModelBindable else {
            assertionFailure("Cell must conform to CellDataModelBindable")
            return cell
        }

        bindableCell.bind(to: model, context: context)
        return cell
    }
}

extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout {

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let model = items[indexPath.item]

        if let sizable = model as? FlowSizable {
            return sizable.size(cellSize: collectionView.bounds.size)
        }

        return .zero
    }
}


