//
//  AppRouteEnvironment.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

@MainActor
private struct NavRouterKey: @preconcurrency EnvironmentKey {
    static let defaultValue = AppRouter.empty
}

extension EnvironmentValues {
    var navRouter: AppRouter {
        get { self[NavRouterKey.self] }
        set { self[NavRouterKey.self] = newValue }
    }
}
