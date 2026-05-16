//
//  SongDTO.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import Foundation

struct SongSearchRequestDTO: Encodable, Sendable {
    let keyword: String
}

struct SongSearchResponseDTO: Decodable, Sendable, Equatable, Hashable {
    let videoId: String?
    let title: String?
    let artist: String?
    let viewCount: Int64?
    let uploadDate: String?
    let thumbnailUrl: String?
}

typealias SongSearchAPIResponseDTO = AppAPIResponseDTO<SongSearchResponseDTO>
