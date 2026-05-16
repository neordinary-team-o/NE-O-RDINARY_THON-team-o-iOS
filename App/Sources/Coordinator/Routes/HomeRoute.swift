//
//  HomeRoute.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

enum HomeRoute: Hashable {
    case search
}

extension HomeRoute {
    @ViewBuilder
    var destination: some View {
        switch self {
        case .search:
            SearchView()
        }
    }
}
