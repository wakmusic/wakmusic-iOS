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
    public let title: String
    public let thumbnail: String?
    public let content: String?
    public let images: [String]
    public let createdAt, startAt, endAt: Double
    public let category: String?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id, category, title, images, thumbnail
        case content = "mainText"
        case createdAt
        case startAt
        case endAt
    }
}
