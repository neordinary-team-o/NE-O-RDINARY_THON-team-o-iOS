//
//  DigDTO.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import Foundation

struct DigCreateRequestDTO: Encodable, Sendable {
    let userId: Int64
    let videoId: String?
    let title: String
    let artist: String
    let viewCount: Int64
    let uploadDate: String?
    let thumbnailUrl: String?
    let comment: String?

    init(
        userId: Int64,
        videoId: String? = nil,
        title: String,
        artist: String,
        viewCount: Int64,
        uploadDate: String? = nil,
        thumbnailUrl: String? = nil,
        comment: String? = nil
    ) {
//        self.userId = userId
        self.userId = 1
        self.videoId = videoId
        self.title = title
        self.artist = artist
        self.viewCount = viewCount
        self.uploadDate = uploadDate
        self.thumbnailUrl = thumbnailUrl
        self.comment = comment
    }
}

struct DigCreateResponseDTO: Decodable, Sendable {
    let digId: Int64?
    let songId: Int64?
    let title: String?
    let artist: String?
    let thumbnailUrl: String?
    let snapshotViewCount: Int64?
    let currentViewCount: Int64?
    let growthRate: Double?
    let achievementBadge: String?
    let dugAt: String?
}

struct DigCardDTO: Decodable, Sendable {
    let digId: Int64?
    let title: String?
    let thumbnailUrl: String?
}

struct DigSearchDTO: Decodable, Sendable {
    let digId: Int64?
    let thumbnailUrl: String?
    let title: String?
}

struct PageResponseDigCardDTO: Decodable, Sendable {
    let content: [DigCardDTO]?
    let page: Int?
    let size: Int?
    let totalElements: Int64?
    let totalPages: Int?
}

struct DigDetailDTO: Decodable, Sendable {
    let thumbnailUrl: String?
    let title: String?
    let artistName: String?
    let diggedAt: String?
    let elapsedMonths: Int64?
    let achievementName: String?
    let viewCountAtDig: Int64?
    let currentViewCount: Int64?
    let growthRate: Double?
    let narrativeMessage: String?
}

struct EmptyResponseDTO: Decodable, Sendable {}

typealias DigCreateAPIResponseDTO = AppAPIResponseDTO<DigCreateResponseDTO>
typealias MyDigsAPIResponseDTO = AppAPIResponseDTO<PageResponseDigCardDTO>
typealias DigDetailAPIResponseDTO = AppAPIResponseDTO<DigDetailDTO>
typealias SearchMyDigsAPIResponseDTO = AppAPIResponseDTO<[DigSearchDTO]>
typealias RefreshGrowthRateAPIResponseDTO = AppAPIResponseDTO<EmptyResponseDTO>
