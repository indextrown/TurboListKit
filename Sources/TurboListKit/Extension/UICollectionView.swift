//
//  UICollectionView.swift
//
//
//  Created by 김동현 on 3/6/26.
//

import UIKit

extension UICollectionView {
    public convenience init(scrollDirection: UICollectionView.ScrollDirection,
                            lineSpacing: CGFloat = 0,
                            interitemSpacing: CGFloat = 0
    ) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interitemSpacing
        self.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
}
