import SwiftUI

@main
struct AppApp: App {
    init() {
        AppLogger.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorRootView()
        }
    }
}

#if DEBUG
#Preview {
    AppCoordinatorRootView()
}
#endif
