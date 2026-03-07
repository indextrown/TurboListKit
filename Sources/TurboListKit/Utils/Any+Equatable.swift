//
//  Any+Equatable
//  TurboListKit
//
//  Created by 김동현 on 3/8/26.
//

import Foundation

/*
 [기존]
 let a: any Equatable = 10
 let b: any Equatable = 10
 a == b // ❌
 => static func == (lhs: Self, rhs: Self) -> Bool
 => Equtable의 == 연산자는 같은 타입(Self) 끼리만 비교가 가능합니다
 
 [기능]
 - 타입을 먼저 확인
 - 같으면 == 비교
 */
extension Equatable {
    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return other.isExactlyEqual(self)
        }
        return self == other
    }
    
    private func isExactlyEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}
