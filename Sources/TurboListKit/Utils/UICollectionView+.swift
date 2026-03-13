//
//  UICollectionView.swift
//
//
//  Created by 김동현 on 3/6/26.
//

import UIKit

extension UICollectionView {
    
    /// `UICollectionViewFlowLayout`이 적용된 `UICollectionView`를 생성하는 편의 초기화 메서드입니다.
    ///
    /// 스크롤 방향과 아이템 간 간격을 간단하게 설정하여 `UICollectionView`를 생성할 수 있습니다.
    /// 기본적으로 배경색은 `.clear`로 설정되며, 스크롤 인디케이터는 표시되지 않습니다.
    ///
    /// - Parameters:
    ///   - scrollDirection: 컬렉션 뷰의 스크롤 방향입니다.
    ///     `.vertical`은 세로 스크롤, `.horizontal`은 가로 스크롤을 의미합니다.
    ///   - lineSpacing: 아이템 줄(row 또는 column) 사이의 최소 간격입니다. 기본값은 `0`입니다.
    ///   - interitemSpacing: 같은 줄 안에서 아이템 사이의 최소 간격입니다. 기본값은 `0`입니다.
    ///
    /// - Note: 내부적으로 `UICollectionViewFlowLayout`을 생성하여 적용합니다.
    public convenience init(scrollDirection: UICollectionView.ScrollDirection,
                            lineSpacing: CGFloat = 0,
                            itemSpacing: CGFloat = 0
    ) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        self.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
}
