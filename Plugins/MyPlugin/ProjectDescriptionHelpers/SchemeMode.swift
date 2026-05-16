//
//  SchemeMode.swift
//  MyPlugin
//
//  Created by Jae hyung Kim on 3/12/26.
//

import ProjectDescription
import Foundation

public enum SchemeMode: CaseIterable {
    case dev
    case prod
    
    public var schemeName: String {
        switch self {
        case .dev:
            return "Dev"
        case .prod:
            return "Prod"
        }
    }
    
    public static func getSelf(schemeString: String) -> SchemeMode? {
        return SchemeMode.allCases.first { $0.schemeName == schemeString }
    }

    public var infoPlist: String {
        return self.schemeName + ".Plist"
    }
}

extension Path {
    
    public static func onesPlistName() -> Path {
        return .relativeToRoot("AppSettingFiles/InfoPlist/Info.Plist")
    }
    
    public static func xcconfigPath(_ xcconfigName: String) -> Path {
        .relativeToRoot("AppSettingFiles/XCConfigs/\(xcconfigName).xcconfig")
    }

}

extension Settings {
    
    public static var appSettings: Self {
        return .settings(
            base: [
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "SWIFT_VERSION": "5.9"
            ],
            configurations: [
                .debug,
                .release,
                .dev,
                .prod,
            ]
        )
    }
    
    public static func swift6Settings(disPlayName: String? = nil) -> Self {
        var base: ProjectDescription.SettingsDictionary = [
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "SWIFT_VERSION": "5.9"
        ]
        if let disPlayName {
            base["DISPLAY_NAME"] = .string(disPlayName)
        }
        return .settings(
            base: base,
            configurations: [
                .debug,
                .release,
                .dev,
                .prod,
            ]
        )
    }
    
    @available(*, deprecated, renamed: "swift6Settings(disPlayName:)", message: "use swift6Settings(disPlayName:)")
    public static func demoAppSetting(name: String) -> Self {
        return .settings(
            base: [
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "DISPLAY_NAME" : "\(name)",
            ],
            configurations: [
                .debug,
                .release,
                .dev,
                .prod,
            ]

        )
    }
}

extension Scheme {
    
    public static func schemes(name: String) -> [Self] {
        var targets: [TargetReference] = []
        targets.append("\(AppConfig.appName)")
        return [
            .scheme( // Dev
                name: name + "_Dev",
                shared: true,
                hidden: false,
                buildAction: .buildAction(targets: targets),
                runAction: .runAction(configuration: .dev),
                archiveAction: .archiveAction(configuration: .dev),
                profileAction: .profileAction(configuration: .dev),
                analyzeAction: .analyzeAction(configuration: .dev)
            ),

            .scheme( // Prod
                name: name + "_Prod",
                shared: true,
                hidden: false,
                buildAction: .buildAction(targets: targets),
                runAction: .runAction(configuration: .prod),
                archiveAction: .archiveAction(configuration: .prod),
                profileAction: .profileAction(configuration: .prod),
                analyzeAction: .analyzeAction(configuration: .prod)
            )
        ]
    }
}

extension ConfigurationName {
    
    public static let dev: Self = .configuration(SchemeMode.dev.schemeName)
    
    public static let prod: Self = .configuration(SchemeMode.prod.schemeName)
}

extension Configuration {
    public static let debug: Self = .debug(name: "Debug", xcconfig: .xcconfigPath("Debug"))
    public static let release: Self = .release(name: "Release", xcconfig: .xcconfigPath("Release"))
    public static let dev: Self = .debug(name: .dev, xcconfig: .xcconfigPath(SchemeMode.dev.schemeName))
    public static let prod: Self = .debug(name: .prod, xcconfig: .xcconfigPath(SchemeMode.prod.schemeName))
}
