//
//  ExerciseStepView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct ExerciseStepView: View {
    let step: Int
    let value: String?

    @Environment(\.navRouter) private var router

    private var step2Route: AppRoute {
        .exercise(.step2(value: "exercise-step2-value"))
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Exercise Step \(step)")
                .font(.title2.bold())

            if let value {
                Text("value: \(value)")
                    .foregroundStyle(.secondary)
            }

            switch step {
            case 2:
                Button("3으로 이동") {
                    router.push(.exercise(.step3))
                }

                Button("4로 바로 이동") {
                    router.push(.exercise(.step4(value: "exercise-step4-value")))
                }

            case 3:
                Button("4로 이동") {
                    router.push(.exercise(.step4(value: "exercise-step4-value")))
                }

            case 4:
                Button("4 -> 기존 2로 이동") {
                    router.popTo(step2Route)
                }

                Button("4 -> 새 2로 교체") {
                    router.replace(with: [.exercise(.step2(value: "new-exercise-step2-value"))])
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
        .navigationTitle("Exercise Step \(step)")
    }
}

#Preview {
    NavigationStack {
        ExerciseStepView(step: 4, value: "preview")
    }
}
