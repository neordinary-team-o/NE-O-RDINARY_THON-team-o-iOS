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
    }

    enum Action: Hashable {
        case searchTextChanged(String)
        case musicItemTapped(MusicGridItem)
        case addMusicTapped
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                return .none

            case .musicItemTapped, .addMusicTapped:
                return .none
            }
        }
    }
}
