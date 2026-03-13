//
//  ReuseIdentifier.swift
//  
//
//  Created by 김동현 on 3/13/26.
//

import Foundation
import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
extension UICollectionReusableView: ReuseIdentifiable {}
