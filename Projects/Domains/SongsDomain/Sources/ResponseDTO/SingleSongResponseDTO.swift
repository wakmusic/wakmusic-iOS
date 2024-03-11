//
//  SearchSongResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface
import Utility

public struct SingleSongResponseDTO: Decodable {
    public let id, title, artist, remix, reaction: String
    public let date, start, end: Int
    public let total: SingleSongResponseDTO.Total?

    enum CodingKeys: String, CodingKey {
        case title, artist, remix, reaction, date, start, end, total
        case id = "songId"
    }
}

public extension SingleSongResponseDTO {
    struct Total: Decodable {
        public let views, last: Int
        public let increase: Int?
    }
}

public extension SingleSongResponseDTO {
    func toDomain() -> SongEntity {
        SongEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: total?.views ?? 0,
            last: total?.last ?? 0,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
