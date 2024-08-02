//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface
import UserDomainInterface
import Utility

public struct FavoriteSongsResponseDTO: Decodable {
    public let songID, title: String
    public let artists: [String]
    public let views, likes: Int
    public let date: Int

    enum CodingKeys: String, CodingKey {
        case title, artists, date, views, likes
        case songID = "videoId"
    }
}

public extension FavoriteSongsResponseDTO {
    func toDomain() -> FavoriteSongEntity {
        FavoriteSongEntity(
            songID: songID,
            title: title,
            artist: artists.joined(separator: ", "),
            like: likes
        )
    }
}
