//
//  FetchNoticeResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct FetchNoticeResponseDTO: Codable, Equatable {
    public let id: Int
    public let category, title: String
    public let thumbnail: String?
    public let content: String?
    public let images: [String]
    public let createAt, startAt, endAt: Double

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id, category, title, images, thumbnail
        case content = "main_text"
        case createAt = "create_at"
        case startAt = "start_at"
        case endAt = "end_at"
    }
}
