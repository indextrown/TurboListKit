//
//  Collection+SafeIndexTests.swift
//  TurboListKit
//
//  Created by 김동현 on 3/8/26.
//

import Testing
@testable import TurboListKit

struct Collection_SafeIndexTests {
    
    @Test("해당 인덱스에 값이 있으면 반환합니다.")
    func testExample() async throws {
        // given
        let array = [1, 2, 3]
        
        // then
        #expect(array[safe: 1] == 2)
    }
    
    @Test("해당 인덱스에 값이 없으면 nil을 반환합니다.")
    func testExample2() async throws {
        // given
        let array = [1, 2, 3]
        
        // then
        #expect(array[safe: 3] == nil)
    }
}
