//
//  HomeReducer.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct HomeSearchResultItem: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let artist: String
    let releasedAtText: String
    let viewCountText: String
    let artworkURL: URL?
}

extension HomeSearchResultItem {
    static let mockGangnamStyle = HomeSearchResultItem(
        id: "search-gangnam-style",
        title: "강남스타일",
        artist: "PSY",
        releasedAtText: "12.07.15",
        viewCountText: "18,891회",
        artworkURL: URL(string: "https://picsum.photos/seed/cmc-gangnam-style/544/544")
    )
}

struct HomeReducer: Reducer {
    struct State: Equatable {
        var userName = "홍대병동"
        var searchText = ""
        var searchResult: HomeSearchResultItem?
        var musicGridItems = MusicGridItem.mock
        var selectedMusicCard: MusicCardEntity?
        var musicCardReviewText = ""
        var isMusicCardReviewCompleted = false
        var isMusicCardSharePopupPresented = false

        var hasSearchResult: Bool {
            !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && searchResult != nil
        }
    }

    enum Action: Hashable {
        case searchTextChanged(String)
        case searchResultDiscoverTapped
        case musicItemTapped(MusicGridItem)
        case musicCardDismissed
        case musicCardReviewTextChanged(String)
        case musicCardReviewSubmitted(String)
        case musicCardReviewEditTapped
        case musicCardShareTapped
        case musicCardSharePopupDismissed
        case addMusicTapped
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                state.searchResult = trimmedText.isEmpty ? nil : .mockGangnamStyle
                return .none

            case .searchResultDiscoverTapped:
                return .none

            case .musicItemTapped:
                state.selectedMusicCard = .mock
                return .none

            case .musicCardDismissed:
                state.selectedMusicCard = nil
                state.isMusicCardSharePopupPresented = false
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

            case .musicCardShareTapped:
                state.isMusicCardSharePopupPresented = true
                return .none

            case .musicCardSharePopupDismissed:
                state.isMusicCardSharePopupPresented = false
                return .none

            case .addMusicTapped:
                return .none
            }
        }
    }
}
