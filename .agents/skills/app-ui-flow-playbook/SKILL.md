---
name: app-ui-flow-playbook
description: Project-specific playbook for this SwiftUI app. Use when working on custom popup/alert/toast/dropdown UI, managers under Utils/Manager, or coordinator-based navigation and tab flow.
---

# App UI Flow Playbook

이 스킬은 이 프로젝트에서 이미 만든 UI 오버레이, `Manager`, `Coordinator` 패턴을 재사용할 때 쓴다. 새 구조를 임의로 만들기 전에 아래 파일과 규칙을 먼저 따른다.

## 먼저 볼 파일
- `App/Sources/ContentView.swift`
- `App/Sources/Common/UI/CustomAlert.swift`
- `App/Sources/Common/UI/CustomToast.swift`
- `App/Sources/Common/UI/CustomDropDownMenu.swift`
- `App/Sources/Utils/Extensions/CustomPopupManager.swift`
- `App/Sources/Coordinator/AppCoordinator.swift`
- `App/Sources/Coordinator/AppCoordinatorRootView.swift`
- `App/Sources/Coordinator/BottomTabBarCoordinator.swift`
- `App/Sources/Coordinator/AppRoute.swift`
- `App/Sources/Presentation/BottomTabCoordinatorView.swift`
- `App/Sources/Utils/Manager`

## UI 오버레이 규칙

### 공통 버튼 규칙
- 이 앱의 SwiftUI UI에서 탭 가능한 텍스트/아이콘/카드/커스텀 뷰는 기본적으로 `Button { } label: { }` 대신 프로젝트 확장인 `.asButton()`을 사용한다.
- 햅틱이 필요하면 `.asButton(haptic: true) { ... }`를 사용한다.
- 특수 스타일이 필요하면 `.asButton(style: SomeButtonStyle()) { ... }` 형태로 기존 `View+Extensions.swift` API를 따른다.
- 시스템 Form/List 안의 네이티브 버튼 행처럼 실제 `Button` 의미가 필요한 경우에만 예외적으로 `Button`을 쓴다.

```swift
Text("저장")
    .asButton(haptic: true) {
        save()
    }
```

### 1) 라이브러리 팝업: `PopupView`
이미 라이브러리 의존성이 있는 화면에서는 이 패턴을 우선 유지한다.

```swift
.popup(isPresented: $showPopupView) {
    customPopupView
} customize: {
    $0
        .animation(.bouncy)
        .appearFrom(.centerScale)
}
```

규칙:
- 화면 로컬 상태는 `@State`로 둔다.
- 내용 뷰는 별도 computed property 또는 서브뷰로 분리한다.
- 라이브러리 팝업을 새로 추가할 때는 `ContentView.swift`의 구성과 동일한 modifier 순서를 유지한다.

### 2) 프로젝트 커스텀 얼럿: `.customAlert`
`customAlert(isPresented:dismissOnTap:animationStyle:child:)`를 사용한다. 이 구현은 `overlay` 기반이며 백그라운드 딤과 진입/퇴장 애니메이션을 자체 처리한다.

```swift
.customAlert(isPresented: $customAlertTrigger) {
    VStack {
        Text("닫기").asButton {
            customAlertTrigger.toggle()
        }
    }
    .frame(width: 300, height: 200)
    .background(Color.red)
}
```

규칙:
- 방향성 애니메이션이 필요하면 `animationStyle: .directional(.bottom)` 같은 식으로 넘긴다.
- 바깥 탭으로 닫히면 안 되면 `dismissOnTap: false`를 준다.
- Alert 내용은 modifier 내부에 직접 길게 쓰지 말고 별도 뷰로 빼는 편이 낫다.

### 3) 프로젝트 커스텀 토스트: `.showToast`
`showToast(isPresented:position:edgePadding:dismissOnTap:autoHidden:child:)`를 사용한다.

```swift
.showToast(isPresented: $showToast, position: .bottom) {
    HStack(spacing: 8) {
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.green)
        Text("저장되었습니다")
            .foregroundStyle(.white)
    }
    .font(.system(size: 14, weight: .semibold))
    .padding(.horizontal, 14)
    .padding(.vertical, 10)
    .background(
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.black.opacity(0.85))
    )
}
```

