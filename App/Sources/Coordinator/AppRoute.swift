import SwiftUI

enum AppRoute: Hashable {
    case home(HomeRoute)
}

extension AppRoute {
    @ViewBuilder
    var destination: some View {
        switch self {
        case let .home(route):
            route.destination
        }
    }
}
