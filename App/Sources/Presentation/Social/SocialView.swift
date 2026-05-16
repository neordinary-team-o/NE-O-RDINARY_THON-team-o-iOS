//
//  SocialView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct SocialView: View {
    @StateObject private var store = StoreOf<SocialReducer>(
        initialState: SocialReducer.State(),
        reducer: SocialReducer()
    )

    var body: some View {
        VStack(spacing: 12) {
            Text(store.state.title)
                .font(.title2.bold())
            Text("Count: \(store.state.count)")
                .foregroundStyle(.secondary)
            Button("소셜 카운트") {
                store.send(.increment)
            }
        }
        .padding()
    }
}

#Preview {
    SocialView()
}
