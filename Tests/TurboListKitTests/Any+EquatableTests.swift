import Testing
@testable import TurboListKit

private protocol SomeProtocol: Equatable {
    var id: Int { get }
}

private struct SomeObject: SomeProtocol {
    let id: Int
}

struct Any_EquatableTests {
    @Test("isEqual_any_opaque_type의 값이 같으면 true")
    func isEqualTrue() {
        // given
        let object1: any SomeProtocol = SomeObject(id: 1)
        let object2: any SomeProtocol = SomeObject(id: 1)
        
        // then
        #expect(object1.isEqual(object2) == true)
    }
    
    @Test("isEqual_any_opaque_type의 값이 다르면 false")
    func isEqualFalse() async throws {
        // given
        let object1: any SomeProtocol = SomeObject(id: 1)
        let object2: any SomeProtocol = SomeObject(id: 2)
        
        // then
        #expect(object1.isEqual(object2) == false)
    }
}
