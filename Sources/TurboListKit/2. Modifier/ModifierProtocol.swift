//
//  ModifierProtocol.swift
//  TurboListKit
//
//  Created by 김동현 on 3/11/26.
//

import Foundation

// Component = Data + Render

/*
 [Component]
 > 셀을 어떻게 만들고 어떻게 그릴지 정의하는 타입
 
 Component는 하나의 "UI 단위"이다.
 즉 리스트에서 하나의 Cell을 구성하는 데이터와 렌더링 로직을 함께 가진다.
 
 역할
 - 어떤 Cell을 사용할지
 - 셀 사이즈
 - UI 생성
 - UI 렌더링
 
 
 
 [ComponentModifier]
 > 기존 Component를 감싸서 기능을 확장하는 Component.

 구조
 Modifier
    ↓
 Component

 Modifier는 내부에 다른 Component를 하나 포함하고 있으며
 wrapped Component의 동작을 기반으로 기능을 추가하거나 변경한다.

 이 패턴은 Decorator Pattern이다.
 (SwiftUI ViewModifier와 동일한 개념)
 */
public protocol ComponentModifier: Component {
    associatedtype Wrapped: Component
    var wrapped: Wrapped { get }
}

