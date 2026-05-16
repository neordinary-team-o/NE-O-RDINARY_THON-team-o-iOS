//
//  ShopReducer.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct ShopReducer: Reducer {
    struct State: Equatable {
        var title = "샵"
        var count = 0
    }

    enum Action: Hashable {
        case increment
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .increment:
                state.count += 1
                return .none
            }
        }
    }
}
