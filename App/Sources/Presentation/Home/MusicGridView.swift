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
    let discoveryPossibility: DiscoveryPossibility
    let kind: Kind

    enum DiscoveryPossibility: Equatable, Hashable {
        case high
        case mid
        case low
    }

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
            discoveryPossibility: .high,
            kind: .large
        ),
        MusicGridItem(
            id: "music-endless-season",
            title: "끝나지 않는 계절 이에요",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-endless-season/208/208"),
            discoveryPossibility: .mid,
            kind: .small
        ),
        MusicGridItem(
            id: "music-phonecert",
            title: "폰서트",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-phonecert/208/208"),
            discoveryPossibility: .low,
            kind: .small
        ),
        MusicGridItem(
            id: "music-extinction",
            title: "멸종",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-extinction/208/208"),
            discoveryPossibility: .high,
            kind: .small
        ),
        MusicGridItem(
            id: "music-daisy",
            title: "daisy.",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-daisy/208/208"),
            discoveryPossibility: .mid,
            kind: .small
        ),
        MusicGridItem(
            id: "music-ride",
            title: "Ride",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-ride/208/208"),
            discoveryPossibility: .low,
            kind: .small
        ),
        MusicGridItem(
            id: "music-night",
            title: "Night Walk",
            imageURL: URL(string: "https://picsum.photos/seed/cmc-music-night-walk/208/208"),
            discoveryPossibility: .mid,
            kind: .small
        ),
        MusicGridItem(
            id: "music-empty",
            title: "",
            imageURL: nil,
            discoveryPossibility: .low,
            kind: .empty
        )
    ]
}

struct MusicGridView: View {
    let items: [MusicGridItem]
    let selectedItemID: MusicGridItem.ID?
    let onTap: (MusicGridItem) -> Void
    let onAddTap: () -> Void

