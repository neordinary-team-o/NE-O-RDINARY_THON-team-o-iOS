//
//  SearchReducer.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import Foundation

struct SearchReducer: Reducer {
    struct State: Equatable {
        var searchText: String
        var result: HomeSearchResultItem?
        var isChallengeStartPopupPresented: Bool

        init(
            searchText: String = "",
            result: HomeSearchResultItem? = nil,
            isChallengeStartPopupPresented: Bool = false
        ) {
            self.searchText = searchText
            self.result = result
            self.isChallengeStartPopupPresented = isChallengeStartPopupPresented
        }
    }

    enum Action: Hashable {
        case searchTextChanged(String)
        case discoverTapped
        case challengeStartPopupDismissed
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                state.result = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : .mockGangnamStyle
                return .none

            case .discoverTapped:
                state.isChallengeStartPopupPresented = true
                return .none

            case .challengeStartPopupDismissed:
                state.isChallengeStartPopupPresented = false
                return .none
            }
        }
    }
}
