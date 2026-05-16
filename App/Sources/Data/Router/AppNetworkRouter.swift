//
//  AppNetworkRouter.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import Foundation
import Alamofire

enum AppNetworkRouter: Router {
    case searchSong(SongSearchRequestDTO)
    case createDig(DigCreateRequestDTO)
    case getMyDigs(userId: Int64, page: Int = 0)
    case getDigDetail(digId: Int64)
    case searchMyDigs(userId: Int64, keyword: String)
    case refreshGrowthRate(digId: Int64)

    var method: HTTPMethod {
        switch self {
        case .searchSong, .createDig:
            .post
        case .getMyDigs, .getDigDetail, .searchMyDigs:
            .get
        case .refreshGrowthRate:
            .patch
        }
    }

    var version: String {
        ""
    }

    var path: String {
        switch self {
        case .searchSong:
            "/api/songs/search"
        case .createDig:
            "/api/digs"
        case .getMyDigs:
            "/api/digs"
        case let .getDigDetail(digId):
            "/api/digs/\(digId)"
        case .searchMyDigs:
            "/api/digs/me/search"
        case let .refreshGrowthRate(digId):
            "/api/digs/\(digId)/growth-rate"
        }
    }

    var optionalHeaders: HTTPHeaders? {
        nil
    }

    var parameters: Parameters? {
        switch self {
        case .searchSong, .createDig, .getDigDetail, .refreshGrowthRate:
            nil
        case let .getMyDigs(_, page):
            [
//                "userId": userId,
                "userId": 1,
                "page": page
            ]
        case let .searchMyDigs(userId, keyword):
            [
                "userId": userId,
                "keyword": keyword
            ]
        }
    }

    var body: Data? {
        switch self {
        case let .searchSong(request):
            requestToBody(request)
        case let .createDig(request):
            requestToBody(request)
        case .getMyDigs, .getDigDetail, .searchMyDigs, .refreshGrowthRate:
            nil
        }
    }

    var encodingType: EncodingType {
        switch self {
        case .searchSong, .createDig:
            .json
        case .getMyDigs, .getDigDetail, .searchMyDigs, .refreshGrowthRate:
            .url
        }
    }

    var multipartFormData: MultipartFormData? {
        nil
    }
}
