//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UserDomainInterface
import SongsDomainInterface

public struct FavoriteSongsResponseDTO: Decodable {
    public let like: Int
    public let id, title, artist, remix, reaction: String
    public let date, start, end: Int
    public let total: FavoriteSongsResponseDTO.Total?

    enum CodingKeys: String, CodingKey {
        case title, artist, remix, reaction, date, start, end, total, like
        case id = "songId"
    }
}

public extension FavoriteSongsResponseDTO {
    struct Total: Codable {
        public let views, last: Int
        public let increase: Int?
    }
}

public extension FavoriteSongsResponseDTO {
    func toDomain() -> FavoriteSongEntity {
        FavoriteSongEntity(
            like: like,
            song: SongEntity(
                id: id,
                title: title,
                artist: artist,
                remix: remix,
                reaction: reaction,
                views: total?.views ?? 0,
                last: total?.last ?? 0,
                date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
            ),
            isSelected: false
        )
    }
}
