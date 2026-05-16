//
//  HomeView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.navRouter) private var router

    @StateObject private var store = StoreOf<HomeReducer>(
        initialState: HomeReducer.State(),
        reducer: HomeReducer()
    )

    var body: some View {
        VStack {
            topAppBar
                .padding(.bottom, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        searchBar
                            .padding(.bottom, AppSpacing.xl)
                        sectionTitle
                            .padding(.bottom, AppSpacing.md)
                        
                        MusicGridView(
                            items: store.state.musicGridItems,
                            onAddTap: {
                                store.send(.addMusicTapped)
                            },
                            onTap: { item in
                                store.send(.musicItemTapped(item))
                            }
                        )
                    }
                    .padding(.horizontal, HomeLayout.horizontalPadding)
                    
                }
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, HomeLayout.bottomPadding)
            }
        }
        
        .background(AppColor.GrayScaleBlack.color.ignoresSafeArea())
    }

    private var topAppBar: some View {
        ZStack {
            Image(AppImages.topLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 93 , height: HomeLayout.logoHeight)
                .accessibilityLabel("홍대병동")

            HStack {
                Spacer()

                Image(AppImages.myPage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: HomeLayout.profileIconSize, height: HomeLayout.profileIconSize)
                    .asButton(haptic: true) {
                        router.push(.setting(.root))
                    }
                    .accessibilityLabel("마이페이지")
            }
            .padding(.horizontal, HomeLayout.profileHorizontalPadding)
        }
        .padding(.vertical, AppSpacing.sm)
    }

    private var searchBar: some View {
        CommonTextField(
            text: Binding(
                get: { store.state.searchText },
                set: { store.send(.searchTextChanged($0)) }
            ),
            placeHolder: "검색어를 입력하세요",
            isActiveMode: true,
            keyboardType: .default,
            isSecure: false,
            isSearch: true
        )
    }

    private var sectionTitle: some View {
        HStack(spacing: 0) {
            Text(store.state.userName)
                .appFont(AppFont.heading, font: .semiFont)
                .foregroundStyle(AppColor.GreenLightActive.color)

            Text(" 님이 발굴한 곡이예요")
                .appFont(AppFont.heading, font: .semiFont)
                .foregroundStyle(AppColor.GrayScaleWhite.color)
        }
        .accessibilityElement(children: .combine)
    }
}

private enum HomeLayout {
    static let horizontalPadding: CGFloat = 20
    static let profileHorizontalPadding: CGFloat = 18
    static let logoHeight: CGFloat = 36
    static let profileIconSize: CGFloat = 32
    static let bottomPadding: CGFloat = 140
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
