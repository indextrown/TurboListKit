//
//  File.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import Foundation
import Algorithms

extension Array {
    
    // https://eunjin3786.tistory.com/424
    // https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
    public func chunked(into size: Int) -> [[Element]] {
       return stride(from: 0, to: count, by: size).map {
           Array(self[$0 ..< Swift.min($0 + size, count)])
       }
    }

    public func chunkedWhile(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }

        var result: [[Element]] = []
        result.reserveCapacity((count + size - 1) / size)

        var i = 0
        while i < count {
            let end = Swift.min(i + size, count)
            result.append(Array(self[i..<end]))
            i += size
        }

        return result
    }
    
    public func chunkedAlgorithms(into size: Int) -> [[Element]] {
        return self.chunks(ofCount: size).map { Array($0) }
    }
}


