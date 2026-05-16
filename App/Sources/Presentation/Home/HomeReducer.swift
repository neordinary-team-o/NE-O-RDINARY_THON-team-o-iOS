//
//  HomeReducer.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct HomeReducer: Reducer {
    struct State: Equatable {
        var userName = "홍대병동"
        var searchText = ""
        var musicGridItems = MusicGridItem.mock
        var selectedMusicCard: MusicCardEntity?
        var musicCardReviewText = ""
        var isMusicCardReviewCompleted = false
    }

    enum Action: Hashable {
        case searchTextChanged(String)
        case musicItemTapped(MusicGridItem)
        case musicCardDismissed
        case musicCardReviewTextChanged(String)
        case musicCardReviewSubmitted(String)
        case musicCardReviewEditTapped
        case musicCardShareTapped
        case addMusicTapped
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                return .none

            case .musicItemTapped:
                state.selectedMusicCard = .mock
                return .none

            case .musicCardDismissed:
                state.selectedMusicCard = nil
                return .none

            case let .musicCardReviewTextChanged(text):
                state.musicCardReviewText = text
                state.isMusicCardReviewCompleted = false
                return .none

            case let .musicCardReviewSubmitted(text):
                state.musicCardReviewText = text
                state.isMusicCardReviewCompleted = true
                return .none

            case .musicCardReviewEditTapped:
                state.isMusicCardReviewCompleted = false
                return .none

            case .musicCardShareTapped, .addMusicTapped:
                return .none
            }
        }
    }
}
