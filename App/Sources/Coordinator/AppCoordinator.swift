import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject, NavRouter {
    enum Root {
        case home
    }

    @Published var root: Root = .home
    @Published var path: [AppRoute] = []

    var router: AppRouter {
        AppRouter(
            pushAction: push,
            popAction: pop,
            popLastAction: popLast,
            popToRootAction: popToRoot,
            popToAction: popTo,
            replaceAction: replace
        )
    }

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popLast(_ count: Int) {
        guard count > 0 else { return }
        path.removeLast(min(count, path.count))
    }

    func popToRoot() {
        path.removeAll()
    }

    func popTo(_ route: AppRoute) {
        guard let index = path.lastIndex(of: route) else { return }
        path = Array(path.prefix(through: index))
    }

    func replace(with routes: [AppRoute]) {
        path = routes
    }
}
