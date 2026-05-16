//
//  MusicCard.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import SwiftUI

struct MusicCard: View {
    let entity: MusicCardEntity
    @Binding private var reviewText: String
    @Binding private var isReviewCompleted: Bool
    let onReviewSendTap: (String) -> Void
    let onReviewEditTap: () -> Void
    let onShareTap: () -> Void
    let onCloseTap: () -> Void

    init(
        entity: MusicCardEntity,
        reviewText: Binding<String>,
        isReviewCompleted: Binding<Bool>,
        onReviewSendTap: @escaping (String) -> Void,
        onReviewEditTap: @escaping () -> Void = {},
        onShareTap: @escaping () -> Void = {},
        onCloseTap: @escaping () -> Void = {}
    ) {
        self.entity = entity
        self._reviewText = reviewText
        self._isReviewCompleted = isReviewCompleted
        self.onReviewSendTap = onReviewSendTap
        self.onReviewEditTap = onReviewEditTap
        self.onShareTap = onShareTap
        self.onCloseTap = onCloseTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: MusicCardLayout.sectionSpacing) {
            headerSection
            metricsSection
            reviewSection
        }
        .padding(.horizontal, MusicCardLayout.horizontalPadding)
        .padding(.vertical, MusicCardLayout.verticalPadding)
        .frame(maxWidth: MusicCardLayout.maxWidth)
        .background {
            ZStack {
                BlurView(style: .systemUltraThinMaterialDark)
                AppColor.GrayScale900.color.opacity(MusicCardLayout.backgroundOpacity)
            }
        }
        .clipShape(.rect(cornerRadius: MusicCardLayout.cornerRadius, style: .continuous))
        .shadow(
            color: AppColor.GreenNormal.color.opacity(MusicCardLayout.shadowOpacity),
            radius: MusicCardLayout.shadowRadius,
            x: 0,
            y: MusicCardLayout.shadowYOffset
        )
        .accessibilityElement(children: .contain)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(alignment: .center) {
                HStack(alignment: .lastTextBaseline, spacing: AppSpacing.xs) {
                    Text(entity.title)
                        .appFont(AppFont.heading, font: .semiFont)
                        .foregroundStyle(AppColor.GrayScaleWhite.color)

                    Text(entity.artist)
                        .appFont(AppFont.labelNormal)
                        .foregroundStyle(AppColor.GrayScale300.color)
                }

                Spacer(minLength: AppSpacing.md)

                actionButtons
            }

            Text(entity.description)
                .appFont(AppFont.labelReading)
                .foregroundStyle(AppColor.GrayScale300.color)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(AppImages.share)
                .resizable()
                .scaledToFit()
                .frame(width: MusicCardLayout.iconSize, height: MusicCardLayout.iconSize)
                .asButton(haptic: true, action: onShareTap)
                .accessibilityLabel("공유")

            Image(AppImages.x)
                .resizable()
                .scaledToFit()
                .frame(width: MusicCardLayout.iconSize, height: MusicCardLayout.iconSize)
                .asButton(haptic: true, action: onCloseTap)
                .accessibilityLabel("닫기")
        }
    }

    private var reviewSection: some View {
        CommonSendEditTextField(
            text: $reviewText,
            isCompleted: $isReviewCompleted,
            onSendTap: onReviewSendTap,
            onEditTap: onReviewEditTap
        )
    }

    private var metricsSection: some View {
        HStack(alignment: .bottom) {
            HStack(alignment: .lastTextBaseline, spacing: AppSpacing.xxs) {
                Text(entity.growthRate)
                    .appFont(AppFont.title, font: .boldFont)
                    .foregroundStyle(AppColor.GreenNormal.color)

                Text(entity.growthLabel)
                    .appFont(AppFont.caption)
                    .foregroundStyle(AppColor.GreenNormal.color)
            }

            Spacer(minLength: AppSpacing.md)

            VStack(alignment: .trailing, spacing: AppSpacing.xxs) {
                HStack(spacing: AppSpacing.xxs) {
                    Text(entity.discoveredDateTitle)
                        .appFont(AppFont.caption)
                    Text(entity.discoveredDate)
                        .appFont(AppFont.caption)
                }
                .foregroundStyle(AppColor.GrayScale300.color)

                Text(entity.elapsedTime)
                    .appFont(AppFont.caption)
                    .foregroundStyle(AppColor.GreenNormal.color)
            }
        }
    }
}

private enum MusicCardLayout {
    static let maxWidth: CGFloat = 322
    static let horizontalPadding = AppSpacing.md + AppSpacing.xxs
    static let verticalPadding = AppSpacing.md
    static let sectionSpacing = AppSpacing.lg
    static let cornerRadius: CGFloat = 20
    static let iconSize = AppSpacing.lg
    static let backgroundOpacity = 0.33
    static let shadowOpacity = 0.05
    static let shadowRadius = AppSpacing.xl + AppSpacing.xs
    static let shadowYOffset = AppSpacing.xxs
}

#if DEBUG
#Preview {
    MusicCard(
        entity: .mock,
        reviewText: .constant("가진 게 없어도 함께라면 영원을 꿈꿀 수 있다는 위로."),
        isReviewCompleted: .constant(false),
        onReviewSendTap: { _ in }
    )
        .padding(AppSpacing.lg)
        .background(AppColor.GrayScaleBlack.color)
}
#endif
