//
//  ExerciseRoute.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

enum ExerciseRoute: Hashable {
    case step2(value: String)
    case step3
    case step4(value: String)
}

extension ExerciseRoute {
    @ViewBuilder
    var destination: some View {
        switch self {
        case let .step2(value):
            ExerciseStepView(step: 2, value: value)
        case .step3:
            ExerciseStepView(step: 3, value: nil)
        case let .step4(value):
            ExerciseStepView(step: 4, value: value)
        }
    }
}
