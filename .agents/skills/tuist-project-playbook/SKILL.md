---
name: tuist-project-playbook
description: Project-specific playbook for this Tuist app. Covers rename flow, dependency onboarding, xcconfig and build config rules, coordinator-based navigation, and sample coordinator implementation details.
---

# Tuist Project Playbook

## Prometheus Plan Builder

### 1) Project rename guide
- Update app naming source in `App/Plugins/MyPlugin/ProjectDescriptionHelpers/AppConfigs.swift`.
- Confirm target names in `App/Project.swift` still interpolate `AppConfig.appName`.
- Update bundle-related variables in `App/AppSettingFiles/XCConfigs/Base.xcconfig` and env overrides in `App/AppSettingFiles/XCConfigs/Dev.xcconfig`.
- Keep watch bundle chain aligned:
  - iOS app: `$(APP_BASE_BUNDLE_IDENTIFIER)`
  - watch app: `$(APP_BASE_BUNDLE_IDENTIFIER).watchkitapp`
  - watch extension: `$(APP_BASE_BUNDLE_IDENTIFIER).watchkitapp.watchkitextension`
- Regenerate and verify with `tuist generate`.

### 2) Add library guide
- Add package URL/version in `App/Tuist/Package.swift`.
- Run `tuist install` to sync `App/Tuist/Package.resolved`.
- Add a `TargetDependency.external(name:)` alias in `App/Plugins/MyPlugin/ProjectDescriptionHelpers/Core.swift` if needed.
- Attach dependency in target block inside `App/Project.swift`.
- Regenerate and build to verify module linkage.

### 3) xcconfig rules
- Shared values go to `App/AppSettingFiles/XCConfigs/Base.xcconfig`.
- Environment-only overrides go to `Dev.xcconfig`, `Prod.xcconfig`, `Debug.xcconfig`, `Release.xcconfig`.
- Keep `SWIFT_ACTIVE_COMPILATION_CONDITIONS` and bundle identifiers consistent with scheme names.
- Avoid duplicating large setting blocks across every file.
- **⚠️ IMPORTANT: Set your Team ID** — `Base.xcconfig` has `DEVELOPMENT_TEAM = Example` (line 88). Replace "Example" with your actual Apple Developer Team ID before building for device or App Store submission.

### 4) Coordinator folder purpose
- `App/App/Sources/Coordinator` is the app navigation layer.
- `AppCoordinatorRootView` is app root for flow switching.
- `AppCoordinator` owns high-level app flow state.
- `BottomTabBarCoordinator` controls selected tab and tab transition actions.

## Hephaestus Deep Agent (sample implemented)
- `AppCoordinator`: root state owner.
- `BottomTabBarCoordinator`: tab state owner (`A/B/C/D/E`).
- `BottomTabCoordinatorView`: `TabView(selection:)` wired to coordinator.
- Demo views:
  - `TabAView`, `TabBView`, `TabCView`, `TabDView`, `TabEView`
  - each calls coordinator to switch tabs.

### 5) Tuist installation guide
- This project uses [mise](https://mise.jdx.dev/) (formerly rtx) for tool version management.
- Tuist version is pinned in `mise.toml` at project root:
  ```toml
  [tools]
  tuist = "4.52.0"
  ```
- Install mise first, then run `mise install` to install the pinned Tuist version.
- Alternatively, install Tuist directly following [Tuist documentation](https://docs.tuist.io/).
- After installation, run `tuist install` then `tuist generate` to set up the project.

### 6) GoogleService-Info configuration (Firebase)
- Firebase configuration files are stored in `AppSettingFiles/InfoPlist/`:
  - `GoogleService-Dev-Info.plist` - Development environment
  - `GoogleService-Live-Info.plist` - Production environment
- Build script automatically copies the appropriate plist based on build configuration:
  - `Dev` scheme → copies `GoogleService-Dev-Info.plist`
  - `Prod` scheme → copies `GoogleService-Live-Info.plist`
- The script is defined in `App/Plugins/MyPlugin/ProjectDescriptionHelpers/FireBaseConfig.swift`.
- **To add Firebase to a new target**: Reference the pre/post build scripts from `TargetScript.fireBase` and `TargetScript.fireBaseCrashlyticsRun`.

### 7) Entitlements configuration
- Entitlements files should be placed in `AppSettingFiles/Entitlements/`.
- Currently this directory is empty (reserved for future capability additions).
- To add entitlements to a target:
  1. Create `.entitlements` file in `AppSettingFiles/Entitlements/`
  2. Reference it in `Project.swift` target definition using `entitlements: .file(path: ...)`
  3. Use different entitlements for Dev/Prod if needed by checking `CONFIGURATION` in build settings

## Additional project docs (Prometheus recommendation)
- Keep this playbook as the local source of truth for onboarding.
- Keep operational notes in this file for:
  - signing/provisioning troubleshooting
  - watch companion bundle checks
  - dependency sync failures (`tuist install` then `tuist generate`)
