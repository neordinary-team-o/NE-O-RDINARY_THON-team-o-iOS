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
            
            searchBar
                .padding(.bottom, AppSpacing.xl)
                .padding(.horizontal, HomeLayout.horizontalPadding)
            
            ScrollView(.vertical, showsIndicators: false) {
                discoveredMusicContent
                    .padding(.horizontal, HomeLayout.horizontalPadding)
                .padding(.bottom, HomeLayout.bottomPadding)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background {
            AppColor.GrayScaleBlack.color
                .ignoresSafeArea()
                .onTapGesture(perform: dismissKeyboard)
        }
        .fullScreenCover(isPresented: pickCompletePresentedBinding) {
            pickCompleteCover
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    private func dismissKeyboard() {
        endTextEditing()
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

                Image(AppImages.plus)
                    .resizable()
                    .scaledToFit()
                    .frame(width: HomeLayout.profileIconSize, height: HomeLayout.profileIconSize)
                    .asButton(haptic: true) {
                        router.push(.home(.search))
                    }
                    .accessibilityLabel("추가")
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
            isSearch: true,
            onSubmit: { store.send(.searchSubmitted) }
        )
    }

    private var discoveredMusicContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle
                .padding(.bottom, AppSpacing.md)
                .contentShape(Rectangle())
                .onTapGesture(perform: dismissKeyboard)

            MusicGridView(
                items: store.state.musicGridItems,
                onTap: { item in
                    dismissKeyboard()
                    store.send(.musicItemTapped(item))
                }
            )
        }
    }

    @ViewBuilder
    private var pickCompleteCover: some View {
        if let selectedPickComplete = store.state.selectedPickComplete {
            PickCompleteView(
                entity: selectedPickComplete,
                onClose: {
                    store.send(.pickCompleteDismissed)
                },
                onCheck: {
                    store.send(.pickCompleteDismissed)
                }
            )
        }
    }

    private var pickCompletePresentedBinding: Binding<Bool> {
        Binding(
            get: { store.state.selectedPickComplete != nil },
            set: { isPresented in
                if !isPresented {
                    store.send(.pickCompleteDismissed)
                }
            }
        )
    }

    private var sectionTitle: some View {
        Text("내가 발굴한 곡이예요")
            .appFont(AppFont.heading, font: .semiFont)
            .foregroundStyle(AppColor.GrayScaleWhite.color)
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
