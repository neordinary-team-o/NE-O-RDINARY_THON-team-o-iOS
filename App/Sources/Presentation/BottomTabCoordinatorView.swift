import SwiftUI

struct BottomTabCoordinatorView: View {
    
    private var rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: BottomTabBarCoordinator.Tab.allCases.count)
    
    @ObservedObject var coordinator: BottomTabBarCoordinator
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    init(coordinator: BottomTabBarCoordinator) {
        self.coordinator = coordinator
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        
        // 경계선(검정색 줄) 제거
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.shadowColor = .clear
        
        // 설정 적용
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    // 커스텀 탭바 뷰
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            scopeView
                .toolbar(.hidden, for: .tabBar)
        }
        .overlay(alignment: .bottom) {
            customTabView
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


extension BottomTabCoordinatorView {
    
    private var customTabView: some View {
        VStack {
            LazyVGrid(columns: rows) {
                ForEach(BottomTabBarCoordinator.Tab.allCases, id: \.self) { caseOf in
                    tabItemView(tabItem: caseOf)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .fixedSize()
                        .asButton(
                            haptic: true,
                        ) {
                            coordinator.select(caseOf)
                        }
                }
            }
        }
        .padding(.top, 10)
        .padding(.bottom, safeAreaInsets.bottom + 8)
        .padding(.horizontal, 20)
        .background(Color.gray)
        .cornerRadiusCorners(24, corners: [.topLeft, .topRight])
        .overlay {
            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 24)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.white)
        }
        .frame(width: UIScreen.main.bounds.width + 2)
        .offset(y: 1)
    }
    
    private func tabItemView(
        tabItem: BottomTabBarCoordinator.Tab
    ) -> some View {
        let current = coordinator.selectedTab
        let this = tabItem
        let same = current == this
        
        return VStack {
            Group {
                Image(tabItem.image)
                    .resizable()
            }
            .frame(width: 24, height: 24)
            .foregroundStyle( same ? Color.blue : Color.black )
            .padding(.bottom, 4)
            
            Text(this.title)
                .font( same ? .body : .callout)
                .foregroundStyle(Color.white)
        }
    }
}

// MARK: TabContents (리퀴드 글라스 혹은 기본)
extension BottomTabCoordinatorView {
    private var scopeView: some View {
        Group {
            HomeView()
                .tabItem { Label(BottomTabBarCoordinator.Tab.home.title, image: BottomTabBarCoordinator.Tab.home.image) }
                .tag(BottomTabBarCoordinator.Tab.home)

            SecondView()
                .tabItem { Label(BottomTabBarCoordinator.Tab.second.title, image: BottomTabBarCoordinator.Tab.second.image) }
                .tag(BottomTabBarCoordinator.Tab.second)

            MyPageView()
                .tabItem { Label(BottomTabBarCoordinator.Tab.myPage.title, image: BottomTabBarCoordinator.Tab.myPage.image) }
                .tag(BottomTabBarCoordinator.Tab.myPage)
        }
    }
}

#Preview {
    BottomTabCoordinatorView(
        coordinator: BottomTabBarCoordinator()
    )
}
