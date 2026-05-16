import SwiftUI

@main
struct AppApp: App {
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
