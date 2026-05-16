//
//  PickCompleteView.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import SwiftUI

struct PickCompleteView: View {
    @Environment(\.safeAreaInsets) private var safeArea

    let entity: PickCompleteEntity
    let onClose: () -> Void
    let onCheck: () -> Void

    init(
        entity: PickCompleteEntity,
        onClose: @escaping () -> Void = {},
        onCheck: @escaping () -> Void = {}
    ) {
        self.entity = entity
        self.onClose = onClose
        self.onCheck = onCheck
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            appBar
                .padding(.bottom, AppSpacing.lg)

            subTitleSection
                .padding(.horizontal, PickCompleteLayout.horizontalPadding)
                .padding(.bottom, AppSpacing.xs)

            ScrollView(.vertical, showsIndicators: false) {
                successCard
                    .padding(.horizontal, PickCompleteLayout.horizontalPadding)
                    .padding(.bottom, AppSpacing.xxl)
            }
        }
        .frame(maxHeight: .infinity)
        .background(background)
    }

    private var background: some View {
        Image(AppImages.background)
            .resizable()
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
    }

    private var appBar: some View {
        ZStack(alignment: .center) {
            Image(AppImages.topLogo)
                .resizable()
                .frame(width: 91.43, height: 21.84)

            HStack {
                Image(AppImages.x)
                    .resizable()
                    .scaledToFit()
                    .frame(width: PickCompleteLayout.iconSize, height: PickCompleteLayout.iconSize)
                    .foregroundStyle(AppColor.GrayScale400.color)
                    .asButton(action: onClose)
                    .accessibilityLabel("닫기")

                Spacer()

                Image(AppImages.check)
                    .resizable()
                    .scaledToFit()
                    .frame(width: PickCompleteLayout.iconSize, height: PickCompleteLayout.iconSize)
                    .foregroundStyle(AppColor.GrayScale400.color)
                    .asButton(action: onCheck)
                    .accessibilityLabel("확인")
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
        .padding(.horizontal, PickCompleteLayout.cardHorizontalPadding)
        .padding(.bottom, AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: PickCompleteLayout.cardRadius, style: .continuous)
                .fill(AppColor.GrayScaleBlack.color.opacity(0.08))
        }
    }

    private var discoveredImage: some View {
        NetworkImageView(
            url: entity.artworkURL,
            option: .custom(CGSize(width: 320, height: 320)),
            fallBackImg: UIImage(named: entity.fallbackImageName ?? AppImages.grid1),
            fallBackGrey: false
        )
        .scaledToFill()
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: PickCompleteLayout.discoveryImageMaxWidth)
        .clipShape(.rect(cornerRadius: PickCompleteLayout.imageRadius, style: .continuous))
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
                endRadius: PickCompleteLayout.imageGlowRadius
            )
            .blendMode(.screen)
        }
        .clipped()
    }

    private var badgeText: some View {
        VStack(spacing: 0) {
            HStack {
                Text(entity.musicTitle)
                    .appFont(AppFont.title, font: .boldFont)
                    .foregroundStyle(AppColor.GrayScaleWhite.color)
                Text(entity.artistName)
                    .appFont(AppFont.labelNormal)
                    .foregroundStyle(AppColor.GrayScale300.color)
            }
            .padding(.bottom, 2)

            HStack(spacing: AppSpacing.xxs) {
                Text(entity.discoveredDateLabel)
                    .appFont(AppFont.labelNormal)
                    .foregroundStyle(AppColor.GrayScale300.color)

                Text(entity.discoveredDate)
                    .appFont(AppFont.labelNormal)
                    .foregroundStyle(AppColor.GrayScale300.color)
            }

            Text(entity.elapsedTime)
                .appFont(AppFont.labelNormal, font: .semiFont)
                .foregroundStyle(AppColor.GreenNormal.color)
                .padding(.bottom, AppSpacing.md)

            HStack(spacing: AppSpacing.xxs) {
                Text(entity.trendPrefix)
                    .appFont(AppFont.labelNormal, font: .semiFont)
                    .foregroundStyle(AppColor.GrayScale300.color)
                Text(entity.trendLabel)
                    .appFont(AppFont.labelNormal, font: .semiFont)
                    .foregroundStyle(AppColor.GreenNormal.color)
            }
        }
        .multilineTextAlignment(.center)
    }

    private var descriptionText: some View {
        VStack {
            Text(descriptionAttributedString)
                .appFont(AppFont.labelReading, font: .semiFont)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, AppSpacing.lg)

            viewCountRow(
                label: entity.previousViewCountLabel,
                value: entity.previousViewCountText,
                color: AppColor.GrayScale300.color
            )
            .padding(.bottom, 2)

            viewCountRow(
                label: entity.currentViewCountLabel,
                value: entity.currentViewCountText,
                color: AppColor.GrayScaleWhite.color
            )
        }
    }

    private func viewCountRow(label: String, value: String, color: Color) -> some View {
        HStack(spacing: 2) {
            Text(label)
                .appFont(AppFont.caption)
                .foregroundStyle(color)

            Text(value)
                .appFont(AppFont.caption)
                .foregroundStyle(color)

            Spacer()
        }
    }

    private var descriptionAttributedString: AttributedString {
        var text = AttributedString(entity.successDescription)
        text.foregroundColor = AppColor.GrayScale200.color

        for highlight in entity.descriptionHighlights {
            if let range = text.range(of: highlight) {
                text[range].foregroundColor = AppColor.GreenNormal.color
            }
        }

        return text
    }

    private var statsSection: some View {
        HStack(alignment: .bottom) {
            Text(entity.growthRate)
                .font(PretendardFont.boldFont.asFont(size: 32))
                .foregroundStyle(AppColor.GreenNormal.color)
            Text(entity.growthLabel)
                .appFont(AppFont.labelNormal)
                .foregroundStyle(AppColor.GreenNormal.color)
        }
    }
}

private enum PickCompleteLayout {
    static let horizontalPadding: CGFloat = 20
    static let cardHorizontalPadding: CGFloat = 20
    static let iconSize: CGFloat = 32
    static let discoveryImageMaxWidth: CGFloat = 160
    static let cardRadius: CGFloat = 30
    static let imageRadius: CGFloat = 20
    static let imageGlowRadius: CGFloat = 160
}

#if DEBUG
#Preview {
    PickCompleteView(entity: .mock)
}
#endif
