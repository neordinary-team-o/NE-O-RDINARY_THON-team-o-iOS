//
//  SettingRoute.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

enum SettingRoute: Hashable {
    case root
}

extension SettingRoute {
    @ViewBuilder
    var destination: some View {
        switch self {
        case .root:
            SettingView()
        }
    }
}
