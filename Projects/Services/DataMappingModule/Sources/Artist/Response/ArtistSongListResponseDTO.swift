//
//  ArtistSongListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ArtistSongListResponseDTO: Codable, Equatable {
    let ID, title, artist, remix: String
    let reaction: String
    let date, views, last: Int
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }

    private enum CodingKeys: String, CodingKey {
        case ID = "id"
        case title, artist, remix, reaction
        case date, views, last
    }
}
