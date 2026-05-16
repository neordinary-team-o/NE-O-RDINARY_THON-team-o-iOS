//
//  HomeSearchResultView.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import SwiftUI

struct HomeSearchResultView: View {
    let item: HomeSearchResultItem
    let onDiscoverTap: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: HomeSearchResultLayout.sectionSpacing) {
            VStack(alignment: .center, spacing: AppSpacing.lg) {
                artwork
                    .padding(.horizontal, HomeSearchResultLayout.horizontalPadding)
                metadataSection
            }
            
            discoverButton
        }
        .accessibilityElement(children: .contain)
    }

    private var artwork: some View {
        ZStack {
            NetworkImageView(
                url: item.artworkURL,
                option: .custom(
                    CGSize(width: 320, height: 320)
                )
            )
            .scaledToFill()
            .frame(maxWidth: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .background(AppColor.GrayScale800.color)
        .clipShape(
            .rect(
                cornerRadius: HomeSearchResultLayout.artworkCornerRadius,
                style: .continuous
            )
        )
        .clipped()
    }

    private var metadataSection: some View {
        VStack(alignment: .center, spacing: AppSpacing.md) {
            VStack(alignment: .center, spacing: AppSpacing.xxs) {
                HStack(alignment: .lastTextBaseline, spacing: AppSpacing.sm) {
                    Text(item.title)
                        .appFont(AppFont.title, font: .boldFont)
                        .foregroundStyle(AppColor.GrayScaleWhite.color)

                    Text(item.artist)
                        .appFont(AppFont.labelNormal, font: .semiFont)
                        .foregroundStyle(AppColor.GrayScale300.color)
                }

                Text(item.releasedAtText)
                    .appFont(AppFont.caption)
                    .foregroundStyle(AppColor.GrayScale300.color)
            }

            HStack(alignment: .lastTextBaseline, spacing: AppSpacing.xxs) {
                Text("조회수")
                    .appFont(AppFont.labelNormal, font: .semiFont)
                    .foregroundStyle(AppColor.GrayScale300.color)

                Text(item.viewCountText)
                    .appFont(AppFont.labelNormal, font: .semiFont)
                    .foregroundStyle(AppColor.GrayScaleWhite.color)
            }
        }
        .multilineTextAlignment(.center)
    }

    private var discoverButton: some View {
        HStack(spacing: AppSpacing.xs) {
            Text("발굴하기")
                .appFont(AppFont.headline, font: .semiFont)
                .foregroundStyle(AppColor.GrayScaleBlack.color)

            Image(AppImages.pickAx)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(
                    width: HomeSearchResultLayout.iconSize,
                    height: HomeSearchResultLayout.iconSize
                )
                .foregroundStyle(AppColor.GrayScaleBlack.color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
        .background(AppColor.GreenNormal.color)
        .clipShape(Capsule())
        .contentShape(Rectangle())
        .asButton(haptic: true, action: onDiscoverTap)
        .accessibilityLabel("발굴하기")
    }
}

private enum HomeSearchResultLayout {
    static let horizontalPadding: CGFloat = 24
    static let artworkCornerRadius: CGFloat = 20
    static let sectionSpacing: CGFloat = AppSpacing.xl + AppSpacing.xs
    static let iconSize: CGFloat = 24
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
