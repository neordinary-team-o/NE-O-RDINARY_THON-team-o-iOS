//
//  SearchView.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import SwiftUI
import PopupView

struct SearchView: View {
    @Environment(\.navRouter) private var router

    @StateObject private var store: StoreOf<SearchReducer>

    init(initialState: SearchReducer.State = SearchReducer.State()) {
        _store = StateObject(
            wrappedValue: StoreOf<SearchReducer>(
                initialState: initialState,
                reducer: SearchReducer()
            )
        )
    }

    var body: some View {
        ZStack(alignment: .top) {
            background

            VStack(spacing: 0) {
                topAppBar

                VStack(spacing: 0) {
                    searchBar
                        .padding(.bottom, AppSpacing.xl)

                    searchContent
                }
                .padding(.horizontal, SearchLayout.horizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .navigationBarBackButtonHidden(true)
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

    private var background: some View {
        ZStack(alignment: .top) {
            AppColor.GrayScaleBlack.color
                .ignoresSafeArea()

            RadialGradient(
                colors: [
                    AppColor.GreenNormal.color.opacity(SearchLayout.glowPrimaryOpacity),
                    AppColor.GreenNormalActive.color.opacity(SearchLayout.glowSecondaryOpacity),
                    AppColor.GreenNormal.color.opacity(0)
                ],
                center: .top,
                startRadius: AppSpacing.xs,
                endRadius: SearchLayout.glowEndRadius
            )
            .frame(height: SearchLayout.glowHeight)
            .blur(radius: AppSpacing.lg)
            .ignoresSafeArea(edges: .top)
        }
    }

    private var topAppBar: some View {
        ZStack {
            Image(AppImages.topLogo)
                .resizable()
                .scaledToFit()
                .frame(width: SearchLayout.logoWidth, height: SearchLayout.logoHeight)
                .accessibilityLabel("홍대병동")

            HStack {
                Image(AppImages.arrowLeft)
                    .resizable()
                    .scaledToFit()
                    .frame(width: SearchLayout.backIconSize, height: SearchLayout.backIconSize)
                    .foregroundStyle(AppColor.GrayScale400.color)
                    .asButton(haptic: true) {
                        router.pop()
                    }
                    .accessibilityLabel("뒤로가기")

                Spacer()
            }
        }
        .padding(.vertical, AppSpacing.sm)
        .padding(.horizontal, SearchLayout.appBarHorizontalPadding)
        .frame(maxWidth: .infinity)
    }

    private var searchBar: some View {
        CommonTextField(
            text: Binding(
                get: { store.state.searchText },
                set: { store.send(.searchTextChanged($0)) }
            ),
            placeHolder: "찾을 곡을 입력하세요",
            isActiveMode: true,
            keyboardType: .default,
            isSecure: false,
            isSearch: true
        )
    }

    @ViewBuilder
    private var searchContent: some View {
        if let result = store.state.result {
            ScrollView(.vertical, showsIndicators: false) {
                HomeSearchResultView(
                    item: result,
                    onDiscoverTap: { store.send(.discoverTapped) }
                )
                .padding(.top, AppSpacing.md)
                .padding(.bottom, SearchLayout.resultBottomPadding)
            }
            .scrollDismissesKeyboard(.interactively)
        } else {
            emptyState
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var emptyState: some View {
        Text("검색 결과가 없습니다.")
            .appFont(AppFont.bodyNormal, font: .semiFont)
            .foregroundStyle(AppColor.GrayScale300.color)
            .multilineTextAlignment(.center)
            .accessibilityLabel("검색 결과가 없습니다.")
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
        if let result = store.state.result {
            ChallengeStartPopupData(searchResult: result)
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
}

private enum SearchLayout {
    static let horizontalPadding: CGFloat = AppSpacing.lg - AppSpacing.xxs
    static let appBarHorizontalPadding: CGFloat = 20
    static let logoWidth: CGFloat = 93
    static let logoHeight: CGFloat = 36
    static let backIconSize: CGFloat = 32
    static let glowHeight: CGFloat = AppSpacing.xxl * 5
    static let glowEndRadius: CGFloat = AppSpacing.xxl * 4
    static let glowPrimaryOpacity = 0.34
    static let glowSecondaryOpacity = 0.18
    static let resultBottomPadding: CGFloat = AppSpacing.xxl + AppSpacing.xl
}

#if DEBUG
#Preview("Empty") {
    SearchView()
}

#Preview("Result") {
    SearchView(
        initialState: SearchReducer.State(
            searchText: "강남스타일",
            result: .mockGangnamStyle
        )
    )
}
#endif
