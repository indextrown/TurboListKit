# KarrotListKit 프로젝트 상세 분석

작성일: 2026-02-26
분석 대상: `/Users/kimdonghyeon/2025/개발/오픈소스공식/KarrotListKit-main`

## 1. 프로젝트 한눈에 보기

- 목적: UIKit 기반 `UICollectionView`를 선언형 모델(`List`/`Section`/`Cell`/`Component`)로 다루는 리스트 프레임워크
- 핵심 포인트:
  - `DifferenceKit` 기반 diff/batch update
  - 컴포넌트 단위 렌더링 (`AnyComponent` 타입 소거)
  - Compositional Layout 추상화 (`DefaultCompositionalLayoutSectionFactory`)
  - 이벤트 체이닝 API (`didSelect`, `willDisplay`, `onReachEnd` 등)
  - 프리페칭 플러그인 구조 (`CollectionViewPrefetchingPlugin`)
  - Swift Macro 기반 modifier 생성 (`@AddComponentModifier`)
- 코드 규모(파일 수 기준):
  - `Sources`: 62개
  - `Tests`: 12개
  - `Examples`: 11개

## 2. 패키지/의존성 구조

`Package.swift` 기준:

- tools-version: Swift 5.9
- 지원 플랫폼: iOS 13+, macOS 10.15+
- 타깃:
  - `KarrotListKit` (라이브러리 본체)
  - `KarrotListKitMacros` (Swift macro 타깃)
  - `KarrotListKitTests`
  - `KarrotListKitMacrosTests`
- 외부 의존성:
  - `DifferenceKit` (리스트 변경 diff)
  - `swift-syntax` (매크로 구현/테스트)

## 3. 핵심 아키텍처

### 3.1 선언형 표현 계층

- `List`:
  - 섹션 배열 보유
  - 스크롤/refresh/reach-end 등 리스트 레벨 이벤트 등록
- `Section`:
  - `id`, `cells`, `header`, `footer`, `sectionLayout`
  - 헤더/푸터 및 레이아웃 modifier 제공
- `Cell`:
  - `id`, `AnyComponent`
  - 셀 이벤트 등록 (`didSelect`, `willDisplay`, `onHighlight` 등)
- `SupplementaryView`:
  - 헤더/푸터용 `AnyComponent`, `kind`, `alignment`

핵심 타입 위치:
- `Sources/KarrotListKit/List.swift`
- `Sources/KarrotListKit/Section.swift`
- `Sources/KarrotListKit/Cell.swift`
- `Sources/KarrotListKit/SupplementaryView.swift`

### 3.2 Component 모델

- `Component` 프로토콜:
  - `ViewModel: Equatable`, `Content: UIView`, `Coordinator`
  - `renderContent` / `render(in:)` / `layout(content:in:)`
  - 기본 `layout`은 컨테이너에 오토레이아웃 핀 고정
- `AnyComponent`:
  - 컴포넌트 타입 소거
  - 내부 `ComponentBox`로 런타임 다형성 제공
  - `as(T.self)` 다운캐스팅 지원 (프리페칭 판단에 사용)

핵심 위치:
- `Sources/KarrotListKit/Component/Component.swift`
- `Sources/KarrotListKit/Component/AnyComponent.swift`

### 3.3 Adapter 계층 (프레임워크 핵심)

- `CollectionViewAdapter`가 `UICollectionView`의 delegate/dataSource/prefetchDataSource를 직접 소유
- `apply(_:updateStrategy:completion:)`로 목록 상태 반영
- 초기 적용 시 `reloadData`, 이후는 `DifferenceKit` staged changeset 기반 배치 업데이트
- 업데이트 도중 추가 `apply` 발생 시 `queuedUpdate`에 저장 후 순차 처리
- `registerReuseIdentifiers`로 동적 셀/헤더/푸터 등록

핵심 위치:
- `Sources/KarrotListKit/Adapter/CollectionViewAdapter.swift`
- `Sources/KarrotListKit/Extension/UICollectionView+Difference.swift`

### 3.4 레이아웃 계층

- `CollectionViewLayoutAdapter`가 `sectionProvider` 역할
- 각 `Section`의 layout closure를 실행해 `NSCollectionLayoutSection` 생성
- `DefaultCompositionalLayoutSectionFactory`:
  - vertical
  - horizontal(orthogonal scrolling)
  - verticalGrid
