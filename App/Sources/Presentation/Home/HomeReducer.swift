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
        var musicGridItems = MusicGridItem.mock
        var selectedPickComplete: PickCompleteEntity?
    }

    enum Action: Hashable {
        case searchTextChanged(String)
        case musicItemTapped(MusicGridItem)
        case pickCompleteDismissed
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                return .none

            case let .musicItemTapped(item):
                guard item.kind != .empty else { return .none }
                state.selectedPickComplete = Self.pickCompleteEntity(from: item)
                return .none

            case .pickCompleteDismissed:
                state.selectedPickComplete = nil
                return .none

            }
        }
    }

    private static func pickCompleteEntity(from item: MusicGridItem) -> PickCompleteEntity {
        PickCompleteEntity(
            id: item.id,
            artworkURL: item.imageURL,
            fallbackImageName: nil,
            musicTitle: item.title,
            artistName: artistName(for: item),
            discoveredDateLabel: "발굴일",
            discoveredDate: "24.03.15",
            elapsedTime: "8개월 경과",
            successDescription: "당신이 12,400명이 듣던 시절 발견한 음악이 지금 5,800만명에게 재생되고 있습니다. 당신의 귀는 시대보다 8개월 빨랐습니다.",
            descriptionHighlights: ["5,800만명", "8개월"],
            previousViewCountLabel: "당시 조회수",
            previousViewCountText: "14,205회",
            currentViewCountLabel: "현재 조회수",
            currentViewCountText: currentViewCountText(for: item),
            growthRate: growthRate(for: item),
            growthLabel: "성장률",
            trendPrefix: "당신은",
            trendLabel: trendLabel(for: item)
        )
    }

    private static func artistName(for item: MusicGridItem) -> String {
        switch item.id {
        case "music-0-plus-0": "한로로"
        case "music-endless-season": "새소년"
        case "music-phonecert": "10CM"
        case "music-extinction": "쏜애플"
        case "music-daisy": "wave to earth"
        case "music-ride": "HYBS"
        case "music-night": "적재"
        default: "한로로"
        }
    }

    private static func currentViewCountText(for item: MusicGridItem) -> String {
        switch item.discoveryPossibility {
        case .high: "58,000,000회"
        case .mid: "2,840,000회"
        case .low: "480,000회"
        }
    }

    private static func growthRate(for item: MusicGridItem) -> String {
        switch item.discoveryPossibility {
        case .high: "+4.723%"
        case .mid: "+1.827%"
        case .low: "+338%"
        }
    }

    private static func trendLabel(for item: MusicGridItem) -> String {
        switch item.discoveryPossibility {
        case .high: "Trend setter!"
        case .mid: "Fast picker!"
        case .low: "Early listener!"
        }
    }
}
