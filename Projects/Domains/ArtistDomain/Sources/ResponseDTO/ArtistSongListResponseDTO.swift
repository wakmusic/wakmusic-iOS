//
//  ArtistSongListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import ArtistDomainInterface
import Utility

public struct ArtistSongListResponseDTO: Decodable, Equatable {
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

public extension ArtistSongListResponseDTO {
    func toDomain() -> ArtistSongListEntity {
        ArtistSongListEntity(
            ID: ID,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd"),
            views: total?.views ?? 0,
            last: total?.last ?? 0,
            isSelected: false
        )
    }
}
