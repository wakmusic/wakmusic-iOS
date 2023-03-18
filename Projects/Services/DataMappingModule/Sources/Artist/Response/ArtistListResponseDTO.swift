//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ArtistListResponseDTO: Codable, Equatable {
    public let ID, name, short, group: String
    public let title, description: String
    public let color: [[String]]?
    public let youtube, twitch, instagram: String?
    public let imageRoundVersion, imageSquareVersion: Int?
    public let graduated: Bool?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }

    private enum CodingKeys: String, CodingKey {
        case ID = "id"
        case title = "app_title"
        case group = "group_kr"
        case name, short, description
        case color, youtube, twitch, instagram
        case imageRoundVersion = "image_round_version"
        case imageSquareVersion = "image_square_version"
        case graduated
    }
}
