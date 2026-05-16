//
//  PickCompleteEntity.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import Foundation

struct PickCompleteEntity: Identifiable, Equatable, Hashable {
    let id: String
    let artworkURL: URL?
    let fallbackImageName: String?
    let musicTitle: String
    let artistName: String
    let discoveredDateLabel: String
    let discoveredDate: String
    let elapsedTime: String
    let successDescription: String
    let descriptionHighlights: [String]
    let previousViewCountLabel: String
    let previousViewCountText: String
    let currentViewCountLabel: String
    let currentViewCountText: String
    let growthRate: String
    let growthLabel: String
    let trendPrefix: String
    let trendLabel: String
}

extension PickCompleteEntity {
    static let mock = PickCompleteEntity(
        id: "music-0-plus-0",
        artworkURL: URL(string: "https://picsum.photos/seed/cmc-music-0-plus-0/424/424"),
        fallbackImageName: nil,
        musicTitle: "0+0",
        artistName: "한로로",
        discoveredDateLabel: "발굴일",
        discoveredDate: "24.03.15",
        elapsedTime: "8개월 경과",
        successDescription: "당신이 12,400명이 듣던 시절 발견한 음악이 지금 5,800만명에게 재생되고 있습니다. 당신의 귀는 시대보다 8개월 빨랐습니다.",
        descriptionHighlights: ["5,800만명", "8개월"],
        previousViewCountLabel: "당시 조회수",
        previousViewCountText: "14,205회",
        currentViewCountLabel: "현재 조회수",
        currentViewCountText: "58,000,000회",
        growthRate: "+4.723%",
        growthLabel: "성장률",
        trendPrefix: "당신은",
        trendLabel: "Trend setter!"
    )
}
