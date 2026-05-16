import ProjectDescription
import MyPlugin

let project = Project(
    name: AppConfig.appName,
    settings: .appSettings,
    targets: [
        .target(
            name: AppConfig.appName,
            destinations: [.iPhone],
            product: .app,
            bundleId: "$(APP_BASE_BUNDLE_IDENTIFIER)",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(DISPLAY_NAME)",
                "CFBundleName": "$(DISPLAY_NAME)",
                "UILaunchStoryboardName": .string("LaunchScreen"),
                "UIAppFonts": .array([
                    .string("Pretendard-Black.otf"),
                    .string("Pretendard-Bold.otf"),
                    .string("Pretendard-ExtraBold.otf"),
                    .string("Pretendard-ExtraLight.otf"),
                    .string("Pretendard-Light.otf"),
                    .string("Pretendard-Medium.otf"),
                    .string("Pretendard-Regular.otf"),
                    .string("Pretendard-SemiBold.otf"),
                    .string("Pretendard-Thin.otf"),
                ]),
                "UIUserInterfaceStyle": .string("Dark")
            ]),
            sources: ["App/Sources/**"],
            resources: [
                .glob(pattern: .relativeToRoot("App/Resources/**"), excluding: [], tags: [], inclusionCondition: nil),
                .glob(
                    pattern: .relativeToRoot("AppSettingFiles/AppResources/**"),
                    excluding: [.relativeToRoot("AppSettingFiles/AppResources/Font/**")],
                    tags: [],
                    inclusionCondition: nil
                ),
            ],
            dependencies: [
                .popupView,
                .imageCompressor,
                .alamofire,
                .swiftyBeaver,
                .kingFisher,
//                .target(name: "\(AppConfig.appName)-watch")
            ]
        ),
        .target(
            name: "\(AppConfig.appName)-watch",
            destinations: [.appleWatch],
            product: .watch2App,
            bundleId: "$(APP_BASE_BUNDLE_IDENTIFIER).watchkitapp",
            deploymentTargets: .watchOS("11.0"),
            infoPlist: .extendingDefault(with: [
                "WKCompanionAppBundleIdentifier": "$(APP_BASE_BUNDLE_IDENTIFIER)",
            ]),
            dependencies: [
                .target(name: "\(AppConfig.appName)-watchExtension")
            ]
        ),
        .target(
            name: "\(AppConfig.appName)-watchExtension",
            destinations: [.appleWatch],
            product: .watch2Extension,
            bundleId: "$(APP_BASE_BUNDLE_IDENTIFIER).watchkitapp.watchkitextension",
            deploymentTargets: .watchOS("11.0"),
            infoPlist: .extendingDefault(with: [
                "UIAppFonts": .array([
                    .string("Pretendard-Black.otf"),
                    .string("Pretendard-Bold.otf"),
                    .string("Pretendard-ExtraBold.otf"),
                    .string("Pretendard-ExtraLight.otf"),
                    .string("Pretendard-Light.otf"),
                    .string("Pretendard-Medium.otf"),
                    .string("Pretendard-Regular.otf"),
                    .string("Pretendard-SemiBold.otf"),
                    .string("Pretendard-Thin.otf"),
                ]),
                "NSExtension": [
                    "NSExtensionAttributes": [
                        "WKAppBundleIdentifier": "$(WATCH_APP_BUNDLE_IDENTIFIER)",
                    ],
                    "NSExtensionPointIdentifier": "com.apple.watchkit",
                ],
            ]),
            sources: ["WatchAppExtension/Sources/**"],
            resources: [
                .glob(pattern: .relativeToRoot("AppSettingFiles/AppResources/Font/**"), excluding: [], tags: [], inclusionCondition: nil),
            ]
        ),
        .target(
            name: "AppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.AppTests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [.target(name: "App")]
        ),
    ],
    schemes: Scheme.schemes(name: AppConfig.appName),
    resourceSynthesizers: [
        .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
        .custom(name: "Fonts", parser: .fonts, extensions: ["otf"]),
    ]
)
