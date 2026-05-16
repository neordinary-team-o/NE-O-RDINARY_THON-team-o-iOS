//
//  Tutorial1View.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import SwiftUI

struct Tutorial1View: View {
    
    @Environment(\.safeAreaInsets) var safeArea
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
                    .padding(.horizontal, Tutorial1Layout.horizontalPadding)
                    .padding(.bottom, AppSpacing.xxl)
                
                
                Text("내가 발굴한 곡이에요")
                    .font(AppFont.heading.font(.semiFont))
                    .foregroundStyle(Color.white)
                    .opacity(0.2)
                    .padding(.horizontal, Tutorial1Layout.horizontalPadding)
                    .padding(.bottom, AppSpacing.md)
                
                gridSection
                    .padding(.horizontal, Tutorial1Layout.horizontalPadding)
                
                Spacer()
            }
        }
    }

    private var background: some View {
        Image(AppImages.background)
            .resizable()
            .scaledToFill()
            .overlay {
                AppColor.GrayScaleBlack.color.opacity(0.4)
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
                    .frame(
                        width: 32,
                        height: 32
                    )
                    .foregroundStyle(AppColor.GrayScale400.color)
                    .asButton(action: onClose)
                
                Spacer()

                Image(AppImages.arrowRightWhite)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 32,
                        height: 32
                    )
                    .foregroundStyle(AppColor.GrayScale400.color)
                    .asButton(action: onNext)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    private var subTitleSection: some View {
        Text("홈 화면에서 아티스트를 선택해\n발굴 카드를 확인해요.")
            .appFont(AppFont.headline, font: .semiFont)
            .foregroundStyle(AppColor.GrayScaleWhite.color)
            .multilineTextAlignment(.leading)
            .accessibilityLabel("홈 화면에서 아티스트를 선택해 발굴 카드를 확인해요.")
    }

    private var gridSection: some View {
        Tutorial1GridView(items: Tutorial1GridItem.mock)
            .frame(maxWidth: .infinity)
    }
}

private struct Tutorial1GridItem: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let imageName: String
    let kind: Kind
    let isDimmed: Bool

    enum Kind: Equatable, Hashable {
        case large
        case small
    }
}

private extension Tutorial1GridItem {
    static let mock: [Tutorial1GridItem] = [
        Tutorial1GridItem(
            id: "tutorial-grid-1",
            title: "0+0",
            imageName: AppImages.grid1,
            kind: .large,
            isDimmed: false
        ),
        Tutorial1GridItem(
            id: "tutorial-grid-2",
            title: "끝나지 않는 계절",
            imageName: AppImages.grid2,
            kind: .small,
            isDimmed: true
        ),
        Tutorial1GridItem(
            id: "tutorial-grid-3",
            title: "폰서트",
            imageName: AppImages.grid3,
            kind: .small,
            isDimmed: true
        ),
        Tutorial1GridItem(
            id: "tutorial-grid-4",
            title: "멸종",
            imageName: AppImages.grid4,
            kind: .small,
            isDimmed: true
        ),
        Tutorial1GridItem(
            id: "tutorial-grid-5",
            title: "daisy.",
            imageName: AppImages.grid5,
            kind: .small,
            isDimmed: true
        )
    ]
}

private struct Tutorial1GridView: View {
    let items: [Tutorial1GridItem]

