//
//  HomeView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI
import PopupView

struct HomeView: View {
    @Environment(\.navRouter) private var router
    @Environment(\.safeAreaInsets) private var safeArea

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

                        if store.state.hasSearchResult {
                            searchResultContent
                        } else {
                            discoveredMusicContent
                        }
                    }
                    .padding(.horizontal, HomeLayout.horizontalPadding)
                    
                }
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, HomeLayout.bottomPadding)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background {
            AppColor.GrayScaleBlack.color
                .ignoresSafeArea()
                .onTapGesture(perform: dismissKeyboard)
        }
        .popup(isPresented: musicCardPresentedBinding) {
            musicCardPopup
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .appearFrom(.bottomSlide)
                .dragToDismiss(true)
                .closeOnTap(false)
                .closeOnTapOutside(true)
                .backgroundColor(AppColor.GrayScaleBlack.color.opacity(0.45))
                .displayMode(.overlay)
                .animation(.bouncy)
        }
        .popup(isPresented: musicCardSharePopupPresentedBinding) {
            musicCardSharePopup
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .appearFrom(.bottomSlide)
                .dragToDismiss(true)
                .closeOnTap(false)
                .closeOnTapOutside(true)
                .backgroundColor(AppColor.GrayScaleBlack.color.opacity(0.45))
                .displayMode(.overlay)
                .animation(.bouncy)
        }
        .popup(isPresented: challengeStartPopupPresentedBinding) {
            challengeStartPopup
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .appearFrom(.centerScale)
                .dragToDismiss(true)
                .closeOnTap(false)
                .closeOnTapOutside(true)
                .backgroundColor(AppColor.GrayScaleBlack.color.opacity(0.45))
                .displayMode(.overlay)
                .animation(.bouncy)
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

    private var discoveredMusicContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle
                .padding(.bottom, AppSpacing.md)
                .contentShape(Rectangle())
                .onTapGesture(perform: dismissKeyboard)

            MusicGridView(
                items: store.state.musicGridItems,
                onAddTap: {
                    dismissKeyboard()
                    store.send(.addMusicTapped)
                },
                onTap: { item in
                    dismissKeyboard()
                    store.send(.musicItemTapped(item))
                }
            )
        }
    }

    private var searchResultContent: some View {
        VStack(alignment: .center, spacing: 0) {
            if let item = store.state.searchResult {
                HomeSearchResultView(item: item) {
                    dismissKeyboard()
                    store.send(.searchResultDiscoverTapped)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }


    @ViewBuilder
    private var musicCardPopup: some View {
        if let selectedMusicCard = store.state.selectedMusicCard {
            MusicCard(
                entity: selectedMusicCard,
                reviewText: musicCardReviewTextBinding,
                isReviewCompleted: musicCardReviewCompletedBinding,
                onReviewSendTap: { reviewText in
                    store.send(.musicCardReviewSubmitted(reviewText))
                },
                onReviewEditTap: {
                    store.send(.musicCardReviewEditTapped)
                },
                onShareTap: {
                    dismissKeyboard()
                    store.send(.musicCardShareTapped)
                },
                onCloseTap: {
                    store.send(.musicCardDismissed)
                }
            )
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, safeArea.bottom)
        }
    }


    private var musicCardReviewTextBinding: Binding<String> {
        Binding(
            get: { store.state.musicCardReviewText },
            set: { store.send(.musicCardReviewTextChanged($0)) }
        )
    }

    private var musicCardReviewCompletedBinding: Binding<Bool> {
        Binding(
            get: { store.state.isMusicCardReviewCompleted },
            set: { isCompleted in
                if !isCompleted {
                    store.send(.musicCardReviewEditTapped)
                }
            }
        )
    }

    private var musicCardSharePopup: some View {
        HomePopupView(
            data: .mock,
            onShareTap: {},
            onCloseTap: {
                store.send(.musicCardSharePopupDismissed)
            }
        )
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, safeArea.bottom)
    }

    private var musicCardSharePopupPresentedBinding: Binding<Bool> {
        Binding(
            get: { store.state.isMusicCardSharePopupPresented },
            set: { isPresented in
                if !isPresented {
                    store.send(.musicCardSharePopupDismissed)
                }
            }
        )
    }

    private var challengeStartPopup: some View {
        ChallengeStartPopupView(
            data: challengeStartPopupData,
            onConfirmTap: {
                store.send(.challengeStartPopupDismissed)
            },
            onCloseTap: {
                store.send(.challengeStartPopupDismissed)
            }
        )
        .padding(.horizontal, AppSpacing.lg)
    }

    private var challengeStartPopupData: ChallengeStartPopupData {
        if let searchResult = store.state.searchResult {
            ChallengeStartPopupData(searchResult: searchResult)
        } else {
            .mock
        }
    }

    private var challengeStartPopupPresentedBinding: Binding<Bool> {
        Binding(
            get: { store.state.isChallengeStartPopupPresented },
            set: { isPresented in
                if !isPresented {
                    store.send(.challengeStartPopupDismissed)
                }
            }
        )
    }

    private var musicCardPresentedBinding: Binding<Bool> {
        Binding(
            get: { store.state.selectedMusicCard != nil },
            set: { isPresented in
                if !isPresented {
                    store.send(.musicCardDismissed)
                }
            }
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
