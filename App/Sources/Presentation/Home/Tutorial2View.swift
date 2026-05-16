//
//  Tutorial2View.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import SwiftUI

struct Tutorial2View: View {
    @Environment(\.safeAreaInsets) private var safeArea
    let onClose: () -> Void
    let onNext: () -> Void

    init(
        onClose: @escaping () -> Void = {},
        onNext: @escaping () -> Void = {}
    ) {
        self.onClose = onClose
        self.onNext = onNext
    }

    var body: some View {
        ZStack {
            background

            VStack(alignment: .leading, spacing: 0) {
                appBar
                    .padding(.top, safeArea.top)
                    .padding(.bottom, AppSpacing.lg)

                subTitleSection
                    .padding(.horizontal, Tutorial2Layout.horizontalPadding)
                    .padding(.bottom, AppSpacing.xs)

                ScrollView(.vertical, showsIndicators: false) {
                    successCard
                        .padding(.horizontal, Tutorial2Layout.horizontalPadding)
                        .padding(.bottom, AppSpacing.xxl)
                }
            }
        }
    }

    private var background: some View {
        Image(AppImages.background)
            .resizable()
            .scaledToFill()
            .overlay {
                AppColor.GrayScaleBlack.color.opacity(0.72)
            }
            .ignoresSafeArea()
    }

    private var appBar: some View {
        ZStack(alignment: .center) {
            Image(AppImages.topLogo)
                .resizable()
                .frame(width: 91.43, height: 21.84)
                .opacity(0.3)

            HStack {
                Image(AppImages.x)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Tutorial2Layout.iconSize, height: Tutorial2Layout.iconSize)
                    .foregroundStyle(AppColor.GrayScale400.color)
                    .asButton(action: onClose)

                Spacer()

                Image(AppImages.check)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Tutorial2Layout.iconSize, height: Tutorial2Layout.iconSize)
                    .foregroundStyle(AppColor.GrayScale400.color)
                    .asButton(action: onNext)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    private var subTitleSection: some View {
        Text("발굴 성공 카드를 캡쳐할 수 있어요.")
            .appFont(AppFont.headline, font: .semiFont)
            .foregroundStyle(AppColor.GrayScaleWhite.color)
            .multilineTextAlignment(.leading)
    }

    private var successCard: some View {
        VStack(spacing: AppSpacing.xxl + AppSpacing.xs) {
            VStack(spacing: AppSpacing.md) {
                discoveredImage
                badgeText
            }

            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                descriptionText
                statsSection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, AppSpacing.lg)
        .padding(.horizontal, Tutorial2Layout.cardHorizontalPadding)
        .padding(.bottom, AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: Tutorial2Layout.cardRadius, style: .continuous)
                .fill(AppColor.GrayScaleBlack.color.opacity(0.08))
        }
    }

    private var discoveredImage: some View {
        Image(AppImages.grid1)
            .resizable()
            .scaledToFill()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: Tutorial2Layout.discoveryImageMaxWidth)
            .clipShape(.rect(cornerRadius: Tutorial2Layout.imageRadius, style: .continuous))
            .overlay {
                LinearGradient(
                    colors: [
                        AppColor.GrayScaleBlack.color.opacity(0),
                        AppColor.GrayScaleBlack.color.opacity(0.72)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .overlay {
                RadialGradient(
                    colors: [
                        AppColor.GreenNormal.color.opacity(0),
                        AppColor.GreenNormal.color.opacity(0.12)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: Tutorial2Layout.imageGlowRadius
                )
                .blendMode(.screen)
            }
    }

    private var badgeText: some View {
        VStack(spacing: 0) {
            HStack {
                Text("0+0")
                    .appFont(AppFont.title, font: .boldFont)
                    .foregroundStyle(AppColor.GrayScaleWhite.color)
                Text("한로로")
                    .appFont(AppFont.labelNormal)
                    .foregroundStyle(AppColor.GrayScale300.color)
            }
            .padding(.bottom, 2)
            
            HStack(spacing: 4) {
                Text("발굴일")
                    .appFont(AppFont.labelNormal)
                    .foregroundStyle(AppColor.GrayScale300.color)
                
                Text("24.03.15")
                    .appFont(AppFont.labelNormal)
                    .foregroundStyle(AppColor.GrayScale300.color)
            }
            
            Text("8개월 경과")
                .appFont(AppFont.labelNormal, font: .semiFont)
                .foregroundStyle(AppColor.GreenNormal.color)
                .padding(.bottom, AppSpacing.md)
            
            HStack(spacing: AppSpacing.xxs) {
                Text("당신은")
                    .appFont(AppFont.labelNormal, font: .semiFont)
                    .foregroundStyle(AppColor.GrayScale300.color)
                Text("Trend setter!")
                    .appFont(AppFont.labelNormal, font: .semiFont)
                    .foregroundStyle(AppColor.GreenNormal.color)
            }
        }
    }

    private var descriptionText: some View {
        VStack {
            Text(descriptionAttributedString)
                .appFont(AppFont.labelReading, font: .semiFont)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, AppSpacing.lg)
            
            HStack(spacing: 2) {
                Text("당시 조회수")
                    .appFont(AppFont.caption)
                    .foregroundStyle(AppColor.GrayScale300.color)
                Text("14,205회")
                    .appFont(AppFont.caption)
                    .foregroundStyle(AppColor.GrayScale300.color)
                Spacer()
            }
            .padding(.bottom, 2)
            
            HStack(spacing: 2) {
                Text("당시 조회수")
                    .appFont(AppFont.caption)
                    .foregroundStyle(Color.white)
                
                Text("14,205회")
                    .appFont(AppFont.caption)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
        }
    }

    private var descriptionAttributedString: AttributedString {
        var text = AttributedString("당신이 12,400명이 듣던 시절 발견한 음악이 지금 5,800만명에게 재생되고 있습니다. 당신의 귀는 시대보다 8개월 빨랐습니다.")
        text.foregroundColor = AppColor.GrayScale200.color

        if let range = text.range(of: "5,800만명") {
            text[range].foregroundColor = AppColor.GreenNormal.color
        }

        if let range = text.range(of: "8개월") {
            text[range].foregroundColor = AppColor.GreenNormal.color
        }

        return text
    }

    private var statsSection: some View {
        HStack(alignment: .bottom) {
            Text("+4.723%")
                .font(PretendardFont.boldFont.asFont(size: 32))
                .foregroundStyle(AppColor.GreenNormal.color)
            Text("성장률")
                .appFont(AppFont.labelNormal)
                .foregroundStyle(AppColor.GreenNormal.color)
        }
    }
}

private struct Tutorial2CheckRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.xs) {
            Image(AppImages.check)
                .resizable()
                .scaledToFit()
                .frame(width: Tutorial2Layout.checkIconSize, height: Tutorial2Layout.checkIconSize)

            Text(text)
                .appFont(AppFont.labelNormal, font: .semiFont)
                .foregroundStyle(AppColor.GrayScale300.color)
        }
    }
}

private enum Tutorial2Layout {
    static let horizontalPadding: CGFloat = 20
    static let cardHorizontalPadding: CGFloat = 20
    static let iconSize: CGFloat = 32
    static let checkIconSize: CGFloat = 20
    static let logoMaxWidth: CGFloat = 104
    static let discoveryImageMaxWidth: CGFloat = 160
    static let cardRadius: CGFloat = 30
    static let imageRadius: CGFloat = 20
    static let topGlowRadius: CGFloat = 250
    static let imageGlowRadius: CGFloat = 160
}

#if DEBUG
#Preview {
    Tutorial2View()
}
#endif
