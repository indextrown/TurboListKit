# DemoApp

`DemoApp`은 `CollectionAdapter`를 실제 화면에서 확인하기 위한 예제 앱입니다.

앱 시작 화면은 [ContentView.swift](/Users/kimdonghyeon/2025/개발/라이브러리/CollectionAdapter/Examples/DemoApp/DemoApp/ContentView.swift:1)이며, 여기서 각 `UIViewController` 예제로 이동합니다.

## 화면 구성

### `DemoViewController`

파일: [DemoViewController.swift](/Users/kimdonghyeon/2025/개발/라이브러리/CollectionAdapter/Examples/DemoApp/DemoApp/Demo/DemoViewController.swift:1)

라이브러리 기능을 한 화면에서 종합적으로 보여주는 데모입니다.

포함된 기능:

- `Component -> Cell -> Section -> List -> CollectionViewAdapter` 흐름
- 세로 리스트, 가로 카드, 그리드 섹션
- section header / footer
- `didSelect` 이벤트 처리
- `pull-to-refresh`
- `onReachEnd` 기반 추가 로딩
- diff 기반 화면 갱신

이럴 때 참고하면 좋습니다:

- 여러 섹션을 한 번에 구성하고 싶을 때
- 레이아웃을 섹션별로 다르게 주고 싶을 때
- 선택 이벤트나 로딩 이벤트를 같이 붙이고 싶을 때
- 데모용 쇼케이스 화면이 필요할 때

기본 패턴:

```swift
private let layoutAdapter = CollectionViewLayoutAdapter()

private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { [weak self] index, environment in
        self?.layoutAdapter.sectionLayout(index: index, enviroment: environment)
    }

    return UICollectionView(frame: .zero, collectionViewLayout: layout)
}()

private lazy var adapter = CollectionViewAdapter(
    configuration: .init(refreshControl: .enabled(tintColor: .systemBlue)),
    collectionView: collectionView,
    layoutAdapter: layoutAdapter
)

adapter.apply(
    List {
        // Section...
    }
)
```

### `SampleViewController`

파일: [SampleViewController.swift](/Users/kimdonghyeon/2025/개발/라이브러리/CollectionAdapter/Examples/DemoApp/DemoApp/Sample/SampleViewController.swift:1)

최소한의 세로 리스트 예제입니다. 참고용 샘플 코드를 이 프로젝트 스타일에 맞게 다시 옮긴 화면입니다.

포함된 기능:

- 단일 세로 섹션
- 자동 높이 셀
- 랜덤 더미 데이터
- `pull-to-refresh` 시 전체 재생성
- `onReachEnd` 시 페이지 단위 append
- `FlexLayout`, `PinLayout`, 매크로 없이 UIKit 오토레이아웃만 사용

관련 파일:

- [VerticalLayoutListView.swift](/Users/kimdonghyeon/2025/개발/라이브러리/CollectionAdapter/Examples/DemoApp/DemoApp/Sample/VerticalLayoutListView.swift:1)
- [VerticalLayoutItemComponent.swift](/Users/kimdonghyeon/2025/개발/라이브러리/CollectionAdapter/Examples/DemoApp/DemoApp/Sample/VerticalLayoutItemComponent.swift:1)

이럴 때 참고하면 좋습니다:

- 가장 단순한 `CollectionAdapter` 도입 예제가 필요할 때
- 셀 높이를 내용에 따라 자동 계산하고 싶을 때
- `UIViewController` 안에 리스트 하나만 빠르게 붙이고 싶을 때
- 무한 스크롤과 새로고침을 작은 예제로 보고 싶을 때

기본 패턴:

```swift
collectionViewAdapter.apply(
    List {
        Section(id: "vertical-layout-sample") {
            for viewModel in viewModels {
                Cell(
                    id: viewModel.id,
                    component: VerticalLayoutItemComponent(viewModel: viewModel)
                )
            }
        }
        .withSectionLayout(
            DefaultCompositionalLayoutSectionFactory.vertical(spacing: 0)
        )
    }
    .onRefresh { [weak self] _ in
        self?.resetViewModels()
    }
    .onReachEnd(offsetFromEnd: .relativeToContainerSize(multiplier: 1.0)) { [weak self] _ in
        self?.appendViewModels()
    }
)
```

## 진입 방식

`DemoApp`은 SwiftUI 목록에서 UIKit 화면으로 이동하는 구조입니다.

- [ContentView.swift](/Users/kimdonghyeon/2025/개발/라이브러리/CollectionAdapter/Examples/DemoApp/DemoApp/ContentView.swift:1)에서 `NavigationStack` + `List` 사용
- 각 항목은 `UIViewController.toSwiftUI()`로 감싸서 이동
- 새 예제를 추가하려면 `Destination`에 case를 추가하고 `navigationDestination`에 연결하면 됩니다

예시:

```swift
case .sample:
    UINavigationController(rootViewController: SampleViewController())
        .toSwiftUI()
        .ignoresSafeArea()
```

## 새 ViewController 추가 순서

1. `Examples/DemoApp/DemoApp` 아래에 새 `UIViewController` 파일을 만듭니다.
2. 필요하면 전용 `Component`와 `UIView`를 같은 폴더에 둡니다.
3. [ContentView.swift](/Users/kimdonghyeon/2025/개발/라이브러리/CollectionAdapter/Examples/DemoApp/DemoApp/ContentView.swift:1)의 `Destination`에 항목을 추가합니다.
4. `navigationDestination`에서 해당 `UIViewController`를 연결합니다.

## 실행

```bash
xcodebuild -project 'Examples/DemoApp/DemoApp.xcodeproj' \
  -scheme 'DemoApp' \
  -destination 'generic/platform=iOS Simulator' build
```
