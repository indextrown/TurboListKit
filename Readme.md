
# TurboListKit

**TurboListKit**은 `UICollectionView`를 더 쉽게 사용하기 위한  
**Component 기반 리스트 아키텍처**입니다.

기존 UIKit 리스트 구현에서는 다음 작업이 필요합니다.

- Cell 등록
- DataSource 관리
- Delegate 구현
- UI 바인딩

TurboListKit은 이 과정을 **Component 중심 구조로 단순화**합니다.

---

# Core Idea

리스트의 각 UI 요소를 **Component**로 표현합니다.

Component는 하나의 UI 요소에 필요한 정보를 모두 포함합니다.

- 데이터
- 레이아웃 계산
- UI 렌더링

즉,

```
Component = Model + Layout + Rendering
```

---

# How to use
<img src="https://github.com/user-attachments/assets/78fd8745-bfbf-4663-8e1a-39fe32120563" height=700 align=right>
<!-- <img src="https://github.com/user-attachments/assets/0966ba82-ca9e-4d6f-b568-39b91b222f8b" height=800 align=right> -->
<!-- <img width="493" height="943" alt="image" src="https://github.com/user-attachments/assets/78fd8745-bfbf-4663-8e1a-39fe32120563" /> -->


```swift
func setupAdapter() {
    adapter.setSections([
        
        // section1
        TurboSection(
            id: "id1",
            header: HeaderComponent(title: "Header"),
            footer: FooterComponent(title: "Footer"),
            items: [
                NumberComponent(number: 1),
                NumberComponent(number: 2),
                NumberComponent(number: 3)
                    .onTouch { print("Touched") }       // Touchable
                ,
            ]
        ),
        
        // section2
        TurboSection(
            id: "id2",
            layout: .grid(columns: 3),                  // optional
            header: HeaderComponent(title: "Header"),   // optional
            footer: FooterComponent(title: "Footer"),   // optional
            items: [
                NumberComponent(number: 1),
                NumberComponent(number: 2),
                NumberComponent(number: 3),
            ]
        ),
        
        // section3
        TurboSection(
            id: "id3",
            layout: .grid(columns: 2),
            header: HeaderComponent(title: "Header"),
            footer: FooterComponent(title: "Footer"),
            items: [
                NumberComponent(number: 1)
                    .padding(left: 50)
                ,
                NumberComponent(number: 2)
                    .padding(right: 50)
                ,
            ]
        ),
    ])
}
```



<!--```swift-->
<!--import UIKit-->
<!--import TurboListKit-->
<!---->
<!--final class Diff_Section_Builder_ViewController2: UIViewController {-->
<!--    -->
<!--    let collectionView = UICollectionView(-->
<!--        scrollDirection: .vertical,-->
<!--        lineSpacing: 10,-->
<!--        interitemSpacing: 10-->
<!--    )-->
<!--    -->
<!--    lazy var adapter = DiffSectionCollectionViewAdapter(-->
<!--        collectionView: collectionView,-->
<!--        animated: true-->
<!--    )-->
<!---->
<!--    init() {-->
<!--        super.init(nibName: nil, bundle: nil)-->
<!--    }-->
<!--    -->
<!--    required init?(coder: NSCoder) {-->
<!--        fatalError("init(coder:) has not been implemented")-->
<!--    }-->
<!--    -->
<!--    override func viewDidLoad() {-->
<!--        super.viewDidLoad()-->
<!--        setupUI()-->
<!--        setupAdapter()-->
<!--    }-->
<!--    -->
<!--    private func setupUI() {-->
<!--         view.backgroundColor = .white-->
<!--         -->
<!--         view.addSubview(collectionView)-->
<!--         collectionView.translatesAutoresizingMaskIntoConstraints = false-->
<!--         -->
<!--         NSLayoutConstraint.activate([-->
<!--             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),-->
<!--             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),-->
<!--             collectionView.topAnchor.constraint(equalTo: view.topAnchor),-->
<!--             collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)-->
<!--         ])-->
<!--     }-->
<!--    -->
<!--    func setupAdapter() {-->
<!--        adapter.sections {-->
<!--            -->
<!--            // use 1-->
<!--            ComponentSection(-->
<!--                id: "title0",-->
<!--                elements: [-->
<!--                    TitleComponent(title: "기본")-->
<!--                        .onTouch {-->
<!--                            print("테스트1")-->
<!--                        }-->
<!--                ]-->
<!--            )-->
<!--            -->
<!--            // use 2-->
<!--            Section("title2") {-->
<!--                TitleComponent(title: "A1")-->
<!--                    .padding(left: 50)-->
<!--                TitleComponent(title: "A1")-->
<!--                    .padding(right: 50)-->
<!--            }-->
<!--            -->
<!--            // use 3-->
<!--            Section("title3") {-->
<!--                For(of: 0..<300) { index in-->
<!--                    TitleComponent(title: "기본: \(index)")-->
<!--                        .onTouch {-->
<!--                            print("테스트1")-->
<!--                        }-->
<!--                }-->
<!--            }-->
<!--        }-->
<!--    }-->
<!--}-->
<!--```-->

