//
//  HomePopupData.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import Foundation

struct HomePopupData: Equatable, Hashable {
    let title: String
    let artist: String
    let discoveredDate: String
    let crewName: String
    let description: String
    let pastViewCount: String
    let currentViewCount: String
    let growthRate: String
    let highlightedDescriptionTerms: [String]
    let artworkImageName: String?

    init(
        title: String,
        artist: String,
        discoveredDate: String,
        crewName: String,
        description: String,
        pastViewCount: String,
        currentViewCount: String,
        growthRate: String,
        highlightedDescriptionTerms: [String] = [],
        artworkImageName: String? = nil
    ) {
        self.title = title
        self.artist = artist
        self.discoveredDate = discoveredDate
        self.crewName = crewName
        self.description = description
        self.pastViewCount = pastViewCount
        self.currentViewCount = currentViewCount
        self.growthRate = growthRate
        self.highlightedDescriptionTerms = highlightedDescriptionTerms
        self.artworkImageName = artworkImageName
    }
}

extension HomePopupData {
    static let mock = HomePopupData(
        title: "0+0",
        artist: "한로로",
        discoveredDate: "24.03.15",
        crewName: "홍대병동",
        description: "당신이 12,400명이 듣던 시절 발견한 음악이 지금 5,800만명에게 재생되고 있습니다. 당신의 귀는 시대보다 8개월 빨랐습니다.",
        pastViewCount: "14,205회",
        currentViewCount: "18,891회",
        growthRate: "+4.723%",
        highlightedDescriptionTerms: ["5,800만명", "8개월"]
    )
}