- `ComponentSizeStorage` 캐시를 사용해 추정치 + 실측치 혼합

핵심 위치:
- `Sources/KarrotListKit/Adapter/CollectionViewLayoutAdaptable.swift`
- `Sources/KarrotListKit/Layout/*.swift`
- `Sources/KarrotListKit/Adapter/ComponentSizeStorage.swift`

### 3.5 렌더링/사이징

- `UICollectionViewComponentCell`, `UICollectionComponentReusableView`가 `ComponentRenderable` 채택
- 최초 렌더 시:
  - coordinator 생성
  - content 생성/레이아웃
- 이후 렌더 시:
  - 기존 content에 `render(in:)`만 호출
- `preferredLayoutAttributesFitting`에서 `sizeThatFits` 계산
- 사이즈 변경 콜백을 통해 `ComponentSizeStorage` 갱신
- feature flag(`usesCachedViewSize`) 활성화 시 특정 조건에서 사이즈 재계산 스킵

핵심 위치:
- `Sources/KarrotListKit/View/ComponentRenderable.swift`
- `Sources/KarrotListKit/View/UICollectionViewComponentCell.swift`
- `Sources/KarrotListKit/View/UICollectionComponentReusableView.swift`
- `Sources/KarrotListKit/FeatureFlag/*.swift`

### 3.6 이벤트 시스템

- `ListingViewEventStorage`가 이벤트 타입 키 기반 저장
- `ListingViewEventHandler` 기본 구현으로 `registerEvent`/`event(for:)` 제공
- 범위:
  - List 레벨: scroll, drag, refresh, reach-end
  - Cell 레벨: select, display, highlight
  - Supplementary 레벨: willDisplay, didEndDisplaying

핵심 위치:
- `Sources/KarrotListKit/Event/ListingViewEventStorage.swift`
- `Sources/KarrotListKit/Event/ListingViewEventHandler.swift`
- `Sources/KarrotListKit/Event/**/*.swift`

### 3.7 프리페칭 확장

- `CollectionViewPrefetchingPlugin` 프로토콜 기반 플러그인 주입
- `RemoteImagePrefetchingPlugin`:
  - `ComponentRemoteImagePrefetchable` 컴포넌트의 URL 목록 prefetch
  - 취소 시 `AnyCancellable`로 모든 task cancel

핵심 위치:
- `Sources/KarrotListKit/Prefetching/*.swift`
- `Sources/KarrotListKit/Prefetching/Plugins/*.swift`

### 3.8 Macro

- `@AddComponentModifier`:
  - struct 내부 optional closure property에 대해 modifier 메서드 자동 생성
  - 접근제어자 자동 추론
- 예: `onTapHandler` -> `onTap(_ handler:)`

핵심 위치:
- `Sources/KarrotListKit/MacroInterface/AddComponentModifier.swift`
- `Sources/KarrotListKitMacros/AddComponentModifierMacro.swift`

## 4. 동작 플로우 상세

### 4.1 데이터 적용 플로우

1. 사용자 코드에서 `List` 생성
2. `CollectionViewAdapter.apply(list)` 호출
3. 재사용 식별자 등록 (cell/header/footer)
4. 변경 계산 (`StagedChangeset`)
5. update strategy에 따라
   - animated batch
   - non-animated batch
   - reloadData
6. datasource snapshot(`list.sections`) 갱신
7. visible 셀/보조뷰 렌더 및 이벤트 전달

### 4.2 reached-end 트리거 플로우

- `scrollViewWillEndDragging`에서 예상 오프셋으로 우선 판정
- 드래깅/트래킹 중이 아닐 때 `scrollViewDidScroll`에서도 보조 판정
- offset 기준:
  - absolute
  - relativeToContainerSize(multiplier)

### 4.3 사이즈 캐시 플로우

1. 컴포넌트 초기 layout은 추정치 기반
2. 셀 표시 중 `sizeThatFits` 실측
3. `(size, viewModel)`를 `ComponentSizeStorage`에 저장
4. 다음 레이아웃 계산 시 viewModel 동일하면 캐시값 사용

## 5. 테스트 현황

실행 일시: 2026-02-26
실행 명령: `swift test`

결과 요약:

- 전체: passed
- 실행: 19 tests
- skip: 1 test
- fail: 0

