//
//  LoginView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct LoginView: View {
    let onLogin: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("로그인")
                .font(.title2.bold())

            Text("버튼을 눌러 앱으로 이동합니다")
                .foregroundStyle(.secondary)

            Button("로그인") {
                onLogin()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    LoginView { }
}
