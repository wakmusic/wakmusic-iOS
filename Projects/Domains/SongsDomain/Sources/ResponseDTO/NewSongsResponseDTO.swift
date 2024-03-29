//
//  NewSongsResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface

public struct NewSongsResponseDTO: Decodable {
    public let id, title, artist: String
    public let remix, reaction: String
    public let date: Int
    public let total: NewSongsResponseDTO.Total?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id = "songId"
        case title, artist, remix, reaction, date, total
    }
}

public extension NewSongsResponseDTO {
    struct Total: Codable {
        public let views: Int
        public let last: Int
    }
}

public extension NewSongsResponseDTO {
    func toDomain() -> NewSongsEntity {
        return NewSongsEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: total?.views ?? 0,
            last: total?.last ?? 0,
            date: date
        )
    }
}
