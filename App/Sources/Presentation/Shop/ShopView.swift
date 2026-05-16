//
//  ShopView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct ShopView: View {
    @Environment(\.navRouter) private var router

    @StateObject private var store = StoreOf<ShopReducer>(
        initialState: ShopReducer.State(),
        reducer: ShopReducer()
    )

    var body: some View {
        VStack(spacing: 12) {
            Text(store.state.title)
                .font(.title2.bold())
            Text("Count: \(store.state.count)")
                .foregroundStyle(.secondary)

            Button("샵 카운트") {
                store.send(.increment)
            }

            Button("설정") {
                router.push(.setting(.root))
            }
        }
        .padding()
    }
}

#Preview {
    ShopView()
}
