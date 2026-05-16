//
//  HomeReducer.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct HomeReducer: Reducer {
    struct State: Equatable {
        var title = "홈"
        var count = 0
    }

    enum Action: Hashable {
        case increment
        case delayedIncrement
        case cancelDelayedIncrement
    }

    enum CancelID: Hashable {
        case delayedIncrement
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .increment:
                state.count += 1
                return .none

            case .delayedIncrement:
                return .run { send in
                    try? await Task.sleep(for: .seconds(1))
                    await send(.increment)
                }
                .cancellable(id: CancelID.delayedIncrement)

            case .cancelDelayedIncrement:
                return .cancel(id: CancelID.delayedIncrement)
            }
        }
    }
}
