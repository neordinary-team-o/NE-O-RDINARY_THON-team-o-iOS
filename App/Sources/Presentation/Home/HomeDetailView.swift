//
//  HomeDetailView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct HomeDetailView: View {
    let id: String

    var body: some View {
        VStack(spacing: 12) {
            Text("홈 상세")
                .font(.title2.bold())
            Text("ID: \(id)")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("홈 상세")
    }
}

#Preview {
    NavigationStack {
        HomeDetailView(id: "preview")
    }
}