규칙:
- 기본값은 `position: .bottom`, `autoHidden: true`다.
- 오래 남아야 하는 안내면 `autoHidden: false`로 두고 명시적으로 false 처리한다.
- toast 내용은 자체적으로 크기를 결정하게 만들고 전체 폭 고정은 피한다.

### 4) 프로젝트 커스텀 드롭다운: `.showDropDown`
`App/Sources/Common/UI/CustomDropDownMenu.swift`의 `showDropDown`을 사용한다. 트리거 위치를 기준으로 위/아래 자동 배치한다.

```swift
Text("커스톰 드롭다운 메뉴")
    .asLiquidGlassButton {
        showDropDown.toggle()
    }
    .showDropDown(isPresented: $showDropDown, triggerGap: 0) {
        customDropDownView
    }
```

규칙:
- 기본값은 `preferredDirection: .automatic`.
- 작은 액션 메뉴 용도에 맞춘다.
- 드롭다운 안 액션에서 작업이 끝나면 `isPresented = false`로 직접 닫는다.

### 5) 별도 전체화면 팝업: `.showAlert`
이 프로젝트에는 이름이 헷갈리는 두 번째 팝업 구현도 있다. `App/Sources/Utils/Extensions/CustomPopupManager.swift`의 `showAlert(isPresented:child:dismissOnTap:)`는 `fullScreenCover` 기반이다. `customAlert`와 다른 구현이므로 혼용하지 않는다.

적용 기준:
- 시스템 시트처럼 전체 화면 오버레이가 필요하면 `showAlert`
- 현재 화면 위에 가볍게 얹는 경량 오버레이면 `customAlert` 또는 `showToast`

## Manager 사용 규칙

### `HapticFeedbackManager`
파일: `App/Sources/Utils/Manager/HapticFeedbackManager.swift`

사용 방식:
- 싱글턴 `HapticFeedbackManager.shared`
- `@MainActor` 메서드만 제공
- 탭 전환, 성공/실패 피드백 같은 UI 이벤트에서만 호출

예시:

```swift
HapticFeedbackManager.shared.impact(style: .soft)
HapticFeedbackManager.shared.notificationStyle(type: .success)
```

### `CodableManager`
파일: `App/Sources/Utils/Manager/CodableManager.swift`

사용 방식:
- JSON `encode/decode`를 직접 `JSONEncoder/Decoder`로 만들지 말고 `CodableManager.shared`를 우선 쓴다.
- `Router.requestToBody(_:)`, `UserDefaultsWrapper`도 이 매니저를 사용한다.

예시:

```swift
let data = try CodableManager.shared.jsonEncoding(from: requestModel)
let dto = try CodableManager.shared.jsonDecoding(model: ResponseDTO.self, from: data)
```

### `UserDefaultsManager`
파일: `App/Sources/Utils/Manager/Storage/UserdefaultsManager.swift`

사용 방식:
- 현재 구조는 `static` 저장소 + `@UserDefaultsWrapper` 패턴이다.
- 새 값이 필요하면 `Key`에 case를 추가하고 static 프로퍼티를 같은 파일에 추가한다.

예시:

```swift
UserDefaultsManager.rootLoginUser = true
let isRoot = UserDefaultsManager.rootLoginUser
```

주의:
- 이 타입은 `actor`지만 실제 저장 프로퍼티는 static wrapper다. 기존 방식과 맞춰서 사용하고, 별도 인스턴스 생성은 하지 않는다.

### `AuthTokenStorage` / `KeyChainManager`
파일:
- `App/Sources/Utils/Manager/Storage/AuthTokenManager.swift`
- `App/Sources/Utils/Manager/Storage/KeychainManager.swift`

사용 방식:
- 인증 토큰은 `AuthTokenStorage`만 통해 접근한다.
- 일반 키체인 문자열 저장이 필요할 때만 `KeyChainManager`를 직접 건드린다.

예시:

```swift
AuthTokenStorage.accessToken = accessToken
AuthTokenStorage.refreshToken = refreshToken
AuthTokenStorage.clearAll()
```

