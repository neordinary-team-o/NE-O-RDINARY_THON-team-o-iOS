//
//  HomeView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.navRouter) private var router

    @StateObject private var store = StoreOf<HomeReducer>(
        initialState: HomeReducer.State(),
        reducer: HomeReducer()
    )

    var body: some View {
        VStack(spacing: 12) {
            Text(store.state.title)
            Text("Count: \(store.state.count)")

            Text("Increment")
                .font(PretendardFont.boldFont.asFont(size: 24))
                .asButton {
                    store.send(.increment)
                }

            Button("자세히") {
                router.push(.home(.detail(id: "home-detail")))
            }

            Button("설정") {
                router.push(.setting(.root))
            }

            Button("2로 이동") {
                router.push(.home(.step2(value: "step2-value")))
            }

            Button("2 -> 3 -> 4 구성") {
                router.replace(with: [
                    .home(.step2(value: "step2-value")),
                    .home(.step3),
                    .home(.step4(value: "step4-value"))
                ])
            }

            Button("Delayed Increment") {
                store.send(.delayedIncrement)
            }

            Button("Cancel") {
                store.send(.cancelDelayedIncrement)
            }
        }
    }
}

#Preview {
    HomeView()
}
