import SwiftUI

struct AppCoordinatorRootView: View {
    @StateObject private var coordinator = AppCoordinator()
    @State private var homeEntry = HomeEntry.tutorial1

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                switch coordinator.root {
                case .login:
                    LoginView {
                        coordinator.loginSucceeded()
                    }
                case .home:
                    homeEntryView
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                route.destination
                    .environment(\.navRouter, coordinator.router)
            }
        }
        .environment(\.navRouter, coordinator.router)
    }

    @ViewBuilder
    private var homeEntryView: some View {
        switch homeEntry {
        case .tutorial1:
            Tutorial1View(
                onClose: { homeEntry = .home },
                onNext: { homeEntry = .tutorial2 }
            )
        case .tutorial2:
            Tutorial2View(
                onClose: { homeEntry = .home },
                onNext: { homeEntry = .home }
            )
        case .home:
            HomeView()
        }
    }

    private enum HomeEntry {
        case tutorial1
        case tutorial2
        case home
    }
}


#Preview {
    AppCoordinatorRootView()
}
