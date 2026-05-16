import SwiftUI

@MainActor
final class BottomTabBarCoordinator: ObservableObject {
    enum Tab: String, CaseIterable, Hashable {
        case home
        case second
        case myPage

        var title: String {
            switch self {
            case .home: return "home"
            case .second: return "second"
            case .myPage: return "myPage"
            }
        }

        var image: String {
            switch self {
            case .home: return AppImages.bottomHomeActive
            case .second: return AppImages.bottomExerciseActive
            case .myPage: return AppImages.bottomShopActive
            }
        }
    }

    @Published var selectedTab: Tab = .home

    func select(_ tab: Tab) {
        selectedTab = tab
    }
}