규칙:
- 로그인 상태 정리 시 토큰 삭제는 `clearAll()`을 우선 사용한다.
- 토큰 키 이름은 `AuthTokenStorageKey` 패턴을 유지한다.

### `NetworkManager`
파일:
- `App/Sources/Utils/Manager/Network/NetworkManager.swift`
- `App/Sources/Utils/Manager/Network/Router.swift`
- `App/Sources/Utils/Manager/Network/Interceptor.swift`

핵심 구조:
- 모든 API 정의는 `Router` 채택 타입으로 만든다.
- 응답 모델은 `DTO`를 채택한다.
- 일반 요청은 `NetworkManager.shared.requestNetwork`
- 토큰 재시도 흐름이 필요하면 `requestNetworkWithRefresh`
- 바디 없는 성공/실패만 보면 되면 `requestNotDtoNetwork`
- 멀티파트는 `uplaodMultipartRequest`

예시:

```swift
let user = try await NetworkManager.shared.requestNetwork(
    dto: UserDTO.self,
    router: UserRouter.me
)
```

중요 규칙:
- `Router`에서 `baseURL`, `path`, `method`, `parameters`, `body`, `encodingType`를 정의한다.
- JSON 바디는 가능하면 `requestToBody(_:)`를 통해 만든다.
- 인증 헤더 주입은 `GBRequestInterceptor`가 처리하므로 호출부에서 직접 bearer token을 붙이지 않는다.
- `tryRefresh()`는 아직 스텁이다. 실제 refresh 로직을 넣을 때 `AuthTokenStorage` 갱신까지 한 곳에서 끝내야 한다.

### `GalleryManager`
파일: `App/Sources/Utils/Manager/Gellery/GalleryManager.swift`

사용 방식:
- `@Environment(\\.galleryManager)`로 주입받는 구조를 우선 사용한다.
- 이미지/동영상 허용 확장자 체크와 로딩을 같이 처리한다.

예시:

```swift
@Environment(\.galleryManager) private var galleryManager

let result = await galleryManager.checkMediaType(item: item)
switch result {
case .success(.image(let image)):
    break
case .success(.video(let url)):
    break
case .failure(let error):
    print(error.message)
}
```

규칙:
- 이미지 단독 검증이면 `checkImageMimeType`
- 이미지/비디오 혼합 선택이면 `checkMediaType`
- 업로드 전 압축이 필요하면 `compressImageAsync`

### `AlbumAuthManager`
파일: `App/Sources/Utils/Manager/Gellery/AlbumAuthManager.swift`

사용 방식:
- 권한 확인과 권한 요청을 분리해서 제공한다.

예시:

```swift
let manager = AlbumAuthManager()
let current = manager.currentAlbumPermission()
let requested = await manager.requestAlbumPermission()
```

규칙:
- 최초 진입 분기에는 `currentAlbumPermission()`
- 사용자 액션에 대한 실제 요청은 `requestAlbumPermission()`

### `CameraManager`
파일: `App/Sources/Utils/Manager/Gellery/CameraManager.swift`

사용 방식:
- 세션, 출력, 프리뷰 레이어를 한 인스턴스가 오래 들고 있는 구조다.
- 카메라 화면이 살아 있는 동안 같은 인스턴스를 유지한다.
- 시작 전에 delegate를 넘겨 `start(delegate:completion:)`를 호출한다.

예시 순서:
1. `let cameraManager = CameraManager()`
2. `await cameraManager.requestAuth()` 또는 `start(delegate:completion:)`
3. `cameraManager.previewLayer`를 화면에 연결
4. 사진은 `capturePhoto()`
5. 영상은 `startVideoRecording(outputURL:delegate:)`, 종료는 `stopVideoRecording()`
6. 전후면 전환은 `toggleCamera(completion:)`

규칙:
- 카메라 매니저는 뷰 `body` 안에서 매번 새로 만들지 않는다.
- 영상 녹화 전에는 세션과 `movieOutput.connection(with: .video)`가 유효한지 보장해야 한다.

## Coordinator 사용법

### 루트 구조
- 앱 시작점은 `App/Sources/AppApp.swift`
- 루트 뷰는 `App/Sources/Coordinator/AppCoordinatorRootView.swift`
- 루트 상태 소유자는 `App/Sources/Coordinator/AppCoordinator.swift`

