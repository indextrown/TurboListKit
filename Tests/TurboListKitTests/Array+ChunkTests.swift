//
//  Array+ChunkTests.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import Testing
@testable import TurboListKit
import Algorithms

struct Array_ChunkTests {
    @Test("chunk")
    func testExample() async throws {
        // given
        let array = [1, 2, 3, 4, 5, 6, 7]
        
        // then
        print(array.chunked(into: 3))
        // [[1, 2, 3], [4, 5, 6], [7]]
        
        #expect(array[safe: 1] == 2)
    }

    @available(iOS 16.0, *)
    @Test("stride vs while vs algorithms benchmark")
    func benchmarkChunked() async throws {

        let array = Array(0..<1_000_000)
        let size = 50
        let iterations = 50

        // optimizer 제거 방지용
        var sink = 0

        func measure(_ name: String, block: () -> Int) {
            let start = ContinuousClock.now

            for _ in 0..<iterations {
                sink &+= block()
            }

            let duration = ContinuousClock.now - start
            print("\(name):", duration)
        }

        // stride + map
        measure("stride + map") {
            let chunks = array.chunked(into: size)
            return chunks.reduce(0) { $0 &+ $1.count }
        }

        // while loop
        measure("while loop") {
            let chunks = array.chunkedWhile(into: size)
            return chunks.reduce(0) { $0 &+ $1.count }
        }

        // algorithms lazy
        measure("algorithms lazy") {
            var sum = 0
            for chunk in array.chunks(ofCount: size) {
                sum &+= chunk.count
            }
            return sum
        }

        // optimizer 제거 방지
        print("sink:", sink)

        #expect(true)
    }
}
