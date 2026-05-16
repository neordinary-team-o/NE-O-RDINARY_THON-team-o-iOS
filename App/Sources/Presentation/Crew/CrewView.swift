//
//  CrewView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct CrewView: View {
    @StateObject private var store = StoreOf<CrewReducer>(
        initialState: CrewReducer.State(),
        reducer: CrewReducer()
    )

    var body: some View {
        VStack(spacing: 12) {
            Text(store.state.title)
                .font(.title2.bold())
            Text("Count: \(store.state.count)")
                .foregroundStyle(.secondary)
            Button("크루 카운트") {
                store.send(.increment)
            }
        }
        .padding()
    }
}

#Preview {
    CrewView()
}
