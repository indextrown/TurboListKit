//
//  ForEach.swift
//  TurboListKit
//
//  Created by 김동현 on 3/9/26.
//

import Foundation

/*
ForEach DSL Helper

Collection 데이터를 기반으로 여러 Component를 생성하기 위한 DSL 도우미입니다.
SwiftUI의 ForEach와 유사하지만 View가 아닌 Component를 생성합니다.

사용 예

Section("List") {

```
 ForEach(items) { item in
     TitleComponent(title: item)
 }
```

}

내부 동작

items
↓
map
↓
AnyComponent 배열 생성
↓
ComponentBuilder로 전달
 */

public struct For<Data: RandomAccessCollection> {
    
    /// 반복할 데이터
    let data: Data
    
    /// 데이터 → Component 생성 클로저
    let builder: (Data.Element) -> AnyComponent
    
    /// DSL initializer
    ///
    /// 예
    /// ForEach(items) { item in
    ///     TitleComponent(title: item)
    /// }
    public init<C: Component>(
        of data: Data,
        content: @escaping (Data.Element) -> C
    ) {
        self.data = data
        self.builder = { element in
            AnyComponent(base: content(element))
        }
    }
    
    /// Collection을 Component 배열로 변환
    func makeComponents() -> [AnyComponent] {
        data.map(builder)
    }
}
