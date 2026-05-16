//
//  AppAPIResponseDTO.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import Foundation

struct AppAPIResponseDTO<Response: Decodable & Sendable>: DTO {
    let success: Bool?
    let data: Response?
    let error: AppAPIErrorResponseDTO?
}

struct AppAPIErrorResponseDTO: Decodable, Sendable {
    let code: String?
    let message: String?
}
