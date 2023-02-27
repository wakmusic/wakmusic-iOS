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

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }

    private enum CodingKeys: String, CodingKey {
        case ID = "id"
        case title = "app_title"
        case name, short, group, description
        case color, youtube, twitch, instagram
    }
}
