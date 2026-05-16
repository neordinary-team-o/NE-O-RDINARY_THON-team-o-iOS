//
//  SettingReducer.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct SettingReducer: Reducer {
    struct State: Equatable {
        var title = "설정"
    }

    enum Action: Hashable {
        case appeared
    }

    var reduce: ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .appeared:
                return .none
            }
        }
    }
}