주의점:

- 상당수 UIKit 의존 테스트는 `#if canImport(UIKit)`로 묶여 있어 macOS CLI 환경에서는 실행/집계에서 제외됨
- 즉, “19개 통과”는 전체 코드베이스의 동작을 완전히 대변하지 않으며, iOS 시뮬레이터/Xcode 스킴 기준 추가 검증이 필요함

관련 테스트 파일:
- `Tests/KarrotListKitTests/CollectionViewAdapterTests.swift`
- `Tests/KarrotListKitTests/CollectionViewLayoutAdapterTests.swift`
- `Tests/KarrotListKitMacrosTests/AddComponentModifierMacroTests.swift`

## 6. 강점

- 선언형 API와 UIKit의 균형이 좋음 (SwiftUI 전환 고려)
- diff 기반 업데이트와 동적 등록으로 실사용 퍼포먼스 지향
- 이벤트 시스템이 일관된 modifier UX 제공
- 프리페칭 플러그인/feature flag로 확장 여지 존재
- 매크로로 반복되는 component modifier boilerplate 감소

## 7. 리스크 및 개선 포인트

### 7.1 Equality 설계 리스크 (`AnyComponent ==`)

- 현재 `AnyComponent` 동등성은 `viewModel`만 비교
- 잠재 이슈: 같은 viewModel을 가진 서로 다른 component 타입이 동일로 판단될 가능성
- 위치: `Sources/KarrotListKit/Component/AnyComponent.swift`

개선 제안:
- 동등성에 `reuseIdentifier` 또는 실제 타입 식별자 반영 검토

### 7.2 업데이트 큐 정책

- `CollectionViewAdapter`는 업데이트 중 추가 apply가 오면 1개(`queuedUpdate`)만 저장
- burst 상황에서 중간 상태는 의도적으로 소실 가능
- 위치: `Sources/KarrotListKit/Adapter/CollectionViewAdapter.swift`

개선 제안:
- 문서에 “last-write-wins” 정책 명시
- 필요시 배열 큐로 변경 옵션 제공

### 7.3 Reached-end 중복 트리거 가능성

- 스크롤 이벤트 흐름상 near-end 구간에서 여러 번 호출될 수 있음
- 현 구조는 호출 방지 플래그/스로틀링을 내부 제공하지 않음

개선 제안:
- 내장 debounce/throttle 옵션 또는 trigger-guard 상태 추가

### 7.4 테스트 실행 커버리지 공백

- UIKit 경로가 macOS CLI에서 빠지므로 핵심 UI 경로의 CI 보장이 약해질 수 있음

개선 제안:
- iOS 시뮬레이터 대상 테스트 job 별도 운영
- adapter/layout 이벤트 경로에 대해 UI test 혹은 host app test 보강

### 7.5 경로/파일명 위생

- `Sources/KarrotListKit/Extension/UIView+TraitCollection.swift .swift` 처럼 공백이 포함된 파일명이 존재
- 빌드는 가능해도 툴링/스크립트/자동화에서 오류 유발 여지

개선 제안:
- 파일명 정리 (`UIView+TraitCollection.swift`) 권장

## 8. 실무 적용 관점 가이드

- 이 프레임워크는 "UIKit 유지 + 선언형 작성성"이 필요한 팀에 적합
- 대규모 feed/marketplace/list 화면에서 특히 이점이 큼
- 적용 시 우선순위:
  1. `Component` 설계 규칙(뷰모델/사이즈 정책) 표준화
  2. `DefaultCompositionalLayoutSectionFactory` 조합 규칙 문서화
  3. `onReachEnd` 중복 방지 정책을 화면 단에서 강제
  4. feature flag 운영 프로세스(릴리즈/실험) 확립

## 9. 결론

KarrotListKit은 `UICollectionView` 기반 화면을 선언형/컴포넌트 중심으로 안정적으로 구성할 수 있게 해주는 프레임워크이며, diff/이벤트/레이아웃/프리페칭/매크로까지 실사용에 필요한 축이 비교적 잘 갖춰져 있습니다.

다만 대규모 서비스 적용 시에는 `AnyComponent` 동등성 기준, update queue 정책, reached-end 트리거 제어, iOS 타깃 테스트 자동화를 보완하면 안정성과 예측 가능성이 더 높아집니다.
