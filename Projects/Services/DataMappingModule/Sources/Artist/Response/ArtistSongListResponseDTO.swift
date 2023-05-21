//
//  ArtistSongListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ArtistSongListResponseDTO: Codable, Equatable {
    public let ID, title, artist, remix: String
    public let reaction: String
    public let date: Int
    public let total: ArtistSongListResponseDTO.Total?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    enum CodingKeys: String, CodingKey {
        case ID = "songId"
        case title, artist, remix, reaction, date, total
    }
}

public extension ArtistSongListResponseDTO {
    struct Total: Codable {
        public let views: Int
        public let last: Int
    }
}
