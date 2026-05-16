---
name: figma-image-swiftui-mvi
description: Use when implementing SwiftUI screens from Figma files, PNG/JPG screenshots, or other image-based UI references in this project. Enforces project MVI, router, design token, layout, mock data, subview, and preview conventions.
---

# Figma/Image to SwiftUI MVI

이 스킬은 Figma 파일, PNG/JPG 스크린샷, 디자인 캡처 등 이미지 기반 UI를 이 프로젝트의 SwiftUI 코드로 구현할 때 사용한다.

## 기본 원칙

- SwiftUI + MVI 구조로 구현한다.
- 화면별 `Reducer`, `State`, `Action`, `StoreOf<FeatureReducer>` 패턴을 사용한다.
- 화면 이동은 직접 `NavigationStack`을 만들지 말고 프로젝트 `Router`/`NavRouter`/`AppRoute` 흐름을 사용한다.
- 색상과 간격은 `AppColor`, `AppSpacing` 같은 프로젝트 디자인 토큰을 우선 사용한다.
- 디자인 토큰이 아직 없으면 하드코딩을 남발하지 말고, 반복되는 값은 새 토큰 후보로 분리하거나 명확히 보고한다.
- `frame(width:height:)` 고정값 남발을 금지한다. 꼭 필요한 아이콘, 아바타, 버튼 높이 등 제한된 곳에만 사용한다.
- `ScrollView`, safe area, Dynamic Type, 작은 화면 대응을 고려한다.
- 실제 API가 없으면 mock data 기반으로 먼저 구성한다.
- 큰 화면은 작은 SubView로 분리한다.
- Preview를 반드시 포함한다.
- 이 앱의 커스텀 SwiftUI 버튼/탭/카드 액션은 `Button { } label: { }` 대신 `.asButton()`을 우선 사용한다. 햅틱은 `.asButton(haptic: true) { ... }`, 특수 스타일은 `.asButton(style: ...) { ... }`를 사용한다.

## 구현 전 확인

1. 이미지/디자인에서 화면 목적, 주요 섹션, 반복 컴포넌트, 상태를 추출한다.
2. 기존 프로젝트 패턴을 먼저 확인한다.
   - `App/Sources/Common/MVI`
   - `App/Sources/Coordinator`
   - `App/Sources/Coordinator/Routes`
   - `App/Sources/Presentation`
   - `App/Sources/Common/Const`
3. 유사한 Feature 폴더가 있으면 그 구조를 따른다.
4. 새로운 화면은 기본적으로 `Presentation/<Feature>` 아래에 둔다.
5. route가 필요하면 route 정의는 `Coordinator/Routes` 아래에 둔다.

## 파일 구성 규칙

일반적인 화면은 다음 구조를 따른다.

```text
App/Sources/Presentation/<Feature>/
├─ <Feature>Reducer.swift
├─ <Feature>View.swift
└─ <Feature>SubView.swift       // 필요할 때만
```

라우팅이 필요한 경우:

```text
App/Sources/Coordinator/Routes/
└─ <Feature>Route.swift
```

Reducer 예시:

```swift
struct FeatureReducer: Reducer {
    struct State: Equatable {
        var items: [Item] = Item.mock
    }

    enum Action: Hashable {
        case appeared
        case itemTapped(Item.ID)
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appeared:
                return .none
            case .itemTapped:
                return .none
            }
        }
    }
}
```

View 예시:

```swift
struct FeatureView: View {
    @Environment(\.navRouter) private var router

    @StateObject private var store = StoreOf<FeatureReducer>(
        initialState: FeatureReducer.State(),
        reducer: FeatureReducer()
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                content
            }
            .padding(.horizontal, AppSpacing.medium)
            .padding(.vertical, AppSpacing.large)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: AppSpacing.medium)
        }
    }
}
```

## 이미지 기반 UI 구현 체크리스트

- 디자인을 단순 픽셀 복사가 아니라 SwiftUI 레이아웃 구조로 해석한다.
- 반복되는 card/list/header/footer는 별도 SubView로 분리한다.
- 텍스트는 줄바꿈과 Dynamic Type을 고려한다.
- 긴 콘텐츠 가능성이 있으면 `ScrollView`를 사용한다.
- 하단 탭바와 겹칠 수 있는 화면은 safe area 또는 bottom padding을 고려한다.
- 버튼/탭/카드 터치 영역은 충분히 확보한다.
- 버튼/탭/카드 액션 구현은 프로젝트 `View+Extensions.swift`의 `.asButton()` 패턴을 따른다. 시스템 Form/List 행처럼 네이티브 `Button` 의미가 필요한 경우만 예외로 둔다.
- mock data는 Feature 파일 내부 또는 가까운 mock extension에 둔다.
- 이미지 asset이 필요하면 `Assets.xcassets` 이름과 `AppImages` 상수 정의 여부를 확인한다.
- 접근성 label이 필요한 이미지/버튼은 명시한다.

## 금지 사항

- 모든 요소를 절대좌표나 고정 frame으로 배치하지 않는다.
- `GeometryReader`는 가급적 사용하지 않는다. 꼭 필요하면 대체 레이아웃으로 해결할 수 없는 이유를 먼저 설명한다.
- View 하나에 모든 UI를 몰아넣지 않는다.
- 화면 내부에 독립 `NavigationStack`을 새로 만들지 않는다. 특별한 이유가 있으면 먼저 설명한다.
- Router 대신 임의 클로저를 계속 깊게 전달하지 않는다.
- 실제 API가 없는데 네트워크/스토리지 구현을 추측해서 만들지 않는다.
- Preview 없는 UI 구현을 완료로 보지 않는다.

## 검증

구현 후 반드시 확인한다.

```bash
tuist generate
xcodebuild -workspace App.xcworkspace -scheme App_Dev -destination 'generic/platform=iOS Simulator' build
```

가능하면 Preview 또는 Simulator에서 다음을 확인한다.

- 작은 화면에서 잘림 여부
- 긴 텍스트/리스트 스크롤 여부
- safe area와 바텀탭 겹침 여부
- mock data가 비어 있을 때/많을 때 레이아웃
- route 버튼이 의도한 화면으로 이동하는지
