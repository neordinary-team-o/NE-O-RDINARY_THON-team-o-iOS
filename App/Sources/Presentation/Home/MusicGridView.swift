//
//  MusicGridView.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import SwiftUI

struct MusicGridItem: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let imageURL: URL?
    let kind: Kind

    enum Kind: Equatable, Hashable {
        case large
        case small
        case empty
    }
}

extension MusicGridItem {
    static let mock: [MusicGridItem] = [
        MusicGridItem(
            id: "music-0-plus-0",
            title: "0+0",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-0-plus-0/424/424"),
            kind: .large
        ),
        MusicGridItem(
            id: "music-endless-season",
            title: "끝나지 않는 계절 이에요",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-endless-season/208/208"),
            kind: .small
        ),
        MusicGridItem(
            id: "music-phonecert",
            title: "폰서트",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-phonecert/208/208"),
            kind: .small
        ),
        MusicGridItem(
            id: "music-extinction",
            title: "멸종",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-extinction/208/208"),
            kind: .small
        ),
        MusicGridItem(
            id: "music-daisy",
            title: "daisy.",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-daisy/208/208"),
            kind: .small
        ),
        MusicGridItem(
            id: "music-ride",
            title: "Ride",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-ride/208/208"),
            kind: .small
        ),
        MusicGridItem(
            id: "music-night",
            title: "Night Walk",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-night-walk/208/208"),
            kind: .small
        ),
        MusicGridItem(
            id: "music-empty",
            title: "",
            imageURL: nil,
            kind: .empty
        )
    ]
}

struct MusicGridView: View {
    let items: [MusicGridItem]
    let onTap: (MusicGridItem) -> Void
    let onAddTap: () -> Void

    init(
        items: [MusicGridItem] = MusicGridItem.mock,
        onAddTap: @escaping () -> Void = {},
        onTap: @escaping (MusicGridItem) -> Void
    ) {
        self.items = items
        self.onAddTap = onAddTap
        self.onTap = onTap
    }

    var body: some View {
        VStack(spacing: AppSpacing.xxs) {
            featuredSection
            repeatedGrid
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var featuredSection: some View {
        if !featuredItems.isEmpty {
            MusicGridFeaturedLayout(spacing: AppSpacing.xxs) {
                ForEach(featuredItems) { item in
                    MusicGridCardView(item: item, onTap: onTap)
                }
            }
        }
    }

    private var repeatedGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: AppSpacing.xxs) {
            ForEach(repeatedItems) { item in
                MusicGridCardView(item: item, onTap: onTap)
                    .aspectRatio(1, contentMode: .fit)
            }

            MusicGridAddCardView(onTap: onAddTap)
                .aspectRatio(1, contentMode: .fit)
        }
    }

    private var featuredItems: ArraySlice<MusicGridItem> {
        items.prefix(3)
    }

    private var repeatedItems: ArraySlice<MusicGridItem> {
        items.dropFirst(3)
    }

    private var gridColumns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: AppSpacing.xxs),
            count: MusicGridStyle.gridColumnCount
        )
    }
}

private struct MusicGridAddCardView: View {
    let onTap: () -> Void

    var body: some View {
        ZStack {
            AppColor.GrayScale900.color

            Image(AppImages.plus)
                .font(.system(size: MusicGridStyle.plusIconSize, weight: .semibold))
                .foregroundStyle(AppColor.GrayScaleWhite.color)
        }
        .clipShape(.rect(cornerRadius: MusicGridStyle.cardRadius, style: .continuous))
        .asButton(haptic: true, action: onTap)
        .accessibilityLabel("음악 추가")
    }
}

private struct MusicGridCardView: View {
    let item: MusicGridItem
    let onTap: (MusicGridItem) -> Void

    var body: some View {
        cardContent
            .asButton(haptic: true) {
                onTap(item)
            }
            .accessibilityLabel(item.accessibilityLabel)
    }

    private var cardContent: some View {
        ZStack {
            cardBackground
        }
        .overlay {
            if item.imageURL != nil {
                AppColor.GrayScaleBlack.color
                    .opacity(MusicGridStyle.imageDimOpacity)
            }
        }
        .overlay(alignment: .bottom) {
            if item.imageURL != nil {
                LinearGradient(
                    colors: [
                        AppColor.GrayScaleBlack.color.opacity(0),
                        AppColor.GrayScaleBlack.color.opacity(MusicGridStyle.gradientOpacity)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .overlay(alignment: .bottomLeading) {
            titleText
        }
        .clipShape(.rect(cornerRadius: MusicGridStyle.cardRadius, style: .continuous))
    }

    @ViewBuilder
    private var cardBackground: some View {
        if let imageURL = item.imageURL {
            NetworkImageView(
                url: imageURL,
                option: .max
            )
            .scaledToFill()
        } else {
            AppColor.GrayScale900.color
        }
    }

    @ViewBuilder
    private var titleText: some View {
        if !item.title.isEmpty {
            Text(item.title)
                .appFont(item.titleStyle, font: item.titleFont)
                .foregroundStyle(AppColor.GrayScaleWhite.color)
                .lineLimit(item.kind == .large ? 2 : 1)
                .minimumScaleFactor(0.82)
                .padding(.horizontal, item.kind == .large ? AppSpacing.lg : AppSpacing.sm)
                .padding(.bottom, item.kind == .large ? AppSpacing.lg : AppSpacing.sm)
        }
    }
}

private struct MusicGridFeaturedLayout: Layout {
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
        let visibleRange = subviews.indices.prefix(3)

        for index in visibleRange {
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
        let smallCard = (width - spacing * 2) / CGFloat(MusicGridStyle.gridColumnCount)
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

private extension MusicGridItem {
    var titleStyle: AppFontStyle {
        kind == .large ? AppFont.title : AppFont.headline
    }

    var titleFont: PretendardFont {
        kind == .large ? .boldFont : .semiFont
    }

    var accessibilityLabel: String {
        switch kind {
        case .empty:
            "빈 음악 슬롯"
        case .large, .small:
            title
        }
    }
}

private enum MusicGridStyle {
    static let gridColumnCount = 3
    static let cardRadius: CGFloat = 20
    static let plusIconSize: CGFloat = 28
    static let imageDimOpacity = 0.12
    static let gradientOpacity = 0.78
}

#if DEBUG
#Preview {
    MusicGridView { _ in }
        .padding(AppSpacing.md)
        .background(AppColor.GrayScaleBlack.color)
}
#endif
