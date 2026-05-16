import SwiftUI

@MainActor
final class BottomTabBarCoordinator: ObservableObject {
    enum Tab: String, CaseIterable, Hashable {
        case home
        case exercise
        case social
        case crew
        case shop

        var title: String {
            switch self {
            case .home: return "홈"
            case .exercise: return "운동"
            case .social: return "소셜"
            case .crew: return "크루"
            case .shop: return "샵"
            }
        }

        var image: String {
            switch self {
            case .home: return AppImages.bottomHomeActive
            case .exercise: return AppImages.bottomExerciseActive
            case .social: return AppImages.bottomSocialActive
            case .crew: return AppImages.bottomCrewActive
            case .shop: return AppImages.bottomShopActive
            }
        }
    }

    @Published var selectedTab: Tab = .home

    func select(_ tab: Tab) {
        selectedTab = tab
    }
}
