
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
<!-- <img src="https://github.com/user-attachments/assets/0966ba82-ca9e-4d6f-b568-39b91b222f8b" height=800 align=right> -->
<!-- <img width="493" height="943" alt="image" src="https://github.com/user-attachments/assets/78fd8745-bfbf-4663-8e1a-39fe32120563" /> -->

### UIKit MVP
<img src="https://github.com/user-attachments/assets/78fd8745-bfbf-4663-8e1a-39fe32120563" height=600 align=right>

```swift
func setupAdapter() {
    typealias Section = TurboSection
    adapter.setSections([
        
        // section1
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
        
        // section2
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
        
        // section3
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


### DSL MVP
<img src="https://github.com/user-attachments/assets/baa3d091-eb2e-4249-bf6c-3e3e074bd320" height=600 align=right>

```swift
func setupAdapter() {
    adapter.setSections {
        
        // example 1
        TurboSection("id2") {
            for idx in 0..<3 {
                NumberComponent(number: idx)
                    .padding(h: 20)
                    .padding(b: 10)
            }
        }
        .header { HeaderComponent(title: "Header").padding(h: 20) }
        
        

        // example 2
        TurboSection("id3") {
            For(of: 0..<3) { idx in
                NumberComponent(number: idx)
            }
        }
        .padding(h: 20)
        .header { HeaderComponent(title: "Header").padding(h: 20) }
        .footer { FooterComponent(title: "Footer").padding(h: 20) }
        .sectionLayout(.grid(columns: 2,        // 가로 셀 개수
                             itemSpacing: 10,   // 열 간격
                             lineSpacing: 10))  // 행 간격
    }
}

```

