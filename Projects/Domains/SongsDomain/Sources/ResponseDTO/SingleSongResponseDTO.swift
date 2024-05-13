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
    let songID, title: String
    let artists: [String]
    let date, views, likes: Int

    enum CodingKeys: String, CodingKey {
        case title, artists, date, views, likes
        case songID = "videoId"
    }
}

public extension SingleSongResponseDTO {
    func toDomain() -> SongEntity {
        return SongEntity(
            id: songID,
            title: title,
            artist: artists.joined(separator: ", "),
            remix: "",
            reaction: "",
            views: views,
            last: 0,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
