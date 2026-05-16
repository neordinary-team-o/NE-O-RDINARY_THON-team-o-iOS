//
//  SettingView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var store = StoreOf<SettingReducer>(
        initialState: SettingReducer.State(),
        reducer: SettingReducer()
    )

    var body: some View {
        VStack(spacing: 12) {
            Text(store.state.title)
                .font(.title2.bold())
            Text("공통 설정 화면")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle(store.state.title)
        .onAppear {
            store.send(.appeared)
        }
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
