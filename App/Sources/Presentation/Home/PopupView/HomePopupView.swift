//
//  HomePopupView.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import SwiftUI

struct HomePopupView: View {
    let data: HomePopupData
    let onShareTap: () -> Void
    let onCloseTap: () -> Void

    init(
        data: HomePopupData,
        onShareTap: @escaping () -> Void = {},
        onCloseTap: @escaping () -> Void = {}
    ) {
        self.data = data
        self.onShareTap = onShareTap
        self.onCloseTap = onCloseTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
                .padding(.bottom, AppSpacing.lg)
            artworkSection
                .padding(.bottom, AppSpacing.lg)
            descriptionSection
                .padding(.bottom, AppSpacing.md)
            statsSection
                .padding(.bottom, AppSpacing.xl)
            shareButton
        }
        .padding(.top, AppSpacing.lg)
        .padding(.horizontal, HomePopupLayout.horizontalPadding)
        .padding(.bottom, HomePopupLayout.bottomPadding)
        .frame(maxWidth: HomePopupLayout.cardMaxWidth)
        .background(cardBackground)
        .clipShape(.rect(cornerRadius: HomePopupLayout.cornerRadius, style: .continuous))
        .accessibilityElement(children: .contain)
    }

    private var headerSection: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            Spacer(minLength: AppSpacing.md)

            Image(AppImages.x)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: AppSpacing.lg, height: AppSpacing.lg)
                .foregroundStyle(AppColor.GrayScaleWhite.color)
                .padding(AppSpacing.xs)
                .contentShape(Rectangle())
                .asButton(haptic: true, action: onCloseTap)
                .accessibilityLabel("닫기")
        }
    }

    private var artworkSection: some View {
        VStack(spacing: AppSpacing.md) {
            artwork

            VStack(spacing: 0) {
                
                HStack(spacing: AppSpacing.xs) {
                    Text(data.title)
                        .appFont(AppFont.heading, font: .semiFont)
                        .foregroundStyle(AppColor.GrayScaleWhite.color)
                        .multilineTextAlignment(.center)
                    
                    Text(data.artist)
                        .appFont(AppFont.labelNormal)
                        .foregroundStyle(AppColor.GrayScale300.color)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, AppSpacing.xxs)
                
                HStack(spacing: AppSpacing.xs) {
                    Text("발굴일")
                        .font(AppFont.caption.font())
                        .foregroundStyle(AppColor.GrayScale300.color)
                    
                    Text(data.discoveredDate)
                        .appFont(AppFont.caption)
                        .foregroundStyle(AppColor.GrayScale300.color)
                }
                .padding(.bottom, AppSpacing.lg)
                
                HStack {
                    Text("Trend Catcher")
                        .font(AppFont.caption.font())
                        .foregroundStyle(AppColor.GreenNormal.color)
                    
                    Text("\(data.crewName)님의 발견")
                        .appFont(AppFont.caption)
                        .foregroundStyle(AppColor.GrayScale300.color)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var artwork: some View {
        if let artworkImageName = data.artworkImageName, !artworkImageName.isEmpty {
            Image(artworkImageName)
                .resizable()
                .scaledToFill()
                .frame(width: HomePopupLayout.artworkSize, height: HomePopupLayout.artworkSize)
                .clipShape(.rect(cornerRadius: HomePopupLayout.artworkCornerRadius, style: .continuous))
        } else {
            ZStack {
                AppColor.GrayScale800.color

                VStack(spacing: AppSpacing.xs) {
                    Text(data.title)
                        .appFont(AppFont.heading, font: .semiFont)
                        .foregroundStyle(AppColor.GreenNormal.color)

                    Text(data.artist)
                        .appFont(AppFont.caption)
                        .foregroundStyle(AppColor.GrayScale300.color)
                }
                .multilineTextAlignment(.center)
                .padding(AppSpacing.md)
            }
            .frame(width: HomePopupLayout.artworkSize, height: HomePopupLayout.artworkSize)
            .clipShape(.rect(cornerRadius: HomePopupLayout.artworkCornerRadius, style: .continuous))
        }
    }

    private var descriptionSection: some View {
        Text(highlightedDescription)
            .appFont(AppFont.bodyReading, font: .semiFont)
            .foregroundStyle(AppColor.GrayScaleWhite.color)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var statsSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                statRow(title: "당시 조회수", value: data.pastViewCount)
                statRow(title: "현재 조회수", value: data.currentViewCount)
            }
            Spacer()
            HStack(alignment: .bottom, spacing: 4) {
                Text("성장률")
                    .font(AppFont.caption.font())
                    .foregroundStyle(AppColor.GreenNormal.color)
                
                Text(data.growthRate)
                    .font(AppFont.title.font(.boldFont))
                    .foregroundStyle(AppColor.GreenNormal.color)
            }
        }
    }

    private var shareButton: some View {
        Text("공유하기")
            .appFont(AppFont.headline, font: .semiFont)
            .foregroundStyle(AppColor.GrayScaleBlack.color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColor.GreenNormal.color)
            .clipShape(Capsule())
            .asButton(haptic: true, action: onShareTap)
            .accessibilityLabel("공유하기")
    }

    private func statRow(
        title: String,
        value: String,
        valueColor: Color = AppColor.GrayScaleWhite.color
    ) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .appFont(AppFont.caption)
                .foregroundStyle(AppColor.GrayScale300.color)

            Text(value)
                .appFont(AppFont.labelNormal, font: .semiFont)
                .foregroundStyle(valueColor)
        }
    }

    private var highlightedDescription: AttributedString {
        var attributedString = AttributedString(data.description)

        data.highlightedDescriptionTerms.forEach { term in
            if let range = attributedString.range(of: term) {
                attributedString[range].foregroundColor = AppColor.GreenNormal.color
            }
        }

        return attributedString
    }

    private var cardBackground: some View {
        ZStack {
            Image(AppImages.popupBack)
                .resizable()
                .scaledToFill()
                .opacity(HomePopupLayout.backgroundImageOpacity)
            
            AppColor.GrayScaleBlack.color.opacity(HomePopupLayout.backgroundOpacity)
        }
    }
}

private enum HomePopupLayout {
    static let cardMaxWidth: CGFloat = 322
    static let cornerRadius: CGFloat = 30
    static let horizontalPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 20
    static let artworkSize: CGFloat = 120
    static let artworkCornerRadius: CGFloat = 20
    static let backgroundOpacity: CGFloat = 0.9
    static let backgroundImageOpacity: CGFloat = 0.55
    static let statsBackgroundOpacity: CGFloat = 0.72
}

#if DEBUG
#Preview {
    ZStack {
        AppColor.GrayScaleBlack.color
            .ignoresSafeArea()

        HomePopupView(data: .mock)
            .padding(AppSpacing.lg)
    }
}
#endif
