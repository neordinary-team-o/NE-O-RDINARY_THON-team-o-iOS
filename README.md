# 홍대병동 iOS

홍대병동은 사용자가 아직 널리 알려지지 않은 음악을 발굴하고, 시간이 지나며 성장률을 확인하는 SwiftUI 기반 iOS 앱입니다. 현재 앱은 튜토리얼, 홈, 검색, 발굴 시작 팝업, 발굴 완료 상세 화면을 중심으로 구성되어 있습니다.

## 기술 스택

- SwiftUI
- Tuist 4.52.0
- iOS 26.0+
- MVI 기반 상태 관리
- Alamofire 기반 네트워크 레이어
- Kingfisher 기반 원격 이미지 로딩
- PopupView 기반 팝업 UI
- SwiftyBeaver 기반 로깅
- Pretendard 폰트

## 프로젝트 구조

```text
App/
  Sources/
    AppApp.swift                  # 앱 진입점
    Common/                       # 디자인 토큰, MVI, 공통 UI
    Coordinator/                  # NavigationStack 라우팅
    Data/                         # DTO, API Router
    Entity/                       # 화면 표시용 엔티티
    Presentation/                 # Home, Search 화면
    Utils/                        # 네트워크, 저장소, 확장, 매니저
  Resources/                      # 앱 리소스
AppSettingFiles/                  # xcconfig, 공용 리소스, 폰트, PrivacyInfo
Plugins/MyPlugin/                 # Tuist helper plugin
Tuist/                            # Tuist package dependency 정의
WatchApp/                         # watch app target
WatchAppExtension/                # watch extension target
```

## 주요 기능

- 첫 진입 튜토리얼 플로우
- 내 발굴곡 목록 조회
- 발굴곡 검색
- 곡 검색 후 발굴 시작
- 발굴곡 성장률 갱신
- 발굴곡 상세 조회 및 완료 화면 표시
- 네트워크 요청/응답 로깅
- IDFV 기반 기기 사용자 ID 생성

## API 연동

기본 서버는 `https://api.neordinary-o.r-e.kr`입니다.

현재 앱에서 사용하는 엔드포인트는 다음과 같습니다.

| 기능 | Method | Endpoint |
| --- | --- | --- |
| 곡 검색 | `POST` | `/api/songs/search` |
| 발굴 생성 | `POST` | `/api/digs` |
| 내 발굴 목록 | `GET` | `/api/digs` |
| 내 발굴 검색 | `GET` | `/api/digs/me/search` |
| 발굴 상세 | `GET` | `/api/digs/{digId}` |
| 성장률 갱신 | `PATCH` | `/api/digs/{digId}/growth-rate` |

Auth 계열 엔드포인트는 현재 앱 흐름에 포함되어 있지 않습니다.

## 시작하기

### 1. 도구 설치

이 프로젝트는 `mise`로 Tuist 버전을 고정합니다.

```bash
mise install
```

### 2. 프로젝트 생성

```bash
mise exec -- tuist generate
```

### 3. Xcode 실행

생성된 `App.xcworkspace`를 열고 `App_Dev` 또는 `App_Prod` scheme을 선택합니다.

```bash
open App.xcworkspace
```

## 빌드 확인

시뮬레이터 실행 없이 컴파일만 확인하려면 다음 명령을 사용합니다.

```bash
xcodebuild -quiet \
  -workspace App.xcworkspace \
  -scheme App_Dev \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## 아키텍처

화면은 `State`, `Action`, `Reducer`, `Effect`, `Store`를 중심으로 동작합니다.

- `View`: 사용자 입력을 `Action`으로 변환하고 상태를 렌더링합니다.
- `Reducer`: 액션에 따라 상태를 변경하고 필요한 비동기 `Effect`를 반환합니다.
- `Effect`: API 호출 같은 비동기 작업을 실행한 뒤 후속 액션을 보냅니다.
- `Store`: 상태를 보관하고 Reducer/Effect 실행을 관리합니다.

라우팅은 `AppCoordinator`, `AppRoute`, `HomeRoute`, `navRouter` 환경값을 통해 처리합니다. 현재 앱 시작점은 로그인 없이 튜토리얼 플로우를 거쳐 홈으로 진입합니다.

## 개발 메모

- Swift 파일은 `Project.swift`의 `App/Sources/**` glob으로 컴파일 대상에 포함됩니다.
- 리소스는 `App/Resources/**`와 `AppSettingFiles/AppResources/**`를 사용합니다.
- 앱은 다크 UI 스타일을 기본으로 설정합니다.
- 폰트는 Pretendard 계열을 `Info.plist`에 등록해 사용합니다.
- 네트워크 로그는 `AppLogger.configure()` 이후 SwiftyBeaver를 통해 출력됩니다.

## 정리된 범위

현재 코드베이스는 홈/검색/발굴 플로우 중심으로 정리되어 있습니다. 이전 샘플 화면, 미사용 탭 구조, 미사용 공통 UI 컴포넌트, preview-only 스텁은 제거되었습니다.