    var body: some View {
        VStack(spacing: Tutorial1GridStyle.spacing) {
            Tutorial1FeaturedGridLayout(spacing: Tutorial1GridStyle.spacing) {
                ForEach(featuredItems) { item in
                    Tutorial1GridCardView(item: item)
                }
            }

            LazyVGrid(columns: columns, spacing: Tutorial1GridStyle.spacing) {
                ForEach(repeatedItems) { item in
                    Tutorial1GridCardView(item: item)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var featuredItems: ArraySlice<Tutorial1GridItem> {
        items.prefix(3)
    }

    private var repeatedItems: ArraySlice<Tutorial1GridItem> {
        items.dropFirst(3)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: Tutorial1GridStyle.spacing),
            count: Tutorial1GridStyle.gridColumnCount
        )
    }
}

private struct Tutorial1GridCardView: View {
    let item: Tutorial1GridItem

    var body: some View {
        ZStack {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if item.isDimmed {
                AppColor.GrayScaleBlack.color
                    .opacity(Tutorial1GridStyle.dimOpacity)
            } else {
                RadialGradient(
                    colors: [
                        AppColor.GreenLight.color.opacity(Tutorial1GridStyle.selectedGlowOpacity),
                        AppColor.GreenLight.color.opacity(0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: Tutorial1GridStyle.selectedGlowEndRadius
                )
                .blendMode(.screen)
            }

            LinearGradient(
                colors: [
                    AppColor.GrayScaleBlack.color.opacity(0),
                    AppColor.GrayScaleBlack.color.opacity(Tutorial1GridStyle.bottomGradientOpacity)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .overlay(alignment: .bottomLeading) {
            Text(item.title)
                .appFont(item.kind == .large ? AppFont.title : AppFont.headline, font: item.kind == .large ? .boldFont : .semiFont)
                .foregroundStyle(AppColor.GrayScaleWhite.color)
                .lineLimit(item.kind == .large ? 2 : 1)
                .minimumScaleFactor(0.82)
                .padding(.horizontal, item.kind == .large ? AppSpacing.lg : AppSpacing.md)
                .padding(.bottom, item.kind == .large ? AppSpacing.lg : AppSpacing.md)
        }
        .clipShape(.rect(cornerRadius: Tutorial1GridStyle.cardRadius, style: .continuous))
        .accessibilityLabel(item.title)
    }
}

private struct Tutorial1FeaturedGridLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        let width = proposal.width ?? 0
        let metrics = metrics(for: width)
        return CGSize(width: width, height: metrics.largeCard)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        guard !subviews.isEmpty else { return }
        let metrics = metrics(for: bounds.width)

        for index in subviews.indices.prefix(3) {
            let frame = frame(
                for: index,
                origin: CGPoint(x: bounds.minX, y: bounds.minY),
                metrics: metrics
            )

            subviews[index].place(
                at: frame.origin,
                anchor: .topLeading,
                proposal: ProposedViewSize(width: frame.width, height: frame.height)
            )
        }
    }

    private func metrics(for width: CGFloat) -> Metrics {
        let smallCard = (width - spacing * 2) / CGFloat(Tutorial1GridStyle.gridColumnCount)
        return Metrics(smallCard: smallCard, largeCard: smallCard * 2 + spacing)
    }

    private func frame(
        for index: Int,
        origin: CGPoint,
        metrics: Metrics
    ) -> CGRect {
        switch index {
        case 0:
            CGRect(
                x: origin.x,
                y: origin.y,
                width: metrics.largeCard,
                height: metrics.largeCard
            )
        case 1, 2:
            CGRect(
                x: origin.x + metrics.largeCard + spacing,
                y: origin.y + CGFloat(index - 1) * (metrics.smallCard + spacing),
                width: metrics.smallCard,
                height: metrics.smallCard
            )
        default:
            .zero
        }
    }

    private struct Metrics {
        let smallCard: CGFloat
        let largeCard: CGFloat
    }
}

private enum Tutorial1Layout {
    static let topPadding: CGFloat = 62
    static let horizontalPadding: CGFloat = 20
    static let appBarHorizontalPadding: CGFloat = 18
    static let logoMaxWidth: CGFloat = 93
    static let profileIconSize: CGFloat = 32
    static let subtitleBottomPadding: CGFloat = 67
    static let bottomPadding: CGFloat = 140
}

private enum Tutorial1GridStyle {
    static let gridColumnCount = 3
    static let spacing: CGFloat = 4
    static let cardRadius: CGFloat = 20
    static let dimOpacity: Double = 0.58
    static let selectedGlowOpacity: Double = 0.33
    static let selectedGlowEndRadius: CGFloat = 260
    static let bottomGradientOpacity: Double = 0.78
}

#if DEBUG
#Preview {
    Tutorial1View()
}
#endif
