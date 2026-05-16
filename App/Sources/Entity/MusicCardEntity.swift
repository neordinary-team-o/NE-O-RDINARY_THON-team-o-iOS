//
//  MusicCardEntity.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import Foundation

struct MusicCardEntity: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let artist: String
    let description: String
    let growthRate: String
    let growthLabel: String
    let discoveredDateTitle: String
    let discoveredDate: String
    let elapsedTime: String
}

extension MusicCardEntity {
    static let mock = MusicCardEntity(
        id: "music-0-plus-0",
        title: "0+0",
        artist: "한로로",
        description: "아무것도 가진 게 없는 우리라도, 서로가 함께라면 영원을 꿈꿀 수 있다는 위로와 청춘의 찬가.",
        growthRate: "+4.723%",
        growthLabel: "성장률",
        discoveredDateTitle: "발굴일",
        discoveredDate: "24.03.15",
        elapsedTime: "8개월 경과"
    )
}
