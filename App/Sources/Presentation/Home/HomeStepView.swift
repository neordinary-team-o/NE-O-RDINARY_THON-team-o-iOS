//
//  HomeStepView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct HomeStepView: View {
    let step: Int
    let value: String?

    @Environment(\.navRouter) private var router

    private var step2Route: AppRoute {
        .home(.step2(value: "step2-value"))
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Home Step \(step)")
                .font(.title2.bold())

            if let value {
                Text("value: \(value)")
                    .foregroundStyle(.secondary)
            }

            switch step {
            case 2:
                Button("3으로 이동") {
                    router.push(.home(.step3))
                }

                Button("4로 바로 이동") {
                    router.push(.home(.step4(value: "step4-value")))
                }

            case 3:
                Button("4로 이동") {
                    router.push(.home(.step4(value: "step4-value")))
                }

            case 4:
                Button("4 -> 기존 2로 이동") {
                    router.popTo(step2Route)
                }

                Button("4 -> 새 2로 교체") {
                    router.replace(with: [.home(.step2(value: "new-step2-value"))])
                }

                Button("2번 뒤로") {
                    router.popLast(2)
                }

                Button("3번 뒤로") {
                    router.popLast(3)
                }

                Button("Home으로 이동") {
                    router.popToRoot()
                }

            default:
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Step \(step)")
    }
}

#Preview {
    NavigationStack {
        HomeStepView(step: 4, value: "preview")
    }
}
