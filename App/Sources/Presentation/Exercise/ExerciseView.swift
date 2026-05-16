//
//  ExerciseView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct ExerciseView: View {
    
    @StateObject private var store = StoreOf<ExerciseReducer>(
        initialState: ExerciseReducer.State(),
        reducer: ExerciseReducer()
    )
    @State private var testText = ""
    
    @Environment(\.safeAreaInsets) var safeArea

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ExerciseHeroCarouselView(
                        items: store.state.heroItems,
                        selectedIndex: Binding(
                            get: { store.state.selectedHeroIndex },
                            set: { store.send(.heroChanged($0)) }
                        ),
                        categories: store.state.categories
                    )
                }
                

                VStack(spacing: 16) {
                    ExerciseDailyStatsView(stats: store.state.stats)
                    CommonTextField(
                        text: $testText,
                        placeHolder: "예: 온라인 교육 플랫폼 만족도 조사",
                        isActiveMode: true,
                        keyboardType: .default,
                        isSecure: false,
                        isSearch: true
                    )
                    CommonLineChartView(chartData: store.state.monthlyTrendChart)
                }
                .padding(.horizontal, 14)
                .padding(.top, 14)
                .padding(.bottom, 120)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .onAppear {
            store.send(.onAppear)
        }
        .onDisappear {
            store.send(.onDisappear)
        }
    }
}

#if DEBUG
#Preview {
    ExerciseView()
}
#endif
