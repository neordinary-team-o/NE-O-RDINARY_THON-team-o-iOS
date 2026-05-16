//
//  ExerciseHeroCarouselView.swift
//  App
//
//  Created by OpenCode on 5/15/26.
//

import SwiftUI

struct ExerciseHeroCarouselView: View {
    let items: [HeroItem]
    @Binding var selectedIndex: Int
    let categories: [CategoryItem]
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        ExerciseHeroImageView(item: item)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
                .offset(x: -CGFloat(selectedIndex) * proxy.size.width + dragOffset)
                .animation(.easeInOut(duration: 0.32), value: selectedIndex)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            updateSelectedIndex(
                                translation: value.translation.width,
                                width: proxy.size.width
                            )
                        }
                )
            }
            .clipped()
            .frame(height: 500)

            VStack(alignment: .trailing, spacing: 12) {
                carouselCountView

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories) { category in
                            ExerciseCategoryPillView(category: category)
                        }
                    }
                    .padding(.horizontal, 18)
                }
            }
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
    }

    private var carouselCountView: some View {
        Text("\(selectedIndex + 1) / \(items.count)")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.black.opacity(0.34), in: Capsule())
            .padding(.trailing, 18)
    }

    private func updateSelectedIndex(translation: CGFloat, width: CGFloat) {
        guard width > 0 else { return }

        let threshold = width * 0.22
        if translation < -threshold {
            selectedIndex = min(selectedIndex + 1, items.count - 1)
        } else if translation > threshold {
            selectedIndex = max(selectedIndex - 1, 0)
        }
    }
}

private struct ExerciseHeroImageView: View {
    let item: HeroItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NetworkImageView(
                url: item.imageURL,
                option: .custom(CGSize(width: UIScreen.main.bounds.width, height: 500))
            )
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()

            LinearGradient(
                colors: [.black.opacity(0.18), .black.opacity(0.18), .black.opacity(0.78)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 12) {
                    Text(item.badge)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.38), in: RoundedRectangle(cornerRadius: 4))

                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.title)
                            .font(.system(size: 23, weight: .heavy))
                            .foregroundStyle(.white)

                        Text(item.subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.white.opacity(0.86))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 82)
            }
        }
    }
}

private struct ExerciseCategoryPillView: View {
    let category: CategoryItem

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: category.icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(iconColor)

            Text(category.title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(.white.opacity(0.26), in: Capsule())
    }

    private var iconColor: Color {
        switch category.id {
        case 1: .orange
        case 2: .white.opacity(0.82)
        case 3: .white
        default: .black.opacity(0.7)
        }
    }
}

#if DEBUG
#Preview {
    ExerciseHeroCarouselView(
        items: HeroItem.mock,
        selectedIndex: .constant(0),
        categories: CategoryItem.mock
    )
    .background(Color.black)
}
#endif
