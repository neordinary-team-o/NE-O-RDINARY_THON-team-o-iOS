//
//  HomeRoute.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

enum HomeRoute: Hashable {
    case detail(id: String)
    case search
    case step2(value: String)
    case step3
    case step4(value: String)
}

extension HomeRoute {
    @ViewBuilder
    var destination: some View {
        switch self {
        case let .detail(id):
            HomeDetailView(id: id)
        case .search:
            SearchView()
        case let .step2(value):
            HomeStepView(step: 2, value: value)
        case .step3:
            HomeStepView(step: 3, value: nil)
        case let .step4(value):
            HomeStepView(step: 4, value: value)
        }
    }
}
