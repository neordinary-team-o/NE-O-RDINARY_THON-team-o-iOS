import SwiftUI

enum AppRoute: Hashable {
    case home(HomeRoute)
    case exercise(ExerciseRoute)
    case setting(SettingRoute)
}

extension AppRoute {
    @ViewBuilder
    var destination: some View {
        switch self {
        case let .home(route):
            route.destination
        case let .exercise(route):
            route.destination
        case let .setting(route):
            route.destination
        }
    }
}