    init(
        items: [MusicGridItem] = MusicGridItem.mock,
        selectedItemID: MusicGridItem.ID? = nil,
        onAddTap: @escaping () -> Void = {},
        onTap: @escaping (MusicGridItem) -> Void
    ) {
        self.items = items
        self.selectedItemID = selectedItemID
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
                    MusicGridCardView(
                        item: item,
                        displayState: displayState(for: item),
                        onTap: onTap
                    )
                }
            }
        }
    }

    private var repeatedGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: AppSpacing.xxs) {
            ForEach(repeatedItems) { item in
                MusicGridCardView(
                    item: item,
                    displayState: displayState(for: item),
                    onTap: onTap
                )
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

    private func displayState(for item: MusicGridItem) -> MusicGridCardDisplayState {
        guard item.kind != .empty else { return .default }
        guard let selectedItemID else { return .default }
        return selectedItemID == item.id ? .selected : .unselected
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
    @Environment(\.isMusicGridCardPressed) private var isPressed

    let item: MusicGridItem
    let displayState: MusicGridCardDisplayState
    let onTap: (MusicGridItem) -> Void

    var body: some View {
        cardContent
            .asButton(haptic: true, style: MusicGridCardButtonStyle()) {
                onTap(item)
            }
            .accessibilityLabel(item.accessibilityLabel)
    }

    private var cardContent: some View {
        ZStack {
            cardBackground
        }
        .overlay {
            possibilityGlow
        }
        .overlay {
            stateOverlay
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

    private var effectiveDisplayState: MusicGridCardDisplayState {
        isPressed && item.imageURL != nil ? .pressed : displayState
    }

    @ViewBuilder
    private var possibilityGlow: some View {
        let glowOpacity = effectiveDisplayState.glowOpacity(for: item.discoveryPossibility)

        if item.imageURL != nil, glowOpacity > 0 {
            RadialGradient(
                colors: [
                    AppColor.GreenNormal.color.opacity(glowOpacity),
                    AppColor.GreenNormal.color.opacity(0)
                ],
                center: .topTrailing,
                startRadius: MusicGridStyle.glowStartRadius,
                endRadius: item.kind == .large ? MusicGridStyle.largeGlowEndRadius : MusicGridStyle.smallGlowEndRadius
            )
            .blendMode(.screen)
        }
    }

    @ViewBuilder
    private var stateOverlay: some View {
        if item.imageURL != nil {
            ZStack {
                AppColor.GrayScaleBlack.color
                    .opacity(effectiveDisplayState.imageDimOpacity)

                if effectiveDisplayState.selectedHighlightOpacity > 0 {
                    RadialGradient(
                        colors: [
                            AppColor.GreenLight.color.opacity(effectiveDisplayState.selectedHighlightOpacity),
                            AppColor.GreenLight.color.opacity(0)
                        ],
                        center: .center,
                        startRadius: MusicGridStyle.glowStartRadius,
                        endRadius: item.kind == .large ? MusicGridStyle.largeGlowEndRadius : MusicGridStyle.smallGlowEndRadius
                    )
                    .blendMode(.screen)
                }

                if effectiveDisplayState.greenTintOpacity > 0 {
                    AppColor.GreenNormal.color
                        .opacity(effectiveDisplayState.greenTintOpacity)
                        .blendMode(.screen)
                }
            }
        }
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

private enum MusicGridCardDisplayState: Equatable {
    case `default`
    case selected
    case pressed
    case unselected

    var imageDimOpacity: Double {
        switch self {
        case .default, .selected, .pressed:
            MusicGridStyle.imageDimOpacity
        case .unselected:
            MusicGridStyle.unselectedDimOpacity
        }
    }

    var greenTintOpacity: Double {
        switch self {
        case .selected:
            MusicGridStyle.selectedTintOpacity
        case .pressed:
            MusicGridStyle.pressedTintOpacity
        case .default, .unselected:
            0
        }
    }

    var selectedHighlightOpacity: Double {
        self == .selected ? MusicGridStyle.selectedHighlightOpacity : 0
    }

    func glowOpacity(for possibility: MusicGridItem.DiscoveryPossibility) -> Double {
        switch self {
        case .pressed:
            MusicGridStyle.midGlowOpacity
        case .selected:
            MusicGridStyle.selectedGlowOpacity
        case .default, .unselected:
            possibility.glowOpacity
        }
    }
}

private extension MusicGridItem.DiscoveryPossibility {
    var glowOpacity: Double {
        switch self {
        case .high:
            MusicGridStyle.highGlowOpacity
        case .mid:
            MusicGridStyle.midGlowOpacity
        case .low:
            MusicGridStyle.lowGlowOpacity
        }
    }
}

private struct MusicGridCardButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: configuration.trigger) {
            configuration.label
        }
        .buttonStyle(MusicGridCardPressStateStyle())
    }
}

private struct MusicGridCardPressStateStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .environment(\.isMusicGridCardPressed, configuration.isPressed)
    }
}

private struct MusicGridCardPressedKey: EnvironmentKey {
    static let defaultValue = false
}

private extension EnvironmentValues {
    var isMusicGridCardPressed: Bool {
        get { self[MusicGridCardPressedKey.self] }
        set { self[MusicGridCardPressedKey.self] = newValue }
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
    static let unselectedDimOpacity = 0.66
    static let pressedTintOpacity = 0.1
    static let selectedTintOpacity = 0.18
    static let selectedHighlightOpacity = 0.38
    static let highGlowOpacity = 0.38
    static let midGlowOpacity = 0.18
    static let lowGlowOpacity = 0.04
    static let selectedGlowOpacity = 0.3
    static let glowStartRadius: CGFloat = 0
    static let smallGlowEndRadius: CGFloat = 150
    static let largeGlowEndRadius: CGFloat = 280
    static let gradientOpacity = 0.78
}

#if DEBUG
#Preview {
    MusicGridView { _ in }
        .padding(AppSpacing.md)
        .background(AppColor.GrayScaleBlack.color)
}
#endif