현재 흐름:
1. `AppApp`가 `AppCoordinatorRootView()`를 띄운다.
2. `AppCoordinatorRootView`가 `@StateObject private var coordinator = AppCoordinator()`를 소유한다.
3. `NavigationStack(path: $coordinator.path)` 위에서 루트 화면을 스위칭한다.
4. 현재 루트는 `.tabs` 하나이며 `BottomTabCoordinatorView`를 렌더링한다.

### 탭 Coordinator
파일:
- `App/Sources/Coordinator/BottomTabBarCoordinator.swift`
- `App/Sources/Presentation/BottomTabCoordinatorView.swift`

역할:
- `BottomTabBarCoordinator`는 선택된 탭 상태만 관리한다.
- `BottomTabCoordinatorView`는 `TabView(selection:)`와 커스텀 탭바 UI를 렌더링한다.
- 실제 탭 전환은 `coordinator.select(_:)`로만 처리한다.

예시:

```swift
Button("Go to tab B") {
    coordinator.select(.b)
}
```

규칙:
- 하위 탭 화면은 `@ObservedObject var coordinator: BottomTabBarCoordinator`를 주입받는다.
- 탭 화면에서 직접 `TabView` 상태를 새로 만들지 않는다.
- 탭 전환 햅틱은 현재처럼 탭바 쪽에서 처리하고 개별 화면에 중복 넣지 않는다.

### Push 라우팅
파일:
- `App/Sources/Coordinator/AppRoute.swift`
- `App/Sources/Coordinator/AppCoordinatorRootView.swift`
- `App/Sources/Presentation/DemoTabView.swift`

현재 패턴:
- route enum은 `AppRoute: Hashable`
- push는 `AppCoordinator.push(_:)`
- 화면은 `navigationDestination(for: AppRoute.self)`에서 매핑
- 탭 내부 화면에는 `onPresentRoute: ((AppRoute) -> Void)?`를 주입해 상위 stack으로 push

예시:

```swift
onPresentRoute(.sampleDetail(source: title))
```

### 화면 추가 규칙

#### 새 push 화면 추가
1. `AppRoute`에 case 추가
2. `AppCoordinatorRootView`의 `navigationDestination`에 매핑 추가
3. 필요한 탭/화면에서 `onPresentRoute`를 전달받아 호출

#### 새 탭 추가
1. `BottomTabBarCoordinator.Tab`에 case 추가
2. `title`, `symbol` switch 확장
3. `BottomTabCoordinatorView.scopeView`에 새 화면과 `.tag(...)` 추가
4. 새 탭 뷰는 기존 `TabAView` 패턴처럼 coordinator 주입 구조 유지

## 작업 원칙
- 같은 역할의 새 매니저를 만들기 전에 기존 `Manager` 확장을 먼저 검토한다.
- 화면은 상태와 UI에 집중하고 저장소, 네트워크, 권한, 카메라 로직은 `Manager`로 보낸다.
- 네비게이션 상태는 View가 아니라 `Coordinator`가 소유한다.
- 토큰, UserDefaults, JSON 인코딩 로직은 호출부에서 다시 구현하지 않는다.
- 새 오버레이 UI를 만들 때는 `customAlert`, `showToast`, `showDropDown`, `PopupView`, `showAlert` 중 어떤 계층에 맞는지 먼저 고른다.

## 빠른 판단 기준
- 가벼운 중앙 오버레이: `customAlert`
- 잠깐 뜨는 상태 안내: `showToast`
- 트리거 기준 메뉴: `showDropDown`
- 라이브러리 커스텀 팝업 유지: `.popup`
- 전체 화면 덮는 팝업: `showAlert`
- 탭 변경: `BottomTabBarCoordinator`
- push 이동: `AppCoordinator` + `AppRoute`
- 토큰 저장: `AuthTokenStorage`
- 일반 로컬 설정 저장: `UserDefaultsManager`
- API 요청: `Router` + `NetworkManager`
- 앨범/카메라: `AlbumAuthManager`, `GalleryManager`, `CameraManager`
