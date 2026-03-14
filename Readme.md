
# TurboListKit

TurboListKit은 Component(Data + Render + Size) 기반으로 UICollectionView를 간편하게 구성할 수 있도록 도와주는 리스트 라이브러리입니다.
<!--TurboListKit은 Component(Data + Render + Size) 기반으로 UICollectionView를 구성하는 SwiftUI 스타일의 UIKit 리스트 라이브러리입니다.-->

# Introduction

### Problem
기존 UIKit 리스트(Collection) 구현에는 다음 복잡한 작업이 필요합니다.
- Cell 등록
- DataSource 관리
- Delegate 구현
- UI 바인딩

### Soluction
TurboListKit은 번거러운 작업을 줄이기 위해 두 가지 핵심 기능을 제공합니다.
- **UIKit에서 UICollectionview를 컴포넌트 단위로 쉽게 구성할 수 있도록 도와줍니다.**
- **동일한 Component를 SwiftUI에서 사용할 수 있도록 설계되었습니다.**

# How to use
<!-- <img src="https://github.com/user-attachments/assets/0966ba82-ca9e-4d6f-b568-39b91b222f8b" height=800 align=right> -->
<!-- <img width="493" height="943" alt="image" src="https://github.com/user-attachments/assets/78fd8745-bfbf-4663-8e1a-39fe32120563" /> -->

### DSL MVP
<img src="https://github.com/user-attachments/assets/4b529e31-c96e-4364-9288-e80e34624645" height=600 align=right>


```swift
func setupAdapter() {
    typealias Section = TurboSection
    adapter.setSections {
        
        // example 1
        Section("id2") {
            Header(title: "Header")
            
            for idx in 0..<3 {
                NumberComponent(number: idx)
                    .onTouch { print("Hello Turbo!") }
            }
            
            Footer(title: "Footer")
        }
        .list(spacing: 10)
        .padding(.horizontal, 20)
        .spacingAfter(20)
        
        // example 2
        Section("id3") {
            Header(title: "Header")
            For(of: 0..<3) { idx in
                NumberComponent(number: idx)
            }
            Footer(title: "Footer")
        }
        .grid(columns: 2, vSpacing: 10, hSpacing: 10)
        .padding(.horizontal, 20)
    }
}
```
<br/> <br/> <br/>

### SwiftUI Compatibility
<img width="600" alt="image" src="https://github.com/user-attachments/assets/3d30c423-2e0f-46b2-a9af-31b6213a7059" />

# Core Concepts
### CellDataModel
```swift
public protocol CellDataModel: Hashable {
    static var cellType: UICollectionViewCell.Type { get }
}
```
- `CellDataModel`은 CollectionView에 표시될 데이터 모델입니다.
- 이 프로토콜은 해당 모델이 어떤 `UICollectionViewCell`을 사용할지 정의합니다.
- TurboListKit에서는 `Component`가 `CellDataModel`을 채택하여 데이터와 UI를 하나의 구조로 관리합니다.

### FlowSizable
```swift
public protocol FlowSizable {
    func size(cellSize: CGSize) -> CGSize
}
```
- `FlowSizable`은 셀의 사이즈 계산을 담당하는 프로토콜입니다.
- Component가 직접 셀의 크기를 게산할 수 있도록 합니다.

### Component
```swift
// Component = Data + Render + Size
public protocol Component: CellDataModel, FlowSizable {
    associatedtype CellUIView: UIView
    func createCellUIView() -> CellUIView
    func render(context: Context, content: CellUIView)
}
```
`Component`는 TurboListKit의 핵심 개녑입니다.
`Component`는 UI를 구성하는 기본 단위로 하나의 Component는 다음 역할을 담당합니다.
- Cell에 사용할 View 생성
- 데이터 렌더링
- 셀 사이즈 계산

```swift
// Component 하나가 UICollectionViewCell 하나를 구성합니다.
struct TitleComponent: Component {

    struct CellUIView: UIView {
        let label = UILabel()
    }

    let title: String

    func createCellUIView() -> CellUIView {
        CellUIView()
    }

    func render(context: Context, content: CellUIView) {
        content.label.text = title
    }
}
```

### CellDataModelBindable
```swift
public protocol CellDataModelBindable {
    func bind(to cellDataModel: any CellDataModel, context: Context)
}
```
- `CellDataModelBindable`는 Cell의 모델을 받아 UI를 업데이트할 수 있도록 하는 프로토콜입니다.
- 이 프로토콜을 통해 `Component` -> `Cell UI`로 연결됩니다.

### ContainerCell
```swift
Component
   ↓
ContainerCell // Component를 감싸는 Weapper Cell
   ↓
UICollectionViewCell
```
`ContinerCell`은 Component를 실제 UICollectionViewCell에 연결하는 역할을 합니다.
- Component View 생성
- AutoLayout 설정
- render 호출

### Context
```swift
public struct Context {
    public let indexPath: IndexPath
}
```
- `Context`는 렌더링 시 필요한 환경 정보를 제공합니다.

## Ability Protocols
- Ability 프로토콜은 특정 기능을 지원하는 View를 정의합니다.

### Touchable
```swift
public protocol Touchable {}
```
- 터치 이벤트를 지원하는 view

### Header, Footer Component
```swift
public protocol HeaderComponent: Component {}
public protocol FooterComponent: Component {}
```
- Section Header, Footer를 표현하기 위한 타입입니다.

## Architecture
```swift
Component
   ↓
CellDataModel
   ↓
ContainerCell
   ↓
UICollectionView
```



<!--
<img src="https://github.com/user-attachments/assets/f036d5d0-57af-4ccd-bc81-a54df6daf74e" height=600 align=right>

```swift
import SwiftUI

struct TurboView: View {
    var body: some View {
        VStack {
            Text("Hello Turbo!")
            
            TitleComponent(title: "123")
                .onTouch {
                    print("Touched")
                }
                
            NumberComponent(number: 1)
                
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    TurboView()
}
```
<br/> <br/> <br/> <br/> <br/>


### UIKit MVP
<img src="https://github.com/user-attachments/assets/a5a834e0-597d-4e43-819c-eff7530ac8c1" height=600 align=right>



```swift
func setupAdapter() {
    typealias Section = TurboSection
    adapter.setSections([
        
        // example 1
        Section(
            id: "id1",
            layout: .list(lineSpacing: 10),
            header: Header(title: "Header"),
            footer: Footer(title: "Footer"),
            items: [
                NumberComponent(number: 1),
                NumberComponent(number: 2),
                NumberComponent(number: 3)
                    .onTouch { print("Touched") }       // Touchable
                ,
            ]
        ),
        
        // example 2
        Section(
            id: "id2",
            layout: .grid(columns: 3, itemSpacing: 10), // optional
            header: Header(title: "Header"),            // optional
            footer: Footer(title: "Footer"),            // optional
            items: [
                NumberComponent(number: 1),
                NumberComponent(number: 2),
                NumberComponent(number: 3),
            ]
        ),
        
        // example 3
        Section(
            id: "id3",
            layout: .grid(columns: 2, itemSpacing: 10),
            header: Header(title: "Header"),
            footer: Footer(title: "Footer"),
            items: [
                NumberComponent(number: 1)
                    .padding(.leading, 50)
                ,
                NumberComponent(number: 2)
                    .padding(.trailing, 50)
                ,
            ]
        ),
    ])
}
```
-->


