import SwiftUI

struct AppCoordinatorRootView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                switch coordinator.root {
                case .login:
                    LoginView {
                        coordinator.loginSucceeded()
                    }
                case .tabs:
                    BottomTabCoordinatorView(coordinator: coordinator.tabCoordinator)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                route.destination
                    .environment(\.navRouter, coordinator.router)
            }
        }
        .environment(\.navRouter, coordinator.router)
    }
}


#Preview {
    AppCoordinatorRootView()
}