<!--
# Architecture

```
Component
   │
   ├─ Layout 계산 (FlowSizable)
   ├─ Cell 매핑 (CellDataModel)
   └─ Rendering
        │
        ▼
   ContainerCell
        │
        ▼
   UICollectionView
```

`CollectionViewAdapter`가 다음 작업을 자동으로 처리합니다.

- 셀 등록
- 셀 생성
- 데이터 바인딩
- UI 렌더링
- 셀 사이즈 계산

---

# Core Concepts

## Component

Component는 하나의 리스트 UI를 표현합니다.

역할

- UI 데이터 보관
- 셀 크기 계산
- UI 렌더링

```swift
public protocol Component: CellDataModel, FlowSizable {
    associatedtype CellUIView: UIView

    func createCellUIView() -> CellUIView
    func render(context: Context, content: CellUIView)
}
```

---

## CellDataModel

해당 모델이 어떤 `UICollectionViewCell`을 사용하는지 정의합니다.

```swift
public protocol CellDataModel {
    static var cellType: UICollectionViewCell.Type { get }
}
```

Component를 사용할 경우 자동으로

```
ContainerCell<Component>
```

가 사용됩니다.

따라서 **셀 클래스를 직접 관리할 필요가 없습니다.**

---

## FlowSizable

셀의 **크기 계산 책임**을 담당합니다.

```swift
@MainActor
public protocol FlowSizable {
    func size(cellSize: CGSize) -> CGSize
}
```

예시

```swift
func size(cellSize: CGSize) -> CGSize {
    CGSize(width: cellSize.width, height: 60)
}
```

기존 `UICollectionViewDelegateFlowLayout`을 대체합니다.

---

## ContainerCell

`ContainerCell`은 Component의 `UIView`를 담는 **제네릭 셀 컨테이너**입니다.

역할

- Component UIView 생성
- Cell에 UIView 추가
- `render()` 호출

렌더링 흐름

```
Component
   │
createCellUIView()
   │
render()
```

---

## Context

렌더링 시 필요한 정보를 제공합니다.

```swift
public struct Context {
    public let indexPath: IndexPath
}
```

예시

```swift
func render(context: Context, content: UILabel) {
    print(context.indexPath)
}
```

---

# CollectionViewAdapter

`CollectionViewAdapter`는 리스트 전체 파이프라인을 관리합니다.

역할

- 아이템 관리
- 셀 등록
- 셀 생성
- 모델 바인딩
- 셀 사이즈 계산

사용 예시

```swift
let adapter = CollectionViewAdapter(collectionView: collectionView)

adapter.setItems([
    TitleComponent(title: "Hello"),
    TitleComponent(title: "TurboListKit")
])
```

Adapter가 자동으로 다음을 처리합니다.

```
셀 등록
셀 생성
데이터 바인딩
UI 렌더링
사이즈 계산
```

---

# Example Component

```swift
struct TitleComponent: Component {

    let title: String

    func createCellUIView() -> UILabel {
        UILabel()
    }

    func render(context: Context, content: UILabel) {
        content.text = title
    }

    func size(cellSize: CGSize) -> CGSize {
        CGSize(width: cellSize.width, height: 60)
    }
}
```

사용

```swift
adapter.setItems([
    TitleComponent(title: "Hello"),
    TitleComponent(title: "TurboListKit")
])
```

---

# Installation

Swift Package Manager

```swift
.package(
    url: "https://github.com/username/TurboListKit",
    from: "1.0.0"
)
```

---
-->
