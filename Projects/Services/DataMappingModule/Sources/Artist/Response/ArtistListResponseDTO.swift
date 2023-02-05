//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ArtistListResponseDTO: Codable, Equatable {
    let ID, name, short, group: String
    let title, description: String
    let color: [[String]]?
    let youtube, twitch, instagram: String?
    
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }

    private enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name, short, group, title, description
        case color, youtube, twitch, instagram
    }
}
