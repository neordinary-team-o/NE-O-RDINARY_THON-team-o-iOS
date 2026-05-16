//
//  ChallengeStartPopupView.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import SwiftUI

struct ChallengeStartPopupData: Equatable, Hashable {
    let title: String
    let artist: String
    let discoveredDateText: String
    let currentViewCountText: String
    let artworkURL: URL?
}

extension ChallengeStartPopupData {
    init(searchResult: HomeSearchResultItem) {
        self.init(
            title: searchResult.title,
            artist: searchResult.artist,
            discoveredDateText: "24.03.15",
            currentViewCountText: searchResult.viewCountText,
            artworkURL: searchResult.artworkURL
        )
    }

    static let mock = ChallengeStartPopupData(
        title: "강남스타일",
        artist: "PSY",
        discoveredDateText: "24.03.15",
        currentViewCountText: "18,891회",
        artworkURL: URL(string: "https://picsum.photos/seed/cmc-gangnam-style/240/240")
    )
}

struct ChallengeStartPopupView: View {
    let data: ChallengeStartPopupData
    let onConfirmTap: () -> Void
    let onCloseTap: () -> Void

    init(
        data: ChallengeStartPopupData,
        onConfirmTap: @escaping () -> Void = {},
        onCloseTap: @escaping () -> Void = {}
    ) {
        self.data = data
        self.onConfirmTap = onConfirmTap
        self.onCloseTap = onCloseTap
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center, spacing: AppSpacing.lg) {
                titleImage
                contentSection
            }
            .padding(.top, AppSpacing.lg)
            .padding(.horizontal, ChallengeStartPopupLayout.horizontalPadding)
            .padding(.bottom, ChallengeStartPopupLayout.bottomPadding)

            closeButton
        }
        .frame(maxWidth: ChallengeStartPopupLayout.cardMaxWidth)
        .background(AppColor.GrayScale800.color)
        .clipShape(.rect(cornerRadius: ChallengeStartPopupLayout.cornerRadius, style: .continuous))
        .shadow(color: AppColor.GrayScaleBlack.color.opacity(0.25), radius: 4, x: 0, y: 4)
        .accessibilityElement(children: .contain)
    }

    private var titleImage: some View {
        Image(AppImages.challenge)
            .resizable()
            .renderingMode(.original)
            .scaledToFit()
            .frame(
                width: ChallengeStartPopupLayout.titleImageWidth,
                height: ChallengeStartPopupLayout.titleImageHeight
            )
            .accessibilityLabel("발굴 도전")
    }

    private var contentSection: some View {
        VStack(alignment: .center, spacing: AppSpacing.xl) {
            VStack(alignment: .center, spacing: AppSpacing.md) {
                songSummary
                statsSection
            }

            confirmButton
        }
        .frame(maxWidth: .infinity)
    }

    private var songSummary: some View {
        VStack(alignment: .center, spacing: AppSpacing.md) {
            artwork
            songText
        }
    }

    private var artwork: some View {
        NetworkImageView(
            url: data.artworkURL,
            option: .custom(
                CGSize(
                    width: ChallengeStartPopupLayout.artworkSize,
                    height: ChallengeStartPopupLayout.artworkSize
                )
            )
        )
        .scaledToFill()
        .frame(
            width: ChallengeStartPopupLayout.artworkSize,
            height: ChallengeStartPopupLayout.artworkSize
        )
        .background(AppColor.GrayScaleBlack.color)
        .clipShape(
            .rect(
                cornerRadius: ChallengeStartPopupLayout.artworkCornerRadius,
                style: .continuous
            )
        )
    }

    private var songText: some View {
        VStack(alignment: .center, spacing: AppSpacing.xxs) {
            HStack(alignment: .lastTextBaseline, spacing: AppSpacing.sm) {
                Text(data.title)
                    .appFont(AppFont.title, font: .boldFont)
                    .foregroundStyle(AppColor.GrayScaleWhite.color)

                Text(data.artist)
                    .appFont(AppFont.labelNormal, font: .semiFont)
                    .foregroundStyle(AppColor.GrayScale300.color)
            }

            HStack(spacing: AppSpacing.xs) {
                Text("발굴일")
                    .appFont(AppFont.caption)
                    .foregroundStyle(AppColor.GrayScale300.color)

                Text(data.discoveredDateText)
                    .appFont(AppFont.caption)
                    .foregroundStyle(AppColor.GrayScale300.color)
            }
        }
        .multilineTextAlignment(.center)
    }

    private var statsSection: some View {
        HStack(alignment: .center, spacing: AppSpacing.xxs) {
            Text("현재 조회수")
                .appFont(AppFont.caption)
                .foregroundStyle(AppColor.GrayScaleWhite.color)

            Text(data.currentViewCountText)
                .appFont(AppFont.caption)
                .foregroundStyle(AppColor.GrayScaleWhite.color)
        }
        .frame(maxWidth: .infinity)
    }

    private var confirmButton: some View {
        Text("확인")
            .appFont(AppFont.headline, font: .semiFont)
            .foregroundStyle(AppColor.GrayScaleBlack.color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColor.GreenNormal.color)
            .clipShape(Capsule())
            .contentShape(Rectangle())
            .asButton(haptic: true, action: onConfirmTap)
            .accessibilityLabel("확인")
    }

    private var closeButton: some View {
        Image(AppImages.x)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: AppSpacing.lg, height: AppSpacing.lg)
            .foregroundStyle(AppColor.GrayScale400.color)
            .padding(AppSpacing.xs)
            .contentShape(Rectangle())
            .asButton(haptic: true, action: onCloseTap)
            .padding(.top, ChallengeStartPopupLayout.closeTopPadding)
            .padding(.trailing, ChallengeStartPopupLayout.closeTrailingPadding)
            .accessibilityLabel("닫기")
    }
}

private enum ChallengeStartPopupLayout {
    static let cardMaxWidth: CGFloat = 322
    static let cornerRadius: CGFloat = 30
    static let horizontalPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 20
    static let titleImageWidth: CGFloat = 106.37
    static let titleImageHeight: CGFloat = 21.41
    static let artworkSize: CGFloat = 120
    static let artworkCornerRadius: CGFloat = 20
    static let closeTopPadding: CGFloat = 22
    static let closeTrailingPadding: CGFloat = 14
}

#if DEBUG
#Preview {
    ZStack {
        AppColor.GrayScaleBlack.color
            .ignoresSafeArea()

        ChallengeStartPopupView(data: .mock)
            .padding(AppSpacing.lg)
    }
}
#endif
